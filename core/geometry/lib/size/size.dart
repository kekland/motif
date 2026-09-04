import 'package:geometry/geometry.dart';

extension type Size2._(Vec2 vec) {
  Size2.from(Vec2 vec) : this._(vec);
  Size2(double width, double height) : this._(Vec2(width, height));
  Size2.zero() : this._(Vec2.zero());

  double get width => vec.x;
  double get height => vec.y;

  Size2 operator +(Size2 other) => ._(vec + other.vec);
  Size2 operator -(Size2 other) => ._(vec - other.vec);
  Size2 operator *(double scalar) => ._(vec * scalar);
  Size2 operator /(double scalar) => ._(vec / scalar);

  Size2 transformed(Mat4 transform) {
    final aabb = toAabb();
    final transformed = aabb.transformed(transform);
    return transformed.size;
  }

  Size2 hull(Size2 other) => .new(
    width > other.width ? width : other.width,
    height > other.height ? height : other.height,
  );

  Size2 inflate(double horizontal, double vertical) => .new(width + horizontal, height + vertical);
  Size2 deflate(double horizontal, double vertical) => .new(width - horizontal, height - vertical);

  Aabb2 toAabb({Vec2? origin}) {
    if (origin == null) return .ltwh(0, 0, width, height);
    return .ltwh(origin.x, origin.y, width, height);
  }

  Size2 withWidth(double newWidth) => .new(newWidth, height);
  Size2 withHeight(double newHeight) => .new(width, newHeight);

  Size2 scale(double sx, double sy) => .new(width * sx, height * sy);

  bool equals(Size2 other, [double epsilon = 1e-12]) => vec.equals(other.vec, epsilon);
  bool exactEquals(Size2 other) => vec.exactEquals(other.vec);
}
