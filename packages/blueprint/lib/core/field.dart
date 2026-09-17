part of 'core.dart';

final class FieldContext {
  const FieldContext(this.execution, {this.index = 0, this.id, this.element});

  final BlueprintExecution execution;
  final int index;
  final U64? id;
  final Object? element;

  bool get isScalar => element == null;
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

  static Field<R> zip<R>(List<Field> inputs, R Function(List<dynamic> values) combine) {
    if (inputs.every((f) => f is ConstantField)) {
      final value = combine([for (final f in inputs) (f as ConstantField).value]);
      return Field.constant(value);
    }

    return Field.dynamic((context) => combine([for (final f in inputs) f.evaluate(context)]));
  }

  static Field<R> zip2<R, T1, T2>(
    Field<T1> f1,
    Field<T2> f2,
    R Function(T1, T2) combine,
  ) {
    return Field.zip([f1, f2], (values) => combine(values[0] as T1, values[1] as T2));
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
