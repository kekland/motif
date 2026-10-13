part of 'core.dart';

final class BlueprintSlice {
  BlueprintSlice({
    this.nodes = const [],
    this.connections = const [],
    this.positions = const {},
  });

  final List<Node> nodes;
  final List<Connection> connections;
  final Map<NodeId, Vec2> positions;

  BlueprintSlice materialize(Vec2 offset) {
    final newNodes = <Node>[];
    final nodeIdMapping = <NodeId, NodeId>{};
    final positions = <NodeId, Vec2>{};
    var bbox = Aabb2.invertedInfinity();

    for (final n in nodes) {
      final newId = NodeId.generate();
      nodeIdMapping[n.id] = newId;
      newNodes.add(n.copyWith(id: newId));

      final position = this.positions[n.id]!;
      positions[newId] = position;
      bbox.hullPoint(position);
    }

    for (final entry in positions.entries) {
      positions[entry.key] = entry.value - bbox.min + offset;
    }

    final newConnections = connections.map((c) {
      final newInput = c.input.copyWith(node: nodeIdMapping[c.input.node]!);
      final newOutput = c.output.copyWith(node: nodeIdMapping[c.output.node]!);
      return c.copyWith(input: newInput, output: newOutput);
    });

    return BlueprintSlice(
      nodes: newNodes,
      connections: newConnections.toList(),
      positions: positions,
    );
  }
}
