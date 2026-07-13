part of '../core.dart';

extension type const ObjectSize._((ObjectLayoutDimension width, ObjectLayoutDimension height) _) {
  const ObjectSize(ObjectLayoutDimension width, ObjectLayoutDimension height) : this._((width, height));
  ObjectSize.fixed(double w, double h) : this(.fixed(w), .fixed(h));
  ObjectSize.expand({double? width, double? height}) : this(.expand(width), .expand(height));
  ObjectSize.contain({double? width, double? height}) : this(.contain(width), .contain(height));

  static const zero = ObjectSize(.zero, .zero);
  static const infinity = ObjectSize(.infinity, .infinity);

  ObjectLayoutDimension get width => _.$1;
  ObjectLayoutDimension get height => _.$2;

  bool get isFixed => width.type == .fixed && height.type == .fixed;

  bool get dependsOnParent => width.type == .expand || height.type == .expand;
  bool get dependsOnChildren => width.type == .contain || height.type == .contain;

  ObjectSize copyWith({
    ObjectLayoutDimension? width,
    ObjectLayoutDimension? height,
  }) => .new(width ?? this.width, height ?? this.height);

  ObjectSize copyWithFixed({
    double? width,
    double? height,
  }) => .new(
    width != null ? .fixed(width) : this.width,
    height != null ? .fixed(height) : this.height,
  );

  Size resolve(BoxConstraints constraints) {
    return .new(width.value!, height.value!);
  }
}

enum ObjectLayoutDimensionType { fixed, expand, contain }

extension type const ObjectLayoutDimension._((double? value, ObjectLayoutDimensionType type) _) {
  const ObjectLayoutDimension(double? value, ObjectLayoutDimensionType type) : this._((value, type));
  const ObjectLayoutDimension.fixed(double value) : this(value, .fixed);
  const ObjectLayoutDimension.expand([double? value]) : this(value, .expand);
  const ObjectLayoutDimension.contain([double? value]) : this(value, .contain);

  static const zero = ObjectLayoutDimension.fixed(0.0);
  static const infinity = ObjectLayoutDimension.fixed(.infinity);

  double? get value => _.$1;
  ObjectLayoutDimensionType get type => _.$2;

  ObjectLayoutDimension copyWith({
    double? value,
    ObjectLayoutDimensionType? type,
  }) => .new(value ?? this.value, type ?? this.type);
}
