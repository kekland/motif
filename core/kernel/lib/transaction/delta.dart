part of '../kernel.dart';

sealed class Action() {
  factory Action.applied(OpRecord record) = Applied;
  factory Action.reverted(OpRecord record) = Reverted;
  factory Action.replayed(OpRecord record) = Replayed;
  factory Action.updated(OpRecord record, Op before) = Updated;
}

final class Applied(final OpRecord record) extends Action;
final class Reverted(final OpRecord record) extends Action;
final class Replayed(final OpRecord record) extends Action;
final class Updated<O extends Op>(final OpRecord<O> record, final O before) extends Action;

final class Delta {
  Delta();

  factory Delta.merged(Delta base, Iterable<Delta> others) {
    final d = base.copy();
    for (final o in others) d.fold(o);
    return d;
  }

  final actions = <Action>[];

  final added = HashSet<CellRef>();
  final deleted = HashSet<CellRef>();
  var moved = <CellRef>[];

  late final writes = {...added, ...deleted, ...moved};

  final lineage = <Lineage>[];

  void markAdded(CellRef ref) => added.add(ref);
  void markDeleted(CellRef ref) => deleted.add(ref);

  // void record(Lineage l) {
  //   assert(_deleted.contains(l.source), 'lineage source must be deleted');
  //   assert(_lineageBySource[l.source] == null, 'duplicate lineage source ${l.source}');
  //   _lineage.add(l);
  //   _lineageBySource[l.source] = l;
  //   for (final p in l.products) _lineageByProduct[p] = l;
  // }

  // void recordAll(Iterable<Lineage> ls) => ls.forEach(record);

  void fold(Delta other) {
    actions.addAll(other.actions);
    added.addAll(other.added);
    moved.addAll(other.moved);
    deleted.addAll(other.deleted);
    lineage.addAll(other.lineage);
  }

  Delta copy() => .new()..fold(this);
}
