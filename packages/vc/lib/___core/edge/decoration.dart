part of '../core.dart';

abstract class EdgeDecoration {
  const EdgeDecoration();
  const factory EdgeDecoration.immutable({ColorData color, double width}) = ImmutableEdgeDecoration;
  factory EdgeDecoration.mutable({ColorData color, double width}) = MutableEdgeDecoration;

  ColorData get color;
  double get width;

  ImmutableEdgeDecoration asImmutable() => .new(color: color);
  MutableEdgeDecoration asMutable() => .new(color: color);
}

class ImmutableEdgeDecoration extends EdgeDecoration {
  const ImmutableEdgeDecoration({this.color = .black, this.width = 1.0});
  static const default_ = ImmutableEdgeDecoration(color: ColorData.black);

  // dart format off
  @override final ColorData color;
  @override final double width;
  // dart format on

  ImmutableEdgeDecoration copyWith({ColorData? color, double? width}) {
    return ImmutableEdgeDecoration(
      color: color ?? this.color,
      width: width ?? this.width,
    );
  }
}

class MutableEdgeDecoration extends EdgeDecoration with ChangeNotifier, ChangeNotifierDisposable {
  MutableEdgeDecoration({ColorData color = .black, double width = 1.0}) {
    _colorSignal = $signal(color);
    _widthSignal = $signal(width);
    notifyListenersOn([_colorSignal, _widthSignal]);
  }

  @override
  ColorData get color => _colorSignal.value;
  late final Signal<ColorData> _colorSignal;
  set color(ColorData value) => _colorSignal.value = value;

  @override
  double get width => _widthSignal.value;
  late final Signal<double> _widthSignal;
  set width(double value) => _widthSignal.value = value;
}
