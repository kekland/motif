import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:scene/scene.dart';

extension SceneBboxQuery on SceneQuery {
  Aabb2 get sceneBbox {
    if (scene.program.statements.isEmpty) return .empty();
    return bbox(scene.program.statements.map((s) => s.id));
  }

  Aabb2 bbox(Iterable<StatementId> ids) {
    if (ids.isEmpty) return .empty();

    var totalBbox = Aabb2.invertedInfinity();

    for (final id in ids) {
      final products = scene.productsOf(scene.evaluation.rootOf(id));
      for (final product in products) {
        final productBbox = bundle.query.bbox(product, space: .root);
        if (productBbox != null) totalBbox.hull(productBbox);
      }
    }

    return totalBbox;
  }
}
