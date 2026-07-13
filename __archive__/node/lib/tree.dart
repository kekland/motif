import 'package:stack/stack.dart';

import 'node.dart' as node;

abstract interface class Node implements node.Node {
  Node? get parent;
  List<Node> get children;
  int get depth;
  bool get isLeaf;

  Iterable<Node> get ancestors;

  bool isAncestorOf(Node node);
  bool isDescendantOf(Node node);
}

abstract class ImmutableNodeBase<TI extends ImmutableNodeBase<TI, TM>, TM extends MutableNodeBase<TI, TM>>
    extends node.ImmutableNodeBase<TI, TM>
    implements Node {
  ImmutableNodeBase({List<TI> children = const [], this.parent}) {
    this.children = List.unmodifiable(children.map((c) => c.copyWith(parent: this as TI)));
  }

  @override
  late final List<TI> children;

  @override
  final TI? parent;

  @override
  TI copyWith({TI? parent, List<TI>? children});

  // dart format off
  @override bool isAncestorOf(Node node) => _isAncestorOf(this, node);
  @override bool isDescendantOf(Node node) => _isDescendantOf(this, node);
  @override Iterable<TI> get ancestors => _ancestors(this);
  @override int get depth => _depth(this);
  // dart format on
}

abstract class MutableNodeBase<TI extends ImmutableNodeBase<TI, TM>, TM extends MutableNodeBase<TI, TM>>
    extends node.MutableNodeBase<TI, TM>
    implements Node {
  MutableNodeBase({List<TM>? children}) {
    _children = $listSignal(children ?? []);
    _parent = $signal<TM?>(null);

    notifyListenersOn([_children, _parent]);
    for (final child in _children) child._parent.value = this as TM;
  }

  late final ListSignal<TM> _children;
  late final Signal<TM?> _parent;

  @override
  List<TM> get children => _children.value;

  @override
  TM? get parent => _parent.value;
  set parent(TM? parent) {
    if (_parent == parent) return;

    // Check for circular dependency.
    assert(() {
      TM? current = parent;
      while (current != null) {
        if (current == this) return false;
        current = current.parent;
      }
      return true;
    }());

    parent?.removeChild(this as TM);
    parent?.addChild(this as TM);

    _parent.value = parent;
  }

  void addChild(TM child) {
    insertChild(_children.length, child);
  }

  void insertChild(int index, TM child) {
    if (_children.contains(child)) throw ArgumentError('Child is already added to this node');

    // Check for circular dependency.
    assert(() {
      TM? current = this as TM?;
      while (current != null) {
        if (current == child) return false;
        current = current.parent;
      }
      return true;
    }());

    _children.insert(index, child);
    child._parent.value = this as TM;
    notifyListeners();
  }

  TM removeChild(TM child) {
    if (!_children.contains(child)) throw ArgumentError('Child is not a child of this node');
    _children.remove(child);
    child._parent.value = null;
    notifyListeners();

    return child;
  }

  TM detach() {
    if (parent == null) throw StateError('Node is already detached');
    parent!.removeChild(this as TM);
    notifyListeners();
    return this as TM;
  }

  @override
  void dispose() {
    for (final child in children) child.dispose();
    super.dispose();
  }

  // dart format off
  @override bool isAncestorOf(Node node) => _isAncestorOf(this, node);
  @override bool isDescendantOf(Node node) => _isDescendantOf(this, node);
  @override Iterable<TM> get ancestors => _ancestors(this);
  @override int get depth => _depth(this);
  // dart format on
}

@pragma('vm:prefer-inline')
bool _isAncestorOf(Node target, Node node) {
  Node? current = node;

  while (current != null) {
    if (current == target) return true;
    current = current.parent;
  }

  return false;
}

@pragma('vm:prefer-inline')
bool _isDescendantOf(Node target, Node node) => _isAncestorOf(node, target);

@pragma('vm:prefer-inline')
Iterable<T> _ancestors<T extends Node>(Node node) sync* {
  T? current = node.parent as T?;
  while (current != null) {
    yield current;
    current = current.parent as T?;
  }
}

@pragma('vm:prefer-inline')
int _depth(Node node) => (node.parent != null ? _depth(node.parent!) : -1) + 1;
