part of 'core.dart';

typedef FieldEvaluator<T> = T Function(BlueprintExecution context);

abstract class Field<T> {
  Field();

  factory Field.constant(T value) => ConstantField(value);
  factory Field.dynamic(FieldEvaluator<T> evaluator) => DynamicField(evaluator);

  T evaluate(BlueprintExecution context);
  T call(BlueprintExecution context) => evaluate(context);
}

class ConstantField<T> extends Field<T> {
  ConstantField(this.value);
  final T value;

  @override
  T evaluate([BlueprintExecution? context]) => value;

  @override
  T call([BlueprintExecution? context]) => value;
}

class DynamicField<T> extends Field<T> {
  DynamicField(this.evaluator);
  final FieldEvaluator<T> evaluator;

  @override
  T evaluate(BlueprintExecution context) => evaluator(context);
}
