part of '../scene.dart';

final class SceneSelection with ChangeNotifier {
  SceneSelection(this.scene);
  final Scene scene;

  final _selected = <CellKey>{};
  var _stamp = 0;

  Iterable<CellKey> get cells => _selected;
  bool get isEmpty => _selected.isEmpty;

  void set(CellKey key) {
    _selected.clear();
    _selected.add(key);
    notifyListeners();
    _stamp++;
  }

  void setMultiple(Iterable<CellKey> keys) {
    _selected.clear();
    _selected.addAll(keys);
    notifyListeners();
    _stamp++;
  }

  void add(CellKey key) {
    _selected.add(key);
    notifyListeners();
    _stamp++;
  }

  void clear() {
    _selected.clear();
    notifyListeners();
    _stamp++;
  }

  int get stamp => _stamp;
}
