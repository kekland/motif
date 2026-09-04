part of '../program.dart';

final class const LayoutSize(
  final LayoutDimension width,
  final LayoutDimension height,
) {
  LayoutSize.fixed(double w, double h) : this(.fixed(w), .fixed(h));
  const LayoutSize.contain() : this(const .contain(), const .contain());
  const LayoutSize.expand() : this(const .expand(), const .expand());

  static const zero = LayoutSize(.fixed(0), .fixed(0));

  bool get isFullyFixed => width.isFixed && height.isFixed;

  Size2 fit(Size2 natural, Size2 available) => Size2(
    width.fit(natural.width, available.width),
    height.fit(natural.height, available.height),
  );

  Size2 fixedOrZero() => Size2(
    width.type == .fixed ? width.value! : 0.0,
    height.type == .fixed ? height.value! : 0.0,
  );

  LayoutSize withWidth(LayoutDimension w) => .new(w, height);
  LayoutSize withHeight(LayoutDimension h) => .new(width, h);

  @override
  bool operator ==(Object other) => other is LayoutSize && other.width == width && other.height == height;

  @override
  int get hashCode => Object.hash(width, height);
}

enum LayoutDimensionType { fixed, expand, contain }

final class const LayoutRange._(
  final double min,
  final double max,
) {
  const LayoutRange({double min = 0, double max = .infinity}) : this._(min, max);
  const LayoutRange.atLeast(double min) : this(min: min);
  const LayoutRange.atMost(double max) : this(max: max);
  const LayoutRange.tight(double value) : this(min: value, max: value);

  static const unbounded = LayoutRange(min: 0, max: .infinity);

  bool get isTight => min >= max;
  double clamp(double v) => v.clamp(min, max.isFinite ? max : .maxFinite);

  @override
  bool operator ==(Object other) => other is LayoutRange && other.min == min && other.max == max;

  @override
  int get hashCode => Object.hash(min, max);
}

final class const LayoutDimension(final double? value, final LayoutDimensionType type, final LayoutRange range) {
  const LayoutDimension.fixed(double value, {LayoutRange range = .unbounded}) : this(value, .fixed, range);
  const LayoutDimension.expand({LayoutRange range = .unbounded}) : this(null, .expand, range);
  const LayoutDimension.contain({LayoutRange range = .unbounded}) : this(null, .contain, range);

  bool get isFixed => type == .fixed;
  bool get isExpand => type == .expand;
  bool get isContain => type == .contain;

  double fit(double natural, double available) => clamp(switch (type) {
    .fixed => value!,
    .expand => available,
    .contain => natural,
  });

  double clamp(double v) => range.clamp(v);

  LayoutDimension withFixed(double v) => .new(v, .fixed, range);
  LayoutDimension withType(LayoutDimensionType t) => .new(value, t, range);

  @override
  bool operator ==(Object other) =>
      other is LayoutDimension && other.value == value && other.type == type && other.range == range;

  @override
  int get hashCode => Object.hash(value, type, range);
}

final class LayoutConstraints {
  const LayoutConstraints({
    this.minWidth = 0,
    this.maxWidth = double.infinity,
    this.minHeight = 0,
    this.maxHeight = double.infinity,
  });

  const LayoutConstraints.loose() : this();
  const LayoutConstraints.tight(double w, double h) : this(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h);

  final double minWidth, maxWidth;
  final double minHeight, maxHeight;

  @override
  bool operator ==(Object other) =>
      other is LayoutConstraints &&
      other.minWidth == minWidth &&
      other.maxWidth == maxWidth &&
      other.minHeight == minHeight &&
      other.maxHeight == maxHeight;

  @override
  int get hashCode => Object.hash(minWidth, maxWidth, minHeight, maxHeight);
}
