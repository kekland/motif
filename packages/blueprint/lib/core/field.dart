part of 'core.dart';

class EvaluationContext {}

typedef FieldEvaluator<T> = T Function(EvaluationContext context);

abstract class Field<T> {
  Field();

  factory Field.constant(T value) => ConstantField(value);
  factory Field.dynamic(FieldEvaluator<T> evaluator) => DynamicField(evaluator);

  T evaluate(covariant EvaluationContext context);
  T call(covariant EvaluationContext context) => evaluate(context);
}

class ConstantField<T> extends Field<T> {
  ConstantField(this.value);
  final T value;

  @override
  T evaluate([covariant EvaluationContext? context]) => value;

  @override
  T call([covariant EvaluationContext? context]) => value;
}

class DynamicField<T> extends Field<T> {
  DynamicField(this.evaluator);
  final FieldEvaluator<T> evaluator;

  @override
  T evaluate(covariant EvaluationContext context) => evaluator(context);
}
