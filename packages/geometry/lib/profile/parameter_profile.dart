part of 'profile.dart';

abstract class ParameterProfile<P extends ParameterProfile<P>> extends ValueProfile<P> {
  ParameterProfile() : super(1.0);
  ParameterProfile.from(List<RawProfileSample> samples) : super.from(samples, 1.0);

  @override
  P copy() => create(_samples.toList());
  P create(List<RawProfileSample> samples);

  @override
  (P, P) split(double x) {
    late final List<RawProfileSample> leftSamples;
    late final List<RawProfileSample> rightSamples;

    final (rawLeft, rawRight) = _split(x);

    if (x <= 0.0 || x >= 1.0) {
      leftSamples = rawLeft;
      rightSamples = rawRight;
    } else {
      final remainingX = 1.0 - x;
      leftSamples = rawLeft.map((e) => (x: e.x / x, v: e.v)).toList();
      rightSamples = rawRight.map((e) => (x: e.x / remainingX, v: e.v)).toList();
    }

    return (create(leftSamples), create(rightSamples));
  }

  @override
  List<P> splitMultiple(List<double> splits) {
    if (splits.isEmpty) return [copy()];
    final sorted = _sortAndValidateSplitsList(splits, 0.0, 1.0, 1e-9);

    final results = <P>[];
    var current = this as P;
    var offset = 0.0;

    for (final t in sorted) {
      final remaining = 1.0 - offset;
      final localT = remaining > 1e-7 ? (t - offset) / remaining : 0.0;
      final (left, right) = current.split(localT);
      results.add(left);
      current = right;
      offset = t;
    }

    results.add(current);
    return results;
  }

  List<P> splitIntoSegments(int n) {
    if (n <= 0) throw ArgumentError.value(n, 'n', 'must be more than 0');
    if (n == 1) return [copy()];

    final ts = List.generate(n - 1, (i) => (i + 1) / n);
    return splitMultiple(ts);
  }

  List<RawProfileSample> getArcLengthProfileSamples(double Function(double) tToDist) {
    final samples = _samples.map((s) => (x: tToDist(s.x), v: s.v)).toList();
    samples.sort((a, b) => a.x.compareTo(b.x));
    return samples;
  }
}
