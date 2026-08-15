import 'package:geometry/geometry.dart';
import 'package:test/expect.dart';

Matcher vec2Equals(Vec2 expected, {double epsilon = 1e-12}) => _Vec2Matcher(expected, epsilon: epsilon);

class _Vec2Matcher extends Matcher {
  _Vec2Matcher(this.expected, {this.epsilon = 1e-12});

  final Vec2 expected;
  final double epsilon;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is! Vec2) return false;
    return item.equals(expected, epsilon);
  }

  @override
  Description describe(Description description) {
    return description.add('Vec2 equal to (${expected.x}, ${expected.y}) within tolerance $epsilon');
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is! Vec2) return mismatchDescription.add('is not a Vec2');
    final d = (item - expected).abs();
    return mismatchDescription.add('is (${item.x}, ${item.y}) with delta (${d.x}, ${d.y})');
  }
}
