import 'package:flutter/widgets.dart';
import 'package:stack/stack.dart';

import '../tree.dart';

class SelectionController<T extends Node> with ChangeNotifier, ChangeNotifierDisposable {
  SelectionController();

  late final _selectedNodes = $setSignal<T>({});
  Set<T> get selectedNodes => _selectedNodes.value;
  bool isNodeSelected(T node) => _selectedNodes.contains(node);

  late final _selectionGroups = $listSignal<Set<T>>([]);
  List<Set<T>> get selectionGroups => _selectionGroups.value;

  /// Whether the node is in the selection or is a descendant of a node in the selection.
  bool isImplicitlySelected(T node) => selectedNodes.any((n) => n == node || n.isAncestorOf(node));

  void set(T node) {
    _selectedNodes.clear();
    _selectedNodes.add(node);
    notifyListeners();
    _computeSelectionGroups();
  }

  void setMultiple(Iterable<T> nodes) {
    _selectedNodes.clear();
    nodes.forEach(add);
    _computeSelectionGroups();
    notifyListeners();
  }

  void add(T node) {
    if (node.parent == null) return;
    if (selectedNodes.any((n) => n.isAncestorOf(node))) return;

    final nodesForRemoval = _selectedNodes.where((n) => n.isDescendantOf(node)).toList();
    _selectedNodes.removeAll(nodesForRemoval);
    _selectedNodes.add(node);
    _computeSelectionGroups();
    notifyListeners();
  }

  void deselectNode(T node) {
    _selectedNodes.remove(node);
    _computeSelectionGroups();
    notifyListeners();
  }

  void clearSelection() {
    _selectedNodes.clear();
    _computeSelectionGroups();
    notifyListeners();
  }

  void _computeSelectionGroups() {
    final nodesByDepth = <int, Set<T>>{};

    // Selections are grouped by depth.
    for (final node in selectedNodes) {
      nodesByDepth[node.depth] ??= {};
      nodesByDepth[node.depth]!.add(node);
    }

    _selectionGroups.set(nodesByDepth.entries.map((e) => e.value).toList(), force: true);
  }
}
