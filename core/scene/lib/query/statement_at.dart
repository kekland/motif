import 'package:geometry/geometry.dart';
import 'package:program/program.dart';
import 'package:scene/scene.dart';
import 'package:kernel/kernel.dart';

extension SceneStatementAtQuery on SceneQuery {
  CellRef<CellHandle>? refAt(Vec2 position) {
    {
      final result = scene.bundle.query.nearestVertex(position, 8.0);
      if (result != null) return scene.refOf(result.vertex);
    }

    {
      final result = scene.bundle.query.nearestEdge(position, 8.0);
      if (result != null) return scene.refOf(result.edge);
    }

    {
      final result = scene.bundle.query.facesAt(position);
      if (result.isNotEmpty) return scene.refOf(result.last);
    }

    return null;
  }

  Statement? statementAt(Vec2 position) {
    final ref = refAt(position);
    if (ref == null) return null;
    return scene.statement(ref.statementId);
  }
}
