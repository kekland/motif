part of 'core.dart';

final class BlueprintExecution {
  BlueprintExecution({required this.blueprint, required this._environment});

  final Blueprint blueprint;
  final Map<Type, Object> _environment;
  final _values = <SocketRef, Field>{};

  FieldContext get scalar => FieldContext(this);

  T environment<T extends Object>() => _environment[T]! as T;

  Field<T> resolve<T>(InputSocket<T> input) {
    final incoming = blueprint.incoming(input);
    if (incoming.isEmpty) return .constant(input.inlineValue);

    if (input is ListInputSocket) {
      final list = input as ListInputSocket;
      final result = Field.zip<T>([for (final o in incoming) _valueOf(o)], (values) => list._castList(values) as T);
      if (input.isConstant && result is! ConstantField) {
        throw StateError('dynamic field passed to a constant input socket');
      }
      return result;
    }

    final result = _valueOf(incoming.single);
    if (input.isConstant && result is! ConstantField) {
      throw StateError('dynamic field passed to a constant input socket');
    }

    if (T == double && result is Field<int>) return result.map((v) => v.toDouble()) as Field<T>;
    return result as Field<T>;
  }

  T evaluateScalar<T>(InputSocket<T> input) {
    return resolve(input).evaluate(scalar);
  }

  void set<T>(OutputSocket<T> socket, Field<T> value) {
    if (socket.isConstant && value is! ConstantField) {
      throw StateError('dynamic field passed to a constant output socket');
    }

    _values[socket.ref] = value;
  }

  void setConstant<T>(OutputSocket<T> socket, T value) {
    _values[socket.ref] = Field<T>.constant(value);
  }

  Field _valueOf(OutputSocket output) {
    final cached = _values[output.ref];
    if (cached != null) return cached;
    return _execute(output);
  }

  Field _execute(OutputSocket output) {
    output.node.execute(this);
    return _values[output.ref] ?? (throw StateError('${output.node.name} did not set ${output.name}'));
  }
}
