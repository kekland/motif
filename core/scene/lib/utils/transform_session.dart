part of '../scene.dart';

final class TransformSession {
  TransformSession._(
    this.scene,
    this.transaction,
    this.router,
    this.refs,
    this.spaceToWorld,
    this.initialHull,
  ) : worldToSpace = .inverse(spaceToWorld);

  final Scene scene;
  final SceneTransaction? transaction;
  final TransformRouter router;

  final List<Ref> refs;

  final Mat4 spaceToWorld;
  final Mat4 worldToSpace;
  final Aabb2 initialHull;

  final mergeKey = Object();

  factory TransformSession.statement(Scene scene, StatementId id, {SceneTransaction? transaction}) {
    final first = scene.productsOf(id).first;
    return .of(scene, [first], transaction: transaction);
  }

  factory TransformSession.of(Scene scene, Iterable<Ref> refs, {SceneTransaction? transaction}) {
    final bundle = scene.bundle;
    final router = scene.evaluation.routeTransform(refs);

    final absorbers = router.absorbers.keys;

    final Mat4 spaceToWorld;
    final Aabb2 initialHull;

    final worldHull = bundle.query.hull(refs, space: .root);

    if (absorbers.length == 1) {
      final absorber = router.absorbers.values.single;
      spaceToWorld = absorber.spaceToWorld;
      initialHull = absorber.hull;
    } else {
      spaceToWorld = Mat4.identity();
      initialHull = worldHull;
    }

    return ._(scene, transaction, router, refs.toList(), spaceToWorld, initialHull);
  }

  Vec2 get worldPivot => spaceToWorld.transform2(initialHull.center);
  Iterable<StatementId> get absorbers => router.absorbers.keys;
  Set<Ref> get refused => router.refused;
  bool get isEmpty => router.isEmpty;

  void _apply(SceneTransaction txn, Mat4 transform) {
    final result = router.apply(transform);
    for (final entry in result.entries) txn.replace(entry.key, [entry.value]);
  }

  void apply(Mat4 transform) {
    if (transaction != null) {
      _apply(transaction!, transform);
      transaction!.flush();
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

  LayoutBox? get _single {
    assert(absorbers.length == 1, 'field edits must have only a single absorber');
    return scene.program.statement(absorbers.single) as LayoutBox?;
  }

  Vec2 get fieldPivot => initialHull.center;

  void setTranslation(Vec2 translation) {
    final box = _single;
    if (box == null) return;

    final transform = box.transform;
    final current = transform.translation2;
    translateBy(translation - current);
  }

  void setRotation(double rotationRad, {Vec2? pivot}) {
    final box = _single;
    if (box == null) return;

    final transform = box.transform;
    final current = transform.rotationZ;
    rotateBy(rotationRad - current, pivot: pivot);
  }
}
