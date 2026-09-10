part of '../kernel.dart';

final class ReparentOp extends Op<void> {
  new({
    required this.cell,
    required this.parent,
  });

  final CellRef cell;
  final FrameRef? parent;

  @override
  void _execute(Transaction t, bool produceResult) {
    t._reparent(
      t.cellFor(cell),
      parent != null ? t.frameFor(parent!) : null,
    );
  }

  @override
  bool topologyEquals(Op<dynamic> other) {
    if (other is! ReparentOp) return false;
    return cell == other.cell && parent == other.parent;
  }
}
