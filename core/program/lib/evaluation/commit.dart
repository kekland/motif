part of '../program.dart';

final class Commit {
  Commit.from(
    this.statement,
    this.ops,
    Delta d,
    this.targets,
    this.reads,
    this.dependencies,
    this.resolutions, {
    this.error,
  }) : added = d.added,
       deleted = d.deleted,
       lineage = d.lineage,
       moved = .of(d.moved) {
    _writes = .of(added.followedBy(deleted).followedBy(moved));
  }

  Statement statement;
  List<OpRecord> ops;
  final Set<CellRef> added, deleted;
  final List<Lineage> lineage;
  final HashSet<CellRef> moved;
  final Set<CellRef> targets;
  final Set<CellRef> reads;
  final Set<StatementId> dependencies;
  final Map<Selector, Object?> resolutions;
  final Object? error;

  bool get failed => error != null;

  late HashSet<CellRef> _writes;
  HashSet<CellRef> get writes => _writes;

  List<CellRef> refresh(
    Statement statement,
    Delta delta,
  ) {
    this.statement = statement;

    final newlyMoved = <CellRef>[];
    for (final r in delta.moved) {
      if (moved.add(r)) {
        _writes.add(r);
        newlyMoved.add(r);
      }
    }

    return newlyMoved;
  }
}
