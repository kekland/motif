part of '../editor.dart';

class SelectionController with ChangeNotifier, ChangeNotifierDisposable {
  SelectionController();

  late final _selectedNodes = $setSignal<SceneNode>({});
  Set<SceneNode> get nodes => _selectedNodes.value;
  bool isSelected(SceneNode node) => _selectedNodes.contains(node);

  late final _selectionGroups = $listSignal<Set<SceneNode>>([]);
  List<Set<SceneNode>> get selectionGroups => _selectionGroups.value;

  /// Whether the node is in the selection or is a descendant of a node in the selection.
  ///
  /// If the object is a cell, it will check if the cell is owned by any selected node.
  bool isImplicitlySelected(SceneNode node) {
    return _selectedNodes.any((o) => o == node || o.isVirtualAncestorOf(node));
  }

  void set(SceneNode node) {
    _selectedNodes.clear();
    _add(node);
    _computeSelectionGroups();
    notifyListeners();
  }

  void setMultiple(Iterable<SceneNode> nodes) {
    _selectedNodes.clear();
    for (final o in nodes) _add(o);
    _computeSelectionGroups();
    notifyListeners();
  }

  void add(SceneNode node) {
    _add(node);
    _computeSelectionGroups();
    notifyListeners();
  }

  void _add(SceneNode node) {
    if (node is RootObject) return;
    if (node is Cell && node.owner != null) return _add(node.owner!);

    final toRemove = _selectedNodes.where((o) => o.isVirtualDescendantOf(node)).toList();
    _selectedNodes.removeAll(toRemove);
    _selectedNodes.add(node);
  }

  void deselect(SceneNode node) {
    _selectedNodes.remove(node);
    _computeSelectionGroups();
    notifyListeners();
  }

  void clear() {
    _selectedNodes.clear();
    _computeSelectionGroups();
    notifyListeners();
  }

  void _computeSelectionGroups() {
    final nodesByDepth = <int, Set<SceneNode>>{};
    for (final node in _selectedNodes) {
      final depth = node.depth;
      nodesByDepth.putIfAbsent(depth, () => {}).add(node);
    }

    _selectionGroups.set(nodesByDepth.entries.map((e) => e.value).toList(), force: true);
  }
}
