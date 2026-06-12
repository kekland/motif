part of '../controller.dart';

class SelectionController with ChangeNotifier, ChangeNotifierDisposable {
  late final _selectedObjects = $setSignal<Object>({});
  Set<Object> get selectedObjects => _selectedObjects.value;
  bool isObjectSelected(Object object) => _selectedObjects.contains(object);

  void select(Object object) {
    _selectedObjects.clear();
    _selectedObjects.add(object);
    notifyListeners();
  }

  void add(Object object) {
    _selectedObjects.add(object);
    notifyListeners();
  }

  void deselect(Object object) {
    _selectedObjects.remove(object);
    notifyListeners();
  }

  void clear() {
    _selectedObjects.clear();
    notifyListeners();
  }
}
