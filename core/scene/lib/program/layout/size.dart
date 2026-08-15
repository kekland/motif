part of '../program.dart';

extension type const LayoutSize._((LayoutDimension, LayoutDimension) _) {
  const LayoutSize(LayoutDimension width, LayoutDimension height) : this._((width, height));
  LayoutSize.fixed(double w, double h) : this(.fixed(w), .fixed(h));
  const LayoutSize.contain() : this(const .contain(), const .contain());
  const LayoutSize.expand() : this(const .expand(), const .expand());

  static const zero = LayoutSize(.fixed(0), .fixed(0));

  LayoutDimension get width => _.$1;
  LayoutDimension get height => _.$2;

  bool get isFullyFixed => width.isFixed && height.isFixed;
  Size2 natural(Size2 content) => .new(width.natural(content.width), height.natural(content.height));

  Size2 fixedOrZero() => Size2(
    width.type == .fixed ? width.value! : 0.0,
    height.type == .fixed ? height.value! : 0.0,
  );

  LayoutSize withWidth(LayoutDimension w) => .new(w, height);
  LayoutSize withHeight(LayoutDimension h) => .new(width, h);
}

enum LayoutDimensionType { fixed, expand, contain }

extension type const LayoutRange._((double min, double max) _) {
  const LayoutRange({double min = 0, double max = .infinity}) : this._((min, max));
  const LayoutRange.atLeast(double min) : this(min: min);
  const LayoutRange.atMost(double max) : this(max: max);
  const LayoutRange.tight(double value) : this(min: value, max: value);

  static const unbounded = LayoutRange(min: 0, max: .infinity);

  double get min => _.$1;
  double get max => _.$2;

  bool get isTight => min >= max;
  double clamp(double v) => v.clamp(min, max.isFinite ? max : .maxFinite);
}

extension type const LayoutDimension._((double? value, LayoutDimensionType type, LayoutRange range) _) {
  const LayoutDimension(double? value, LayoutDimensionType type, LayoutRange range) : this._((value, type, range));

  const LayoutDimension.fixed(double value, {LayoutRange range = .unbounded}) : this(value, .fixed, range);
  const LayoutDimension.expand({LayoutRange range = .unbounded}) : this(null, .expand, range);
  const LayoutDimension.contain({LayoutRange range = .unbounded}) : this(null, .contain, range);

  double? get value => _.$1;
  LayoutDimensionType get type => _.$2;
  LayoutRange get range => _.$3;

  bool get isFixed => type == .fixed;
  bool get isExpand => type == .expand;
  bool get isContain => type == .contain;

  double natural(double content) => range.clamp(switch (type) {
    .fixed => value!,
    .expand || .contain => content,
  });

  double clamp(double v) => range.clamp(v);

  LayoutDimension withFixed(double v) => .new(v, .fixed, range);
  LayoutDimension withType(LayoutDimensionType t) => .new(value, t, range);
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
}
