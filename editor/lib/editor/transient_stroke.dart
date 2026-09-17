part of '../editor.dart';

final class TransientStrokes with ChangeNotifier, ChangeNotifierDisposable {
  TransientStrokes(this.editor);
  final Editor editor;

  final _instances = <TransientStroke>[];
  Iterable<TransientStroke> get instances => _instances;

  TransientStroke create({EdgeStyle style = .default_}) {
    final stroke = TransientStroke(style: style);
    _instances.add(stroke);
    notifyListeners();
    return stroke;
  }

  void remove(TransientStroke stroke) {
    _instances.remove(stroke);
    notifyListeners();
  }
}

final class TransientStroke extends ChangeNotifier {
  TransientStroke({
    this.style = .default_,
  }) : data = .new(),
       predictions = .new();

  final EdgeStyle style;
  final StrokeData data;
  final StrokeData predictions;

  void onChanged() => notifyListeners();
}
