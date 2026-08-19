part of 'prop.dart';

final class ResolvedCoordinate(final double coordinate, final double? overriden) {
  @override
  bool operator ==(Object other) =>
      other is ResolvedCoordinate && other.coordinate == coordinate && other.overriden == overriden;

  @override
  int get hashCode => Object.hash(coordinate, overriden);

  double get value => overriden ?? coordinate;
}

final class CoordinateProp(super.sources) extends Prop<ResolvedCoordinate, double> {
  @override
  PropType get type => .coordinate;
}

final class ResolvedPosition(final Vec2 position, final Vec2? overriden) {
  ResolvedPosition.from(Vec2 position, [Vec2? overriden]) : this(position, overriden);

  @override
  bool operator ==(Object other) =>
      other is ResolvedPosition && other.position == position && other.overriden == overriden;

  @override
  int get hashCode => Object.hash(position, overriden);

  Vec2 get value => overriden ?? position;

  ResolvedCoordinate get x => .new(position.x, overriden?.x);
  ResolvedCoordinate get y => .new(position.y, overriden?.y);
}

final class PositionProp(super.sources) extends Prop<ResolvedPosition, Vec2Partial> {
  @override
  PropType get type => .position;

  late final CoordinateProp x = .new(sources.remap(.coordinate, (v) => v.x, (v) => .new(x: v)));
  late final CoordinateProp y = .new(sources.remap(.coordinate, (v) => v.y, (v) => .new(y: v)));
}

final class RotationProp(super.sources) extends Prop<double, double> {
  @override
  PropType get type => .rotation;
}

final class TransformData {
  const TransformData(this.translation, this.rotation);
  TransformData.from(Mat4 mat) : this(mat.translation2, mat.rotationZ);

  final Vec2 translation;
  final double rotation;
}

final class TransformDataPartial {
  const TransformDataPartial({this.translation, this.rotation});

  final Vec2Partial? translation;
  final double? rotation;

  TransformData apply(TransformData current) {
    return TransformData(
      translation?.apply(current.translation) ?? current.translation,
      rotation ?? current.rotation,
    );
  }

  void execute(TransformSession session, TransformData current) {
    if (translation != null) session.setTranslation(translation!.apply(current.translation));
    if (rotation != null) session.setRotation(rotation!);
  }
}

final class TransformProp(super.sources) extends Prop<TransformData, TransformDataPartial> {
  @override
  PropType get type => .transform;

  late final PositionProp translation = .new(
    sources.remap(
      .position,
      (v) => .from(v.translation),
      (v) => .new(translation: v),
    ),
  );

  late final RotationProp rotation = .new(
    sources.remap(
      .rotation,
      (v) => v.rotation,
      (v) => .new(rotation: v),
    ),
  );
}

final class ResolvedLayoutDimension(final LayoutDimension dimension, final double? overriden) {
  @override
  bool operator ==(Object other) =>
      other is ResolvedLayoutDimension && other.dimension == dimension && other.overriden == overriden;

  @override
  int get hashCode => Object.hash(dimension, overriden);
}

final class LayoutDimensionProp(super.sources) extends Prop<ResolvedLayoutDimension, LayoutDimension> {
  @override
  PropType get type => .layoutDimension;

  // @override
  // bool compare(ResolvedLayoutDimension a, ResolvedLayoutDimension b) {
  //   return super.compare(a, b);
  // }
}

final class ResolvedLayoutSize(final LayoutSize size, final Size2? overriden) {
  @override
  bool operator ==(Object other) => other is ResolvedLayoutSize && other.size == size && other.overriden == overriden;

  @override
  int get hashCode => Object.hash(size, overriden);

  ResolvedLayoutDimension get width => .new(size.width, overriden?.width);
  ResolvedLayoutDimension get height => .new(size.height, overriden?.height);
}

final class LayoutSizeProp(super.sources) extends Prop<ResolvedLayoutSize, LayoutSizePartial> {
  @override
  PropType get type => .layoutSize;

  late final LayoutDimensionProp width = .new(
    sources.remap(
      .layoutDimension,
      (v) => v.width,
      (v) => .new(width: v),
    ),
  );

  late final LayoutDimensionProp height = .new(
    sources.remap(
      .layoutDimension,
      (v) => v.height,
      (v) => .new(height: v),
    ),
  );
}

final class ChildLayoutProp(super.sources) extends Prop<ChildLayout, ChildLayout> {
  @override
  PropType get type => .childLayout;
}

final class StrokeWidthProp(super.sources) extends Prop<double?, double> {
  @override
  PropType get type => .strokeWidth;
}

final class StrokeColorProp(super.sources) extends Prop<ColorData?, ColorData> {
  @override
  PropType get type => .strokeColor;
}

final class EdgeStyleProp(super.sources) extends Prop<EdgeStylePartial, EdgeStylePartial> {
  @override
  PropType get type => .edgeStyle;

  late final StrokeWidthProp width = .new(
    sources.remap(.strokeWidth, (v) => v.width, (v) => .new(width: v)),
  );

  late final StrokeColorProp color = .new(
    sources.remap(.strokeColor, (v) => v.color, (v) => .new(color: v)),
  );
}

final class FillColorProp(super.sources) extends Prop<ColorData?, ColorData> {
  @override
  PropType get type => .fillColor;
}

final class FaceStyleProp(super.sources) extends Prop<FaceStylePartial, FaceStylePartial> {
  @override
  PropType get type => .faceStyle;

  late final FillColorProp color = .new(
    sources.remap(.fillColor, (v) => v.color, (v) => .new(color: v)),
  );
}

final class CutTProp(super.sources) extends Prop<double, double> {
  @override
  PropType get type => .cutT;
}
