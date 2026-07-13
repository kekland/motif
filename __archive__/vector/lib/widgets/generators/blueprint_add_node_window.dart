import 'package:blueprint/blueprint.dart';
import '../../imports.dart';

class BlueprintAddNodeWindow extends StatelessWidget {
  const BlueprintAddNodeWindow({super.key});

  static WindowEntry<Node> createEntry(BuildContext context) => .withContextAnchor(
    context,
    builder: (_) => BlueprintAddNodeWindow(),
  );

  @override
  Widget build(BuildContext context) {
    final nodes = <String, Node>{
      'Primitive/Vertex': PrimitiveVertexNode(),
      'Shift Geometry': ShiftGeometryNode(),
      'Connect Vertices': ConnectVerticesNode(),
      'Join Geometry': JoinGeometryNode(),
      'Random Vector': RandomVectorNode(),
      'Instance on Vertices': InstanceOnVerticesNode(),
      'Instance on Knots': InstanceOnKnotsNode(),
      'Symbol': SymbolNode(),
    };

    return WindowScaffold(
      title: Text('Add node'),
      child: SizedBox(
        width: 200.0,
        height: 240.0,
        child: ListView(
          children: [
            for (final entry in nodes.entries) ...[
              Tile(
                onTap: () => Navigator.pop(context, entry.value),
                title: Text(entry.key),
              ),
              Divider(),
            ],
          ],
        ),
      ),
    );
  }
}
