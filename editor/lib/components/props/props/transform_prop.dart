import 'package:editor/imports.dart';

final class TransformData({required final Vec2 translation, required final Angle2 rotation}) with Equatable {
  TransformData.from(Mat4 m) : this(translation: m.translation2, rotation: .fromRad(m.rotationZ));

  @override
  List<Object?> get props => [translation.x, translation.y, rotation];
}

final class TransformDataPartial({
  final Vec2Partial? translation,
  final Angle2? rotation,
}) extends Partial<TransformData> with Equatable {
  @override
  TransformData apply(TransformData current) => .new(
    translation: translation?.apply(current.translation) ?? current.translation,
    rotation: rotation ?? current.rotation,
  );

  @override
  List<Object?> get props => [translation?.x, translation?.y, rotation];

  void execute(TransformSession session, TransformData current) {
    if (translation != null) session.setTranslation(translation!.apply(current.translation));
    if (rotation != null) session.setRotation(rotation!);
  }
}

final class TransformProp(
  super.sources, {
  super.kind = .transform,
  super.tooltip = const .new('Controls how the statement is transformed'),
}) extends Prop<TransformData, TransformDataPartial> {
  late final PositionProp translation = remap(
    .position,
    getter: (v) => v.translation,
    setter: (p, v) => .new(translation: v),
    override: (v) => v?.translation,
  );

  late final RotationProp rotation = remap(
    .rotation,
    getter: (v) => v.rotation,
    setter: (p, v) => .new(rotation: v),
    override: (v) => v?.rotation,
  );

  @override
  Iterable<Prop> get children => [translation, rotation];

  @override
  PropWidget? buildWidget(BuildContext context) => TransformPropWidget(prop: this);
}

final class TransformPropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final TransformProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Transform';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: resolvedPadding,
      child: Column(
        spacing: 8.0,
        children: [
          PositionPropWidget(prop: prop.translation, isNested: true),
          RotationPropWidget(prop: prop.rotation, isNested: true),
        ],
      ),
    );
  }
}
