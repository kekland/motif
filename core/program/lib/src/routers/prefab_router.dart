part of '../_program.dart';

extension RoutePrefab on Evaluation {
  ProgramEdit routePackagePrefab(Iterable<CellRef> targets) {
    final slice = routeSlice(targets);

    final unparented = <StatementId>{};
    for (final statement in slice.statements) {
      if (statement is! PlacedStatement) continue;
      final parent = statement.parent?.ref;
      if (parent == null) unparented.add(statement.id);
    }

    // Packaging an existing container.
    if (unparented.length == 1 && slice.statements[0] is ContainerStatement) {
      final container = slice.statements[0] as ContainerStatement;
      final origin = PrefabOriginStatement.fromContainer(container: container);

      return .build(this, (e) {
        e.replace(container.id, [origin]);
      });
    }

    // Reparent everything into a container.
    return .build(this, (edit) {
      final products = <CellRef>{};
      var totalBbox = Aabb2.invertedInfinity();

      for (final s in slice.statements) {
        products.addAll(productsOf(rootOf(s.id)));
      }

      for (final product in products) {
        final productBbox = bundle.query.bbox(product, space: .root);
        if (productBbox != null) totalBbox.hull(productBbox);
      }

      var parent = bundle.query.lcaMany(products);
      if (products.contains(parent)) {
        parent = bundle.query.parent(parent) ?? .root;
      }

      final worldToLocal = bundle.query.worldToLocal(parent);
      totalBbox = totalBbox.transformed(worldToLocal);
      final prefab = PrefabOriginStatement(
        parent: parent,
        transform: .translation2(totalBbox.topLeft),
        size: .fixed(totalBbox.width, totalBbox.height),
        faceStyle: .none,
        edgeStyle: .none,
      );

      edit.insert([prefab], at: .at(slice.statements.first.id));

      for (final id in unparented) {
        final updated = (slice[id] as PlacedStatement).absorbReparent(prefab.frame, prefab.transform.inverted());
        slice[id] = updated;
        edit.replace(id, [updated]);
      }
    });
  }

  // PrefabChange? routePrefabEdits(ProgramEdit edit) {
  //   final changedPrefabs = <PrefabId, ProgramSlice>{};

  //   for (final change in edit.changes.whereType<StatementChange>()) {
  //     final id = program[change.anchor.resolve(program)!].id;
  //     final origin = prefabOriginOf(id);
  //     if (origin == null) continue;

  //     final prefab = program.prefabs[origin.prefabId];
  //     if (prefab == null) continue;

  //     final slice = changedPrefabs[origin.prefabId] = prefab.slice.clone();
  //     slice.apply(change);
  //   }

  //   if (changedPrefabs.isEmpty) return null;
  //   return .new(
  //     inserted: changedPrefabs.entries.map((e) => Prefab(id: e.key, slice: e.value)).toList(),
  //     removed: [],
  //   );
  // }
}
