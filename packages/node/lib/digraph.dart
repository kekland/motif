import 'package:stack/stack.dart';
import 'node.dart' as node;

abstract interface class Node implements node.Node {
  Iterable<Node> get incoming;
  Iterable<Node> get outgoing;

  int get inDegree;
  int get outDegree;
}

abstract class ImmutableNodeBase<TI extends ImmutableNodeBase<TI, TM>, TM extends MutableNodeBase<TI, TM>>
    extends node.ImmutableNodeBase<TI, TM>
    implements Node {
  ImmutableNodeBase({Set<TI>? incoming, Set<TI>? outgoing}) {
    _incoming = incoming ?? {};
    _outgoing = outgoing ?? {};

    for (final i in this.incoming) i._addOutgoing(this);
    for (final o in this.outgoing) o._addIncoming(this);
  }

  @override
  Iterable<TI> get incoming => _incoming;
  late final Set<TI> _incoming;

  @override
  Iterable<TI> get outgoing => _outgoing;
  late final Set<TI> _outgoing;

  @override
  TI copyWith({List<TI>? incoming, List<TI>? outgoing});

  // dart format off
  void _addIncoming(Node node) => _incoming.add(node as TI);
  void _addOutgoing(Node node) => _outgoing.add(node as TI);
  @override int get inDegree => _inDegree(this);
  @override int get outDegree => _outDegree(this);
  // dart format on
}

abstract class MutableNodeBase<TI extends ImmutableNodeBase<TI, TM>, TM extends MutableNodeBase<TI, TM>>
    extends node.MutableNodeBase<TI, TM>
    implements Node {
  MutableNodeBase({Set<TM>? incoming, Set<TM>? outgoing}) {
    _incoming = $setSignal(incoming ?? {});
    _outgoing = $setSignal(outgoing ?? {});

    notifyListenersOn([_incoming, _outgoing]);

    for (final i in this.incoming) i._addOutgoing(this);
    for (final o in this.outgoing) o._addIncoming(this);
  }

  late final SetSignal<TM> _incoming;
  late final SetSignal<TM> _outgoing;

  @override
  Iterable<TM> get incoming => _incoming.value;

  @override
  Iterable<TM> get outgoing => _outgoing.value;

  void addIncoming(TM node) {
    _incoming.add(node);
    node._addOutgoing(this);
  }

  void removeIncoming(TM node) {
    _incoming.remove(node);
    node._removeOutgoing(this);
  }

  void addOutgoing(TM node) {
    _outgoing.add(node);
    node._addIncoming(this);
  }

  void removeOutgoing(TM node) {
    _outgoing.remove(node);
    node._removeIncoming(this);
  }

  // dart format off
  void _addIncoming(Node node) => _incoming.add(node as TM);
  void _removeIncoming(Node node) => _incoming.remove(node as TM);
  void _addOutgoing(Node node) => _outgoing.add(node as TM);
  void _removeOutgoing(Node node) => _outgoing.remove(node as TM);
  @override int get inDegree => _inDegree(this);
  @override int get outDegree => _outDegree(this);
  // dart format on
}

@pragma('vm:prefer-inline')
int _inDegree(Node node) => node.incoming.length;

@pragma('vm:prefer-inline')
int _outDegree(Node node) => node.outgoing.length;
