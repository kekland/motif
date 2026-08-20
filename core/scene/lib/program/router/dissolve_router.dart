part of '../program.dart';

final class DissolveContext {
  DissolveContext(this.evaluation, this._removed);
  final Evaluation evaluation;
  final Set<StatementId> _removed;

  bool survives(Ref ref) => !_removed.contains(ref.statement);

  TopologyBundle get bundle => evaluation.bundle;
  CellHandle handle(Ref ref) => evaluation.cell(ref)!;
  FrameRef? parent(CellHandle handle) {
    final parent = bundle.parentOf(handle);
    if (parent == null) return null;
    return evaluation.table.refOf(bundle.frameKey(parent));
  }

  (FrameHandle, FrameRef?) survivingSpace(CellHandle handle) {
    var frame = bundle.parentOf(handle);

    while (frame != null) {
      final ref = evaluation.table.refOf(bundle.frameKey(frame));
      if (ref != null && survives(ref)) return (frame, ref);
      frame = bundle.parentOf(frame);
    }

    return (bundle.root, null);
  }
}

sealed class DissolveResult {
  const DissolveResult();

  const factory DissolveResult.cascade() = CascadeDissolve;
  const factory DissolveResult.degrade(List<Statement> replacements, {Map<Ref, Ref> refMap}) = DegradeDissolve;
}

final class CascadeDissolve extends DissolveResult {
  const CascadeDissolve();
}

final class DegradeDissolve extends DissolveResult {
  const DegradeDissolve(this.replacements, {this.refMap = const {}});
  final List<Statement> replacements;
  final Map<Ref, Ref> refMap;
}

final class DissolveRouter {
  DissolveRouter._({required this.removed, required this.replaced, required this.refMap});

  final Set<StatementId> removed;
  final Map<StatementId, List<Statement>> replaced;
  final Map<Ref, Ref> refMap;

  bool get isEmpty => removed.isEmpty;
}

extension DissolveProgram on Program {
  DissolveRouter resolveDissolveRouter(Evaluation evaluation, Iterable<StatementId> roots) {
    final removed = <StatementId>{...roots};
    final replaced = <StatementId, List<Statement>>{};
    final refMap = <Ref, Ref>{};

    final context = DissolveContext(evaluation, removed);

    final lost = <Ref>{};
    for (final id in roots) {
      final statement = byId(id);
      if (statement == null) continue;
      lost.addAll(statement.products);
    }

    var work = {...lost};
    var guard = 0;

    while (work.isNotEmpty) {
      assert(guard++ < 64 + length * 4, 'dissolve loop guard exceeded');

      final affected = <Statement>[];
      for (final statement in statements) {
        if (removed.contains(statement.id)) continue;
        final current = replaced[statement.id]?.singleOrNull ?? statement;
        if (current.args.any((arg) => work.contains(arg.ref))) {
          affected.add(current);
        }
      }

      final next = <Ref>{};
      for (final statement in affected) {
        final statementLost = statement.args.map((a) => a.ref).toSet().intersection(lost);
        final result = statement.routeDissolve(context, statementLost);

        if (result is CascadeDissolve) {
          removed.add(statement.id);
          replaced.remove(statement.id);
          for (final product in statement.products) {
            if (lost.add(product)) next.add(product);
          }
        } else if (result is DegradeDissolve) {
          final replacements = result.replacements;
          final map = result.refMap;

          replaced[statement.id] = replacements;
          refMap.addAll(map);

          final surviving = {
            ...map.keys,
            for (final r in replacements) ...r.products,
          };

          for (final product in statement.products) {
            if (!surviving.contains(product) && lost.add(product)) {
              next.add(product);
            }
          }
        }
      }

      work = next;
    }

    assert(() {
      for (final replacements in replaced.values) {
        for (final statement in replacements) {
          for (final arg in statement.args) {
            if (removed.contains(arg.ref.statement)) return false;
          }
        }
      }
      return true;
    }(), 'dissolve produced a replacement referencing a removed statement');

    return DissolveRouter._(
      removed: removed,
      replaced: replaced,
      refMap: refMap,
    );
  }
}
