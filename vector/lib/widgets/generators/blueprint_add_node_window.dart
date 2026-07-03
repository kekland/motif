import 'package:blueprint/blueprint.dart';
import 'package:vector/imports.dart';

class BlueprintAddNodeWindow extends StatelessWidget {
  const BlueprintAddNodeWindow({super.key});

  static WindowEntry<Node> createEntry(BuildContext context) => .withContextAnchor(
    context,
    builder: (_) => BlueprintAddNodeWindow(),
  );

  @override
  Widget build(BuildContext context) {
    return WindowScaffold(
      title: Text('Add node'),
      child: SizedBox(
        width: 200.0,
        height: 240.0,
        child: ListView(
          children: [
            Tile(
              onTap: () => Navigator.of(context).pop(PrimitiveVertexNode()),
              title: Text('Primitive/Vertex'),
            ),
            Tile(
              onTap: () => Navigator.of(context).pop(ShiftVerticesNode()),
              title: Text('Shift Vertices'),
            ),
            Tile(
              onTap: () => Navigator.of(context).pop(ConnectVerticesNode()),
              title: Text('Connect Vertices'),
            ),
            Tile(
              onTap: () => Navigator.of(context).pop(JoinGeometryNode()),
              title: Text('Join Geometry'),
            ),
            Tile(
              onTap: () => Navigator.of(context).pop(RandomVectorNode()),
              title: Text('Random Vector'),
            ),
          ],
        ),
      ),
    );
  }
}
