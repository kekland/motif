part of '../scene.dart';

final class TransformSession {
  TransformSession._(
    this.scene,
    this.transaction,
    this.router,
    this.cells,
    this.refs,
    this.spaceToWorld,
    this.worldToSpace,
    this.initialHull,
  );

  final Scene scene;
  final SceneTransaction? transaction;
  final TransformRouter router;

  final List<CellKey> cells;
  final List<Ref> refs;

  final Mat4 spaceToWorld;
  final Mat4 worldToSpace;
  final Aabb2 initialHull;

  final mergeKey = Object();

  factory TransformSession.statement(Scene scene, StatementId id, {SceneTransaction? transaction}) {
    final statement = scene.program.byId(id)!;
    final first = statement.products.first;
    return .of(scene, [first], transaction: transaction);
  }

  factory TransformSession.of(Scene scene, Iterable<Ref> refs, {SceneTransaction? transaction}) {
    final router = scene.resolveTransformRouter(refs);

    final absorbers = router.absorbers.keys;

    late final Mat4 spaceToWorld;
    late final Mat4 worldToSpace;
    late final Aabb2 initialHull;

    if (absorbers.length == 1) {
      final absorber = router.absorbers.values.single;
      final handle = absorber.handle;
      spaceToWorld = absorber.localToWorld;
      worldToSpace = absorber.worldToLocal;
      initialHull = scene.bundle.query.cellBbox(handle);
    } else {
      final hull = Aabb2.invertedInfinity();
      for (final id in absorbers) {
        final absorber = router.absorbers[id]!;
        final handle = absorber.handle;
        final bbox = scene.bundle.query.cellBboxWorld(handle);
        hull.hull(bbox);
      }

      spaceToWorld = Mat4.identity();
      worldToSpace = Mat4.identity();
      initialHull = hull;
    }

    final cells = refs.map((r) => scene.keyOf(r)).whereType<CellKey>().toList();
    return ._(scene, transaction, router, cells, refs.toList(), spaceToWorld, worldToSpace, initialHull);
  }

  Vec2 get worldPivot => spaceToWorld.transform2(initialHull.center);
  Iterable<StatementId> get absorbers => router.absorbers.keys;
  Set<Ref> get locked => router.locked;
  bool get isEmpty => router.isEmpty;

  void _apply(SceneTransaction txn, Mat4 transform) {
    final result = router.transform(transform);
    for (final entry in result.entries) txn.replace(entry.key, [entry.value]);
  }

  void apply(Mat4 transform) {
    if (transaction != null) {
      _apply(transaction!, transform);
      transaction!.preview();
    } else {
      scene.edit((txn) => _apply(txn, transform), mergeKey: mergeKey);
    }
  }

  void translateBy(Vec2 delta) => apply(Mat4.translation2(delta));
  void rotateBy(double deltaRad, {Vec2? pivot}) {
    final anchor = pivot ?? worldPivot;
    final transform = Mat4.identity()
      ..translate2(anchor)
      ..rotateZ(deltaRad)
      ..translate2(-anchor);

    apply(transform);
  }

  TransformAbsorber get _single {
    assert(absorbers.length == 1, 'field edits must have only a single absorber');
    return router.absorbers.values.single;
  }

  Vec2 get fieldPivot {
    final absorber = _single;
    return (absorber.worldToLocal * absorber.spaceToWorld).transform2(initialHull.center);
  }

  void setTranslation(Vec2 translation) {
    assert(absorbers.length == 1, 'translation can only be set when there is a single absorber');
    final statement = scene.program.byId(absorbers.single)!;
    if (statement is! FrameStatement) return;

    final transform = statement.transform;
    final current = transform.translation2;
    translateBy(translation - current);
  }

  void setRotation(double rotationRad, {Vec2? pivot}) {
    assert(absorbers.length == 1, 'rotation can only be set when there is a single absorber');
    final statement = scene.program.byId(absorbers.single)!;
    if (statement is! FrameStatement) return;

    final transform = statement.transform;
    final current = transform.rotationZ;
    rotateBy(rotationRad - current, pivot: pivot);
  }
}
