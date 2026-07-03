part of '../core.dart';

class EdgeDecorationPrimitive {
  EdgeDecorationPrimitive({required this.color, required this.width});

  final ColorData color;
  final double width;

  EdgeDecorationPrimitive copyWith({ColorData? color, double? width}) => .new(
    color: color ?? this.color,
    width: width ?? this.width,
  );

  EdgeDecoration inflate() => .new(color: color, width: width);
}

class EdgeDecoration with EdgeProperty<EdgeDecoration> {
  EdgeDecoration({this._color = .black, this._width = 1.0});

  Edge? _edge;
  void _markAsDirty() => _edge?._markAsDirty();

  ColorData _color;
  ColorData get color => _color;
  set color(ColorData value) {
    if (_color == value) return;
    _color = value;
    _markAsDirty();
  }

  double _width;
  double get width => _width;
  set width(double value) {
    if (_width == value) return;
    _width = value;
    _markAsDirty();
  }

  EdgeDecoration copyWith({ColorData? color, double? width}) => .new(
    color: color ?? _color,
    width: width ?? _width,
  );

  @override
  (EdgeDecoration, EdgeDecoration) split(double t) => (copyWith(), copyWith());

  @override
  List<EdgeDecoration> splitMultiple(List<double> ts) => List.generate(ts.length + 1, (_) => copyWith());

  EdgeDecorationPrimitive asPrimitive() => .new(color: color, width: width);
}
