part of 'profile.dart';

abstract class ArcLengthProfile<P extends ArcLengthProfile<P>> extends ValueProfile<P> {
  ArcLengthProfile(super.totalLength) : super();
  ArcLengthProfile.from(super.samples, super.totalLength) : super.from();

  @override
  P copy() => create(_samples.toList(), totalLength);
  P create(List<RawProfileSample> samples, double totalLength);

  @override
  (P, P) split(double x) {
    final (left, right) = _split(x);
    return (create(left, x), create(right, totalLength - x));
  }

  @override
  List<P> splitMultiple(List<double> splits) {
    if (splits.isEmpty) return [copy()];
    final sorted = _sortAndValidateSplitsList(splits, 0.0, _samples.last.x, 1e-5);

    final results = <P>[];
    var current = this as P;
    var offset = 0.0;

    for (final dist in sorted) {
      final local = dist - offset;
      final (left, right) = current.split(local);
      results.add(left);
      current = right;
      offset = dist;
    }

    results.add(current);
    return results;
  }

  List<RawProfileSample> getParameterProfileSamples(double Function(double) distToT) {
    final samples = _samples.map((s) => (x: distToT(s.x), v: s.v)).toList();
    samples.sort((a, b) => a.x.compareTo(b.x));
    return samples;
  }
}
