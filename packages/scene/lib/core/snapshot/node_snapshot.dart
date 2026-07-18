part of '../core.dart';

sealed class NodeSnapshot {
  const NodeSnapshot({
    required this.id,
  });

  final NodeId id;
}

class ObjectSnapshot extends NodeSnapshot {
  const ObjectSnapshot({
    required super.id,
    required this.transform,
    required this.size,
  });

  final ObjectTransform transform;
  final ObjectSize size;
}
