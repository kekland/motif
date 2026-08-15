import 'package:geometry/geometry.dart';
import 'package:scene/scene.dart';
import 'package:kernel/kernel.dart';

extension SceneStatementAtQuery on SceneQuery {
  Ref<CellHandle>? refAt(Vec2 position) {
    {
      final result = scene.bundle.query.nearestVertex(position, 8.0);
      if (result != null) {
        final key = result.vertex.asKey(scene.bundle);
        final ref = scene.table.refOf(key);
        if (ref != null) return ref;
      }
    }

    {
      final result = scene.bundle.query.nearestEdge(position, 8.0);
      if (result != null) {
        final key = result.edge.asKey(scene.bundle);
        final ref = scene.table.refOf(key);
        if (ref != null) return ref;
      }
    }

    {
      final result = scene.bundle.query.facesAt(position);
      for (final face in result.toList().reversed) {
        final key = face.asKey(scene.bundle);
        final ref = scene.table.refOf(key);
        if (ref != null) return ref;
      }
    }

    return null;
  }

  CellKey? cellAt(Vec2 position) {
    final ref = refAt(position);
    if (ref == null) return null;
    return scene.table.keyOf(ref);
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
