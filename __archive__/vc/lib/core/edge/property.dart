part of '../core.dart';

mixin EdgeProperty<T> {
  (T, T) split(double t);
  List<T> splitMultiple(List<double> ts);
}
