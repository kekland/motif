part of '../blueprint.dart';

class GeometryOutputNode extends GeometryOutputNodeBase {
  @override
  PrimitiveBundle execute() {
    final geometryInput = i.geometry.resolve();
    final bundle = geometryInput.value;
    return bundle;
  }
}
