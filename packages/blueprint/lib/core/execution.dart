part of 'core.dart';

final class BlueprintExecution {
  BlueprintExecution({required this.blueprint, required this._environment});

  final Blueprint blueprint;
  final Map<Type, Object> _environment;
  final _values = <SocketRef, Field>{};

  T environment<T extends Object>() => _environment[T]! as T;

  Field<T> resolve<T>(InputSocket<T> input) {
    final incoming = blueprint.incoming(input);
    if (incoming.isEmpty) return .constant(input.inlineValue);

    if (input is ListInputSocket) {
      final results = [for (final o in incoming) _valueOf(o)];
      if (results.every((f) => f is ConstantField)) {
        return .constant(results.map((f) => (f as ConstantField).value).toList() as T);
      }

      if (input.isConstant) throw StateError('dynamic field passed to a constant input socket');
      return .dynamic((c) => results.map((f) => f.evaluate(c)).toList() as T);
    }

    final result = _valueOf(incoming.single);
    if (input.isConstant && result is! ConstantField) {
      throw StateError('dynamic field passed to a constant input socket');
    }
    return result as Field<T>;
  }

  void set<T>(OutputSocket<T> socket, Field<T> value) {
    if (socket.isConstant && value is! ConstantField) {
      throw StateError('dynamic field passed to a constant output socket');
    }

    _values[socket.ref] = value;
  }

  Field _valueOf(OutputSocket output) {
    final cached = _values[output.ref];
    if (cached != null) return cached;
    output.node.execute(this);
    return _values[output.ref]!;
  }
}
