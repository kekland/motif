part of '../_program.dart';

extension RouteGenerate on Evaluation {
  ProgramEdit routeGenerate(Iterable<StatementId> ids, Generator generator) {
    if (ids.isEmpty) {
      final statement = GeneratorStatement(generator: generator);
      return .build(this, (edit) => edit.insert([statement]));
    }

    final inputs = SplayTreeSet<StatementId>(evalOrder)..addAll(ids);
    final spaces = [
      for (final id in inputs)
        switch (program.statement(id)!) {
          PlacedStatement(:final parent?) => bundle.frame(parent.ref)!,
          _ => FrameHandle.root,
        },
    ];

    final lca = bundle.lcaMany(spaces);
    final statement = GeneratorStatement(
      generator: generator,
      inputs: [for (final id in inputs) .new(id)],
      parent: lca.ref(bundle),
    );

    return .build(this, (edit) => edit.insert([statement], at: .after(inputs.last)));
  }
}
