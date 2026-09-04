part of '../program.dart';

final class DissolveIntent({final Set<Ref> lose = const {}, final Set<Ref> keep = const {}});
final class DissolveRemains(final List<Statement> replacements, final Map<Ref, Ref> refMap);

class RemainsContext {
  RemainsContext(this.evaluation, this._lost, this._refMap);

  final Evaluation evaluation;
  final Set<Ref> _lost;
  final Map<Ref, Ref> _refMap;

  bool isLost(Ref ref) => _lost.contains(ref);
  bool survives(Ref ref) => !_lost.contains(ref);

  TopologyBundle get bundle => evaluation.bundle;
  CellHandle? cell(Ref ref) => evaluation.cell(ref);
  CellHandle handle(Ref ref) => evaluation.cell(ref)!;
  Ref? ref(CellHandle handle) => evaluation.cells.refOf(bundle.key(handle));
  S? style<S extends CellStyle<S>>(Ref ref) => evaluation.style.of<S>(ref);

  Ref resolve(Ref ref) => _refMap[ref] ?? ref;
  (FrameHandle, FrameRef?) survivingSpace(CellHandle handle) {
    var frame = bundle.parentOf(handle);

    while (frame != null) {
      final ref = evaluation.cells.refOf(bundle.frameKey(frame));
      if (ref != null && survives(ref)) return (frame, ref);
      frame = bundle.parentOf(frame);
    }

    return (bundle.root, null);
  }
}

final class DissolveRouter {
  const DissolveRouter._({
    required this.lost,
    required this.removed,
    required this.replaced,
    required this.refMap,
  });

  final Set<Ref> lost;
  final Set<StatementId> removed;
  final Map<StatementId, List<Statement>> replaced;
  final Map<Ref, Ref> refMap;

  bool get isEmpty => removed.isEmpty && replaced.isEmpty;
}

extension DissolveProgram on Program {
  DissolveRouter resolveDissolveRouter(
    Evaluation evaluation, {
    Iterable<StatementId> statements = const [],
    Iterable<Ref> refs = const [],
  }) {
    final cells = evaluation.cells;
    final cellGraph = evaluation.cellGraph;
    final lost = <Ref>{};
    final pinned = <Ref>{};

    Ref canon(Ref r) {
      final key = cells.keyOf(r);
      if (key == null) return r; // consumed ref, no cell
      return cells.refOf(key) ?? r;
    }

    bool isLost(Ref r) => lost.contains(canon(r));
    void lose(Ref r) => lost.add(canon(r));

    // Intent.
    final targets = <StatementId, Set<Ref>>{};
    for (final ref in refs) targets.putIfAbsent(ref.statement, () => {}).add(ref);
    for (final id in statements) {
      final s = byId(id);
      if (s != null) targets.putIfAbsent(id, () => {}).addAll(s.products);
    }
    for (final MapEntry(key: id, value: targeted) in targets.entries) {
      final intent = byId(id)?.routeDissolve(targeted);
      if (intent == null) continue;
      intent.lose.forEach(lose);
      pinned.addAll(intent.keep);
    }

    bool dead(StatementId id) {
      final s = byId(id)!;
      return s.products.any(isLost) || s.args.any((a) => a.isOwn && isLost(a.ref));
    }

    bool used(Ref r) {
      if (r.kind != .frame && cellGraph.dependentsOf(r).any((d) => !isLost(d))) return true;
      return graph.borrowersOf(r).any((b) => !dead(b));
    }

    bool goes(Ref r) {
      if (cellGraph.dependenciesOf(r).any((d) => d.kind != .frame && isLost(d))) return true;
      if (pinned.any((p) => canon(p) == canon(r)) || used(r)) return false;
      return dead(r.statement) || (r.kind == .vertex && cellGraph.dependentsOf(r).isNotEmpty);
    }

    // Fixpoint.
    var changed = true;
    while (changed) {
      changed = false;
      for (final s in this.statements) {
        for (final r in s.products) {
          if (isLost(r)) continue;
          if (goes(r)) {
            lose(r);
            changed = true;
          }
        }
      }
    }

    // Bake.
    final removed = <StatementId>{};
    final replaced = <StatementId, List<Statement>>{};
    final refMap = <Ref, Ref>{};
    final context = RemainsContext(evaluation, lost, refMap);

    for (final s in this.statements) {
      if (!dead(s.id)) continue;
      final lostProducts = s.products.where(isLost).toSet();
      if (lostProducts.length == s.products.length) {
        removed.add(s.id);
        continue;
      }
      final remains = s.routeDissolveRemains(context, lostProducts);
      replaced[s.id] = remains.replacements;
      refMap.addAll(remains.refMap);
    }

    return ._(lost: lost, removed: removed, replaced: replaced, refMap: refMap);
  }
}
