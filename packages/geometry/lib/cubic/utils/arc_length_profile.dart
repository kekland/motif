part of '../cubic.dart';

class ArcLengthSample<T> extends _ProfileSample<T> {
  const ArcLengthSample(super.dist, super.value);
  ArcLengthSample._tuple((double, T) t) : super(t.$1, t.$2);

  double get dist => _s;
}

abstract class ArcLengthProfile<T, P extends ArcLengthProfile<T, P>> extends _CubicProfile<T, ArcLengthSample<T>, P> {
  ArcLengthProfile(super._samples, this._length);

  @override
  P copy() => create(_samples.toList(), _length);
  P create(List<ArcLengthSample<T>> samples, double totalLength);

  @override
  double get _totalLength => _length;
  final double _length;

  @override
  List<double> _sortAndValidateSplits(List<double> splits) {
    return _sortAndValidateSplitsList(splits, 0.0, _length, 1e-5);
  }

  @override
  (P, P) split(double dist) {
    final (rawLeft, rawRight) = _splitRaw(dist);

    return (
      create(rawLeft.map(ArcLengthSample._tuple).toList(), dist),
      create(rawRight.map(ArcLengthSample._tuple).toList(), _length - dist),
    );
  }

  @override
  List<P> splitMultiple(List<double> dists) {
    final raw = _splitMultipleRaw(dists);
    final results = <P>[];

    var prevDist = 0.0;
    for (var i = 0; i < raw.length; i++) {
      final samples = raw[i];
      final length = (i == raw.length - 1) ? _length - prevDist : dists[i] - prevDist;
      results.add(create(samples, length));
      prevDist += length;
    }

    return results;
  }
}
