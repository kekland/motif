import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

final class BendEdgeActivity extends DragActivity {
  new(
    this.editor,
    this.edge, {
    super.onStart,
    super.onUpdate,
    super.onEnd,
  });

  final Editor editor;
  final EdgeRef edge;

  static const _grabRange = (0.05, 0.95);
  final mergeKey = Object();
  SceneTransaction? _transaction;

  EdgeStatement? _statement;
  late Cubic2 _initial;
  late double _t;
  late Vec2 _grabPosition;
  late Mat4 _worldToStart, _worldToEnd;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    final scene = editor.scene;
    final bundle = scene.bundle;

    final root = scene.evaluation.rootOf(edge.statementId);
    final statement = editor.statement(root);
    final handle = bundle.edge(edge);
    if (statement is! EdgeStatement || handle == null) {
      return;
    }

    _statement = statement;
    _initial = bundle.edgeCubic(handle, space: .root).copy();
    _worldToStart = bundle.transformBetween(bundle.root, bundle.edgeStart(handle));
    _worldToEnd = bundle.transformBetween(bundle.root, bundle.edgeEnd(handle));

    final grabPosition = editor.globalToScene(details.globalPosition);
    _t = _initial.closestPoint(grabPosition).t.clamp(_grabRange.$1, _grabRange.$2);
    _grabPosition = _initial.point(_t);

    _transaction = scene.beginTransaction();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final statement = _statement;
    if (statement != null) {
      final delta = editor.globalToScene(details.globalPosition) - editor.globalToScene(startDetails.globalPosition);
      final bent = _initial.bend(_t, _grabPosition + delta);

      _transaction!.update<EdgeStatement>(
        _statement!.id,
        (e) => e.copyWith(
          startTangent: _worldToStart.transformDelta2(bent.p1 - bent.p0),
          endTangent: _worldToEnd.transformDelta2(bent.p2 - bent.p3),
        ),
      );

      _transaction!.flush();
    }

    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails details) {
    _transaction?.commit(mergeKey: mergeKey);
    super.onEnd(details);
  }

  @override
  void onCancel() {
    _transaction?.cancel();
    super.onCancel();
  }
}
