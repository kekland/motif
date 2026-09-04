import 'package:geometry/geometry.dart';
import 'package:scene/scene.dart';
import 'package:kernel/kernel.dart';

extension SceneStatementAtQuery on SceneQuery {
  Ref<CellHandle>? refAt(Vec2 position) {
    {
      final result = scene.bundle.query.nearestVertex(position, 8.0);
      if (result != null) {
        final key = result.vertex.key(scene.bundle);
        final ref = scene.cells.refOf(key);
        if (ref != null) return ref;
      }
    }

    {
      final result = scene.bundle.query.nearestEdge(position, 8.0);
      if (result != null) {
        final key = result.edge.key(scene.bundle);
        final ref = scene.cells.refOf(key);
        if (ref != null) return ref;
      }
    }

    {
      final result = scene.bundle.query.facesAt(position);
      for (final face in result.toList().reversed) {
        final key = face.key(scene.bundle);
        final ref = scene.cells.refOf(key);
        if (ref != null) return ref;
      }
    }

    return null;
  }

  CellKey? cellAt(Vec2 position) {
    final ref = refAt(position);
    if (ref == null) return null;
    return scene.cells.keyOf(ref);
  }

  Statement? statementAt(Vec2 position) {
    final ref = refAt(position);
    if (ref == null) return null;
    final id = ref.statement;
    final program = scene.program;
    final statement = program.byId(id);
    return statement;
  }
}
