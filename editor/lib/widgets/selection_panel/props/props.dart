part of 'prop.dart';

final class CoordinateProp(super.sources) extends Prop<Coordinate, CoordinatePartial> {
  @override
  PropType get type => .coordinate;
}

final class PositionProp(super.sources) extends Prop<Position, PositionPartial> {
  @override
  PropType get type => .position;

  late final CoordinateProp x = .new(sources.remap(.coordinate, (v) => v.x, (v) => .new(x: v.value)));
  late final CoordinateProp y = .new(sources.remap(.coordinate, (v) => v.y, (v) => .new(y: v.value)));
}

final class RotationProp(super.sources) extends Prop<double, double> {
  @override
  PropType get type => .rotation;
}

final class TransformProp(super.sources) extends Prop<TransformData, TransformDataPartial> {
  @override
  PropType get type => .transform;

  late final PositionProp translation = .new(
    sources.remap(
      .position,
      (v) => v.translation,
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

final class LayoutDimensionProp(super.sources) extends Prop<ResolvedLayoutDimension, LayoutDimension> {
  @override
  PropType get type => .layoutDimension;
}

final class LayoutSizeProp(super.sources) extends Prop<ResolvedLayoutSize, ResolvedLayoutSizePartial> {
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
