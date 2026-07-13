part of '../controller.dart';

class SelectionController with ChangeNotifier, ChangeNotifierDisposable {
  late final _selectedObjects = $setSignal<Selectable>({});
  Set<Selectable> get selected => _selectedObjects.value;
  bool isSelected(Selectable object) => _selectedObjects.contains(object);

  void setSelection(Set<Selectable> objects) {
    _selectedObjects.clear();
    _selectedObjects.addAll(objects);
    notifyListeners();
  }

  void select(Selectable object) {
    _selectedObjects.clear();
    _selectedObjects.add(object);
    notifyListeners();
  }

  void add(Selectable object) {
    _selectedObjects.add(object);
    notifyListeners();
  }

  void deselect(Selectable object) {
    _selectedObjects.remove(object);
    notifyListeners();
  }

  void clear() {
    _selectedObjects.clear();
    notifyListeners();
  }
}
