part of 'core.dart';

abstract class Node {
  Node({
    required this.id,
    required this.name,
    required this.category,
    required this.inputs,
    required this.outputs,
  }) {
    _sockets = .unmodifiable([...inputs, ...outputs]);
    for (final (i, s) in _sockets.indexed) s._attach(this, i);
  }

  final NodeId id;
  final String name;
  final Symbol category;

  final List<InputSocket> inputs;
  final List<OutputSocket> outputs;
  late final List<Socket> _sockets;
  Iterable<Socket> get sockets => _sockets;

  Node copyWith({NodeId? id});
  Node copyWithInline(int index, Object? value);

  void execute(BlueprintExecution context);
}
