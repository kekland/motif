part of 'core.dart';

final class FieldContext {
  const FieldContext(this.execution, {this.index = 0, this.id, this.element});

  final BlueprintExecution execution;
  final int index;
  final U64? id;
  final Object? element;

  bool get isScalar => element == null;

  FieldContext extend(Node node, int index, [Object? element]) {
    final seed = id ?? .zero;
    final base = Mix64.mix(seed, U64.of(0, node.id.value));
    final key = Mix64.mixWithKey(base, index);
    return .new(execution, index: index, id: key, element: element);
  }
}

typedef FieldEvaluator<T> = T Function(FieldContext context);

abstract class Field<T> {
  Field();

  factory Field.constant(T value) => ConstantField(value);
  factory Field.dynamic(FieldEvaluator<T> evaluator) => DynamicField(evaluator);

  T evaluate(FieldContext context);

  Field<R> map<R>(R Function(T) f) {
    if (this is ConstantField<T>) {
      return Field.constant(f((this as ConstantField<T>).value));
    }

    return Field.dynamic((context) => f(evaluate(context)));
  }

  static Field<R> zip<R>(
    FieldContext scalar,
    List<Field?> inputs,
    R Function(FieldContext context, List<dynamic> values) combine,
  ) {
    if (inputs.every((f) => f is ConstantField)) {
      final value = combine(scalar, [for (final f in inputs) (f as ConstantField).value]);
      return Field.constant(value);
    }

    return Field.dynamic((context) => combine(context, [for (final f in inputs) f?.evaluate(context)]));
  }

  static Field<R> zip1<R, T1>(
    FieldContext scalar,
    Field<T1> f1,
    R Function(FieldContext context, T1) combine,
  ) {
    return Field.zip(scalar, [f1], (context, values) => combine(context, values[0] as T1));
  }

  static Field<R> zip2<R, T1, T2>(
    FieldContext scalar,
    Field<T1> f1,
    Field<T2> f2,
    R Function(FieldContext context, T1, T2) combine,
  ) {
    return Field.zip(scalar, [f1, f2], (context, values) => combine(context, values[0] as T1, values[1] as T2));
  }

  static Field<R> zip3<R, T1, T2, T3>(
    FieldContext scalar,
    Field<T1> f1,
    Field<T2> f2,
    Field<T3> f3,
    R Function(FieldContext context, T1, T2, T3) combine,
  ) {
    return Field.zip(
      scalar,
      [f1, f2, f3],
      (context, values) => combine(
        context,
        values[0] as T1,
        values[1] as T2,
        values[2] as T3,
      ),
    );
  }
}

class ConstantField<T> extends Field<T> {
  ConstantField(this.value);
  final T value;

  @override
  T evaluate([FieldContext? context]) => value;
}

class DynamicField<T> extends Field<T> {
  DynamicField(this.evaluator);
  final FieldEvaluator<T> evaluator;

  @override
  T evaluate(FieldContext context) => evaluator(context);
}
