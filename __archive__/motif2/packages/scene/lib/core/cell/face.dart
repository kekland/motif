part of '../core.dart';

final class Face extends Cell {
  Face({
    super.id,
    super.topologyId,
    FaceGeometry? geometry,
  }) {
    this.geometry = geometry ?? .new([]);
    this.geometry._setFace(this);
    _constraints = FaceConstraints.none;
  }

  late final FaceGeometry geometry;

  @override
  Aabb2 get bbox => geometry.bbox;

  @override
  void _attachToTopology(Topology topology) {
    super._attachToTopology(topology);
    geometry._attachToTopology(topology);
  }

  @override
  void _detachFromTopology() {
    geometry._detachFromTopology();
    super._detachFromTopology();
  }

  @override
  NodeSnapshot snapshot() => throw UnimplementedError('Face.snapshot is not implemented yet.');

  @override
  void applySnapshot(covariant NodeSnapshot snapshot) {}

  @override
  void applyTransform(Matrix4 transform) {}

  @override
  void setFrom(covariant Cell other) {}

  @override
  NodeType get type => .face;
}
