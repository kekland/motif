part of 'prop.dart';

final class Position(final Vec2 value, {final Vec2? overridden}) with Equatable {
  Vec2 get resolved => overridden ?? value;

  Coordinate get x => .new(value.x, overridden: overridden?.x);
  Coordinate get y => .new(value.y, overridden: overridden?.y);

  @override
  List<Object?> get props => [value, overridden];
}

final class PositionPartial({final double? x, final double? y}) extends Partial<Position> with Equatable {
  PositionPartial.from(Vec2 value) : this(x: value.x, y: value.y);

  @override
  Position apply(Position value) => Position(
    Vec2(x ?? value.value.x, y ?? value.value.y),
    overridden: value.overridden,
  );

  @override
  List<Object?> get props => [x, y];
}

final class Coordinate(final double value, {final double? overridden}) with Equatable {
  double get resolved => overridden ?? value;

  @override
  List<Object?> get props => [value, overridden];
}

final class CoordinatePartial(final double value) extends Partial<Coordinate> with Equatable {
  @override
  Coordinate apply(Coordinate value) => Coordinate(this.value, overridden: value.overridden);

  @override
  List<Object?> get props => [value];
}

final class const TransformData(final Position translation, final double rotation) with Equatable {
  TransformData.from(Mat4 mat, {Vec2? translationOverride})
    : this(
        .new(mat.translation2, overridden: translationOverride),
        mat.rotationZ,
      );

  @override
  List<Object?> get props => [translation, rotation];
}

final class const TransformDataPartial({final PositionPartial? translation, final double? rotation})
    extends Partial<TransformData>
    with Equatable {
  @override
  TransformData apply(TransformData current) {
    return .new(
      translation?.apply(current.translation) ?? current.translation,
      rotation ?? current.rotation,
    );
  }

  void execute(TransformSession session, TransformData current) {
    if (translation != null) session.setTranslation(translation!.apply(current.translation).resolved);
    if (rotation != null) session.setRotation(rotation!);
  }

  @override
  List<Object?> get props => [translation, rotation];
}

final class ResolvedLayoutDimension(final LayoutDimension dimension, {final double? overridden}) with Equatable {
  @override
  List<Object?> get props => [dimension, overridden];
}

final class ResolvedLayoutSize(final LayoutSize size, {final Size2? overridden}) with Equatable {
  ResolvedLayoutDimension get width => .new(size.width, overridden: overridden?.width);
  ResolvedLayoutDimension get height => .new(size.height, overridden: overridden?.height);

  @override
  List<Object?> get props => [size, overridden];
}

final class ResolvedLayoutSizePartial({final LayoutDimension? width, final LayoutDimension? height})
    extends Partial<ResolvedLayoutSize>
    with Equatable {
  ResolvedLayoutSizePartial.from(LayoutSize value) : this(width: value.width, height: value.height);

  @override
  ResolvedLayoutSize apply(ResolvedLayoutSize value) => .new(
    LayoutSize(width ?? value.width.dimension, height ?? value.height.dimension),
    overridden: value.overridden,
  );

  @override
  List<Object?> get props => [width, height];
}
