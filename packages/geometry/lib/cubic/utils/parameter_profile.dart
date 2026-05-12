part of '../cubic.dart';

class ParameterSample<T> extends _ProfileSample<T> {
  const ParameterSample(super.t, super.value);
  ParameterSample._tuple((double, T) t) : super(t.$1, t.$2);

  double get t => _s;
}

abstract class ParameterProfile<T, P extends ParameterProfile<T, P>> extends _CubicProfile<T, ParameterSample<T>, P> {
  ParameterProfile(super._samples);

  @override
  P copy() => create(_samples.toList());
  P create(List<ParameterSample<T>> samples);

  @override
  double get _totalLength => 1.0;

  @override
  List<double> _sortAndValidateSplits(List<double> splits) {
    return _sortAndValidateTsList(splits);
  }

  @override
  (P, P) split(double t) {
    late final List<(double, T)> leftSamples;
    late final List<(double, T)> rightSamples;

    final (rawLeft, rawRight) = _splitRaw(t);
    if (t <= 0.0 || t >= 1.0) {
      leftSamples = rawLeft;
      rightSamples = rawRight;
    } else {
      final remainingT = 1.0 - t;
      leftSamples = rawLeft.map((e) => (e.$1 / t, e.$2)).toList();
      rightSamples = rawRight.map((e) => (e.$1 / remainingT, e.$2)).toList();
    }

    return (
      create(leftSamples.map(ParameterSample._tuple).toList()),
      create(rightSamples.map(ParameterSample._tuple).toList()),
    );
  }

  @override
  List<P> splitMultiple(List<double> dists) {
    final result = _splitMultipleRaw(dists);
    return result.map(create).toList();
  }
}
