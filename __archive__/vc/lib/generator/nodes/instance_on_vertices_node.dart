part of '../blueprint.dart';

class InstanceOnVerticesNode extends InstanceOnVerticesNodeBase with InstanceOnPointsMixin {
  @override
  void execute() {
    final geometryInput = i.geometry.resolve();
    final instanceInput = i.instance.resolve();

    final geometry = geometryInput.value;
    final instance = instanceInput.value;

    final points = geometry.vertices.map((v) => v.position).toList();
    final instanced = performInstancing(instance, points);
    final merged = PrimitiveBundle.merge([geometry, instanced]);
    assert(merged.assertValid());

    o.instances.value = .constant(merged);
  }
}
