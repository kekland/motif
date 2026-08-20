part of 'prop.dart';

final class const PropType<G, S>(
  final String key,
  final Prop<G, S> Function(List<PropSource<G, S>>) factory,
) {
  static const coordinate = PropType('coordinate', CoordinateProp.new);
  static const position = PropType('position', PositionProp.new);
  static const rotation = PropType('rotation', RotationProp.new);
  static const transform = PropType('transform', TransformProp.new);
  static const layoutDimension = PropType('layoutDimension', LayoutDimensionProp.new);
  static const layoutSize = PropType('layoutSize', LayoutSizeProp.new);
  static const childLayout = PropType('childLayout', ChildLayoutProp.new);
  static const edgeStyle = PropType('edgeStyle', EdgeStyleProp.new);
  static const faceStyle = PropType('faceStyle', FaceStyleProp.new);
  static const cutT = PropType('cutT', CutTProp.new);
  static const strokeWidth = PropType('strokeWidth', StrokeWidthProp.new);
  static const strokeColor = PropType('strokeColor', StrokeColorProp.new);
  static const fillColor = PropType('fillColor', FillColorProp.new);

  Prop<G, S> compose(Iterable<PropSource> props) {
    return factory(props.cast<PropSource<G, S>>().toList());
  }
}

extension PartialStatementFieldProp<G, S extends Partial<G>> on PropType<G, S> {
  PropSource<G, S> of<T extends Statement>(
    StatementId id, {
    required G Function(Scene, T) get,
    required T Function(Scene, T, G) set,
  }) {
    return .delegating(
      this,
      (scene) => get(scene, scene.statement<T>(id)),
      (txn, value) => txn.update<T>(id, (s) => set(txn.scene, s, value.apply(get(txn.scene, s)))),
    );
  }

  PropSource<G, S> transformingOf<T extends Statement>(
    StatementId id, {
    required G Function(Scene, T) get,
    required void Function(TransformSession, G) execute,
  }) {
    return .transforming(
      this,
      (txn) => .statement(txn.scene, id, transaction: txn),
      (scene) => get(scene, scene.statement<T>(id)),
      (session, current, value) => execute(session, value.apply(current)),
    );
  }
}

extension TotalStatementFieldProp<V> on PropType<V, V> {
  PropSource<V, V> of<T extends Statement>(
    StatementId id, {
    required V Function(Scene, T) get,
    required T Function(Scene, T, V) set,
  }) {
    return .delegating(
      this,
      (scene) => get(scene, scene.statement<T>(id)),
      (txn, value) => txn.update<T>(id, (s) => set(txn.scene, s, value)),
    );
  }
}

// extension CellOf<G, S> on PropType<G, S> {
//   PropSource<G, S> ofCell(Ref ref, {required G Function})
// }

extension PropTypeConstructors<G, S> on PropType<G, S> {
  PropSource<G, S> transforming(
    TransformSession Function(SceneTransaction) session,
    G Function(Scene scene) getter,
    void Function(TransformSession session, G current, S value) setter,
  ) => PropSource<G, S>.transforming(this, session, getter, setter);

  PropSource<G, S> delegating(
    G Function(Scene scene) getter,
    void Function(SceneTransaction txn, S value) setter,
  ) => PropSource<G, S>.delegating(this, getter, setter);
}
