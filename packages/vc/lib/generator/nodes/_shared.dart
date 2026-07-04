part of '../blueprint.dart';

mixin InstanceOnPointsMixin on bp.Node {
  PrimitiveBundle performInstancing(
    PrimitiveBundle instance,
    List<Vector2> points,
  ) {
    final instanced = <PrimitiveBundle>[];
    for (final point in points) {
      final newInstance = instance.transform(.translationValues(point.x, point.y, 0.0)).withNewIds();
      instanced.add(newInstance);
    }

    return .merge(instanced);
  }
}
