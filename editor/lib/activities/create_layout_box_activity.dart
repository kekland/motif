import 'dart:math' as math;

import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

sealed class CreateLayoutBoxActivity<S extends LayoutBoxStatement> extends DragActivity
    with KeyboardListenerDragActivity {
  CreateLayoutBoxActivity(
    this.editor, {
    this.edgeStyle = .none,
    this.faceStyle = .default_,
    this.snapToPixel = false,
    this.onCreated,
    super.onEnd,
    super.onCancel,
  });

  final Editor editor;
  final EdgeStyle edgeStyle;
  final FaceStyle faceStyle;
  final bool snapToPixel;
  final void Function(FrameRef)? onCreated;

  late final Vec2 startPosition;
  late final S statement;

  SceneTransaction? transaction;
  final mergeKey = Object();

  S create(Vec2 position, FrameRef? parent);
  Size2 get defaultSize => .new(100, 100);

  S createOnTap(Mat4 transform, Size2 size) => statement.copyWith(
    transform: transform,
    size: .fixed(size.width, size.height),
  ) as S;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    transaction = editor.beginTransaction();
    final hitTest = editor.hitTest(details.globalPosition);

    FrameRef? parent;
    for (final frame in hitTest.frames) {
      final id = frame.statementId;
      final statement = editor.statement(id);
      if (statement is ContainerStatement) {
        parent = statement.frame;
        break;
      }
    }

    var localPosition = editor.globalToLocal(parent, details.globalPosition);
    if (snapToPixel) localPosition = localPosition.round();
    startPosition = localPosition;

    statement = create(startPosition, parent);
    transaction!.insert(statement);
    transaction!.flush();
    editor.selection.set(statement.frame);
    onCreated?.call(statement.frame);
  }

  void _update(LayoutBoxStatement newStatement) {
    transaction!.replace(statement.id, [newStatement]);
    transaction!.flush();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final parent = statement.parent?.ref;
    final a = startPosition;
    var d = editor.globalToLocal(parent, details.globalPosition) - a;
    if (snapToPixel) d = d.round();

    if (isShiftPressed) {
      final side = math.max(d.x.abs(), d.y.abs());
      d = Vec2(side * d.x.sign, side * d.y.sign);
    }

    final aabb = isAltPressed ? Aabb2.bbox2(a - d, a + d) : Aabb2.bbox2(a, a + d);

    _update(
      statement.copyWith(
        transform: .translation2(aabb.min),
        size: .fixed(aabb.width, aabb.height),
      ),
    );
  }

  @override
  void onEnd(DragEndDetails details) {
    if (didTap) {
      final size = defaultSize;
      final translation = startPosition - (size.vec / 2);
      _update(createOnTap(.translation2(translation), size));
    }

    transaction!.commit(mergeKey: mergeKey);
    editor.tool.activeTool = tools.cursor;
    super.onEnd(details);
  }

  @override
  void onCancel() {
    transaction?.cancel();
    super.onCancel();
  }
}

final class CreateContainerActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle,
  super.faceStyle,
  super.onCreated,
  super.onEnd,
  super.onCancel,
}) extends CreateLayoutBoxActivity<ContainerStatement> {
  @override
  ContainerStatement create(Vec2 position, FrameRef? parent) => ContainerStatement(
    transform: .translation2(position),
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}

final class CreateRectangleActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle,
  super.faceStyle,
  super.onCreated,
  super.onEnd,
  super.onCancel,
}) extends CreateLayoutBoxActivity<RectangleStatement> {
  @override
  RectangleStatement create(Vec2 position, FrameRef? parent) => RectangleStatement(
    transform: .translation2(position),
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}

final class CreateEllipseActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle,
  super.faceStyle,
  super.onCreated,
  super.onEnd,
  super.onCancel,
}) extends CreateLayoutBoxActivity<EllipseStatement> {
  @override
  EllipseStatement create(Vec2 position, FrameRef? parent) => EllipseStatement(
    transform: .translation2(position),
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}

final class CreatePolygonActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle,
  super.faceStyle,
  super.onCreated,
  super.onEnd,
  super.onCancel,
}) extends CreateLayoutBoxActivity<PolygonStatement> {
  @override
  PolygonStatement create(Vec2 position, FrameRef? parent) => PolygonStatement(
    transform: .translation2(position),
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}

final class CreateTextActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle = .none,
  super.faceStyle,
  super.onCreated,
  super.onEnd,
  super.onCancel,
}) extends CreateLayoutBoxActivity<TextStatement> {
  @override
  Size2 get defaultSize => statement.intrinsicSize(editor.evaluation);

  final textFormat = TextFormat.default_(editor.builtinFonts.catalog);

  @override
  void onStart(PositionedGestureDetails details) {
    final asset = editor.builtinFonts.catalog.assets[textFormat.fontFamily.hash]!;
    editor.maybeAddAsset(asset);

    super.onStart(details);
  }

  @override
  TextStatement createOnTap(Mat4 transform, Size2 size) {
    return statement.copyWith(
      transform: transform,
      size: .contain(),
    );
  }

  @override
  TextStatement create(Vec2 position, FrameRef? parent) => TextStatement(
    text: '',
    transform: .translation2(position),
    textFormat: .default_(editor.builtinFonts.catalog),
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
    parent: parent,
  );

  @override
  void onEnd(DragEndDetails details) {
    editor.cursorTextEditStatement = statement.id;
    super.onEnd(details);
  }
}
