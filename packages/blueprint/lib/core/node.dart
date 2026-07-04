part of 'core.dart';

abstract class Node {
  Node({required this.name, required this.inputs, required this.outputs}) {
    for (final i in inputs) i._node = this;
    for (final o in outputs) o._node = this;
    _sockets = [...inputs, ...outputs];
  }

  final String name;

  final List<InputSocket> inputs;
  final List<OutputSocket> outputs;
  Iterable<Socket> get sockets => _sockets;
  late final List<Socket> _sockets;

  Blueprint? _blueprint;
  ReadonlySignal<Node> call() => _blueprint!._signalForNode(this);

  Offset get position => _blueprint!.getNodePosition(this);
  set position(Offset value) => _blueprint!.setNodePosition(this, value);

  bool get isStatic => _blueprint!.getNodeStatic(this);
  set isStatic(bool value) => _blueprint!.setNodeStatic(this, value);

  @protected
  void markAsDirty() => _blueprint?._markNodeAsDirty(this);

  Color? resolveColor(BuildContext context) => null;

  T getEnvironment<T extends Object>() => _blueprint!.getEnvironment<T>();

  void execute();
}
