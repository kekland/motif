import 'package:flutter/widgets.dart';
import 'package:stack/stack.dart';

const kDebugTreeLogEnabled = false;

abstract interface class Node {
  Node? get parent;
  List<Node> get children;
  int get depth;
  bool get isLeaf;

  Iterable<Node> get ancestors;

  bool isAncestorOf(Node node);
  bool isDescendantOf(Node node);
}

mixin NodeImplementations<T extends Node> on Node {
  @override
  bool isAncestorOf(Node node) {
    Node? current = node;

    while (current != null) {
      if (current == this) return true;
      current = current.parent;
    }

    return false;
  }

  @override
  bool isDescendantOf(Node node) => node.isAncestorOf(this);

  @override
  Iterable<T> get ancestors sync* {
    T? current = parent as T?;
    while (current != null) {
      yield current;
      current = current.parent as T?;
    }
  }
}

/// An immutable node in a tree structure.
abstract class ImmutableNodeBase<T extends ImmutableNodeBase<T, TM>, TM extends MutableNodeBase<TM, T>>
    implements Node {
  ImmutableNodeBase({List<T> children = const [], this.parent}) {
    this.children = List.unmodifiable(children.map((c) => c.copyWith(parent: this as T)));
  }

  @override
  late final List<T> children;

  @override
  final T? parent;

  TM copyAsMutable();

  T copyWith({T? parent, List<T>? children});

  @override
  int get depth => (parent?.depth ?? -1) + 1;
}

/// A mutable node in a tree structure.
///
/// Mutable nodes are [ChangeNotifier]s and [Disposable]s.
abstract class MutableNodeBase<T extends MutableNodeBase<T, TI>, TI extends ImmutableNodeBase<TI, T>>
    with ChangeNotifier, ChangeNotifierDisposable
    implements Node {
  MutableNodeBase({List<T>? children}) {
    _children = $listSignal(children ?? []);
    notifyListenersOn([_children]);

    // Setup parent-child relationships.
    for (final child in _children) child._parent = this as T;
  }

  late final ListSignal<T> _children;

  @override
  List<T> get children => _children.value;

  T? _parent;

  @override
  T? get parent => _parent;
  set parent(T? parent) {
    if (_parent == parent) return;
    _parent?.removeChild(this as T);
    parent?.addChild(this as T);

    _parent = parent;
  }

  @override
  int get depth => (parent?.depth ?? -1) + 1;

  void addChild(T child) {
    insertChild(_children.length, child);
  }

  void insertChild(int index, T child) {
    if (_children.contains(child)) throw ArgumentError('Child is already added to this node');
    _children.insert(index, child);
    child._parent = this as T;
    notifyListeners();
  }

  T removeChild(T child) {
    if (!_children.contains(child)) throw ArgumentError('Child is not a child of this node');
    _children.remove(child);
    child._parent = null;
    notifyListeners();

    return child;
  }

  T detach() {
    if (parent == null) throw StateError('Node is already detached');
    parent!.removeChild(this as T);
    notifyListeners();
    return this as T;
  }

  TI copyAsImmutable();

  @override
  void dispose() {
    for (final child in children) child.dispose();
    super.dispose();
  }
}
