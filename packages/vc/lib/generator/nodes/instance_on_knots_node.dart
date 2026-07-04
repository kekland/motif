part of '../blueprint.dart';

class InstanceOnKnotsNode extends InstanceOnKnotsNodeBase with InstanceOnPointsMixin {
  @override
  void execute() {
    final geometryInput = i.geometry.resolve();
    final instanceInput = i.instance.resolve();

    final geometry = geometryInput.value;
    final instance = instanceInput.value;

    final points = <Vector2>[];
    for (final edge in geometry.edges) {
      for (final knot in edge.path.knots) {
        points.add(knot.p);
      }
    }

    final instanced = performInstancing(instance, points);
    final merged = PrimitiveBundle.merge([geometry, instanced]);
    assert(merged.assertValid());

    o.instances.value = .constant(merged);
  }
}
