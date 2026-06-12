part of '../controller.dart';

class StrokeProperties extends ChangeNotifier with ChangeNotifierDisposable {
  StrokeProperties() {
    notifyListenersOn([_color, _width, _topological]);
  }

  late final _color = $signal(ColorData.white);
  ColorData get color => _color.value;
  set color(ColorData value) => _color.value = value;

  late final _width = $signal(8.0);
  double get width => _width.value;
  set width(double value) => _width.value = value;

  late final _topological = $signal(true);
  bool get topological => _topological.value;
  set topological(bool value) => _topological.value = value;
}
