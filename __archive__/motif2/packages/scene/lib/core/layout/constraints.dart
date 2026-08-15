part of '../core.dart';

sealed class LayoutConstraints {
  const LayoutConstraints();
  static const none = NoConstraints();
}

final class NoConstraints extends LayoutConstraints {
  const NoConstraints();
}

final class ObjectConstraints extends LayoutConstraints {
  const ObjectConstraints({
    this.minWidth = 0.0,
    this.maxWidth = .infinity,
    this.minHeight = 0.0,
    this.maxHeight = .infinity,
  });

  static const none = ObjectConstraints();

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ObjectConstraints &&
            minWidth == other.minWidth &&
            maxWidth == other.maxWidth &&
            minHeight == other.minHeight &&
            maxHeight == other.maxHeight;
  }

  @override
  int get hashCode => Object.hash(minWidth, maxWidth, minHeight, maxHeight);
}

sealed class VertexConstraints extends LayoutConstraints {
  const VertexConstraints();

  const factory VertexConstraints.fixed(double x, double y) = FixedVertexConstraints;

  static const none = NoVertexConstraints();

  Vector2 constrain(Vector2 position);
}

final class NoVertexConstraints extends VertexConstraints {
  const NoVertexConstraints();

  @override
  Vector2 constrain(Vector2 position) => position;
}

final class FixedVertexConstraints extends VertexConstraints {
  const FixedVertexConstraints(this.x, this.y);

  final double x;
  final double y;

  @override
  Vector2 constrain(Vector2 position) => .new(x, y);
}

final class LineSegmentVertexConstraints extends VertexConstraints {
  const LineSegmentVertexConstraints({
    required this.start,
    required this.end,
  });

  final Vector2 start;
  final Vector2 end;

  @override
  Vector2 constrain(Vector2 position) {
    final segment = LineSegment2(start, end);
    return segment.closestTo(position).point;
  }
}

sealed class EdgeConstraints extends LayoutConstraints {
  const EdgeConstraints();

  static const none = NoEdgeConstraints();

  EdgePath constrain(EdgePath path);
}

final class NoEdgeConstraints extends EdgeConstraints {
  const NoEdgeConstraints();

  @override
  EdgePath constrain(EdgePath path) => path;
}

sealed class FaceConstraints extends LayoutConstraints {
  const FaceConstraints();

  static const none = NoFaceConstraints();

  FaceGeometry constrain(FaceGeometry geometry);
}

final class NoFaceConstraints extends FaceConstraints {
  const NoFaceConstraints();

  @override
  FaceGeometry constrain(FaceGeometry geometry) => geometry;
}
