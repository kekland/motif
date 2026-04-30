part of '../controller.dart';

class SelectionController with ChangeNotifier, ChangeNotifierDisposable {
  late final _selectedCells = $setSignal<Cell>({});
  Set<Cell> get selectedCells => _selectedCells.value;
  bool isCellSelected(Cell cell) => _selectedCells.contains(cell);

  void select(Cell cell) {
    _selectedCells.clear();
    _selectedCells.add(cell);
    notifyListeners();
  }

  void add(Cell cell) {
    _selectedCells.add(cell);
    notifyListeners();
  }

  void deselect(Cell cell) {
    _selectedCells.remove(cell);
    notifyListeners();
  }

  void clear() {
    _selectedCells.clear();
    notifyListeners();
  }
}
