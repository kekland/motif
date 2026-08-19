part of 'prop.dart';

final class PositionProp extends ObjectProp<Vec2Partial> {
  PositionProp(this.session, Vec2Partial Function(Scene) getter) : super(getter, (txn, value) {});

  final TransformSession Function(SceneTransaction) session;

  @override
  void set(SceneTransaction txn, Vec2Partial value) {
    final current = this.value(txn.scene).unwrap.unwrap;
    session(txn).setTranslation(value.apply(current));
  }

  @override
  PropType<Vec2Partial> get type => .position;
}

final class RotationProp extends ObjectProp<double> {
  RotationProp(this.session, double Function(Scene) getter) : super(getter, (txn, value) {});

  final TransformSession Function(SceneTransaction) session;

  @override
  void set(SceneTransaction txn, double value) {
    session(txn).setRotation(value);
  }

  @override
  PropType<double> get type => .rotation;
}

final class TransformProp extends ObjectProp<Mat4> with TransformPropBase {
  TransformProp(this.session, Mat4 Function(Scene) getter) : super(getter, (txn, value) {});

  final TransformSession Function(SceneTransaction) session;

  @override
  void set(SceneTransaction txn, Mat4 value) {
    final s = session(txn);
    s.setTranslation(value.translation2);
    s.setRotation(value.rotationZ);
  }

  @override
  PropType<Mat4> get type => .transform;

  @override
  late final position = PositionProp(
    session,
    (scene) => .from(value(scene).unwrap.translation2),
  );

  @override
  late final rotation = RotationProp(
    session,
    (scene) => value(scene).unwrap.rotationZ,
  );
}

final class LayoutSizeProp extends ObjectProp<LayoutSizePartial> with LayoutSizePropBase {
  LayoutSizeProp(this.id, super.getter, super.setter);

  final StatementId id;

  @override
  Size2? resolvedSize(Scene scene) {
    final layout = scene.layout.of(id);
    return layout?.size;
  }

  @override
  PropType<LayoutSizePartial> get type => .layoutSize;
}

final class ChildLayoutProp extends ObjectProp<ChildLayout> {
  ChildLayoutProp(super.getter, super.setter);

  @override
  PropType<ChildLayout> get type => .childLayout;
}

final class EdgeStyleProp extends ObjectProp<EdgeStylePartial> {
  EdgeStyleProp(super.getter, super.setter);

  @override
  PropType<EdgeStylePartial> get type => .edgeStyle;
}

final class FaceStyleProp extends ObjectProp<FaceStylePartial> {
  FaceStyleProp(super.getter, super.setter);

  @override
  PropType<FaceStylePartial> get type => .faceStyle;
}

final class CutTProp extends ObjectProp<double> {
  CutTProp(super.getter, super.setter);

  @override
  PropType<double> get type => .cutT;
}
