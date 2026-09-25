import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

abstract class TransformActivity extends DragActivity with ExclusiveCursorDragActivity, KeyboardListenerDragActivity {
  TransformActivity(
    this.editor,
    this.refs, {
    super.onStart,
    super.onUpdate,
    super.onEnd,
    super.onCancel,
  });

  final Editor editor;
  Scene get scene => editor.scene;
  Evaluation get evaluation => scene.evaluation;

  final Iterable<Ref> refs;

  @override
  Set<LogicalKeyboardKey> get keysToListen => {.shiftLeft, .shiftRight, .altLeft, .altRight};

  SceneTransaction? txn;
  late TransformSession session;
  final mergeKey = Object();

  Mat4 get worldToSpace => session.worldToSpace;
  Mat4 get spaceToWorld => session.spaceToWorld;
  Aabb2 get initialHull => session.initialHull;

  bool get hasLayoutBoxes => layoutBoxIds != null && layoutBoxIds!.isNotEmpty;
  int get layoutBoxCount => layoutBoxIds?.length ?? 0;
  List<StatementId>? layoutBoxIds;
  Iterable<LayoutBoxStatement> get layoutBoxes =>
      layoutBoxIds!.map((id) => evaluation.statement<LayoutBoxStatement>(id)!);

  List<StatementId> _resolveSelectedLayoutBoxes() {
    final statements = <StatementId>{};
    for (final id in session.absorbers) {
      final statement = evaluation.statement(id);
      if (statement is LayoutBox) {
        final parent = (statement as LayoutBox).parentId;
        if (parent == null || evaluation.statement(parent) is LayoutBox) {
          statements.add(id);
        }
      }
    }
    return statements.toList()..sort(evaluation.evalOrder);
  }

  @override
  void onStart(PositionedGestureDetails details) {
    txn = scene.beginTransaction();
    session = .of(editor.scene, refs, transaction: txn, mergeKey: mergeKey);
    layoutBoxIds = _resolveSelectedLayoutBoxes();

    super.onStart(details);
  }

  @override
  void onEnd(DragEndDetails details) {
    txn!.commit(mergeKey: mergeKey);
    super.onEnd(details);
  }

  @override
  void onCancel() {
    txn?.cancel();
    super.onCancel();
  }

  MouseCursor resolveCursor();

  MouseCursor resolveRotatingCursor(RotatingMouseCursor cursor, {Side? side, Corner? corner, Mat4? transform}) {
    final globalToScene = editor.renderScene.getTransformTo(null);
    final totalTransform = globalToScene;
    if (transform != null) totalTransform.multiply(transform.asVM());
    return cursor.resolveRaw(totalTransform, side: side, corner: corner);
  }

  @override
  MouseCursor get cursor {
    if (session.isEmpty) return Cursors.toolCursorForbidden;
    return resolveCursor();
  }
}
