part of 'kernel.dart';

sealed class TopologyOp {
  const TopologyOp();

  void reapply(TopologyTransaction txn);
  void unapply(TopologyTransaction txn);
}

sealed class CompositeOp extends TopologyOp {
  CompositeOp(List<TopologyOp> children) : children = .unmodifiable(children);

  final List<TopologyOp> children;

  @override
  void reapply(TopologyTransaction txn) {
    for (final op in children) op.reapply(txn);
  }

  @override
  void unapply(TopologyTransaction txn) {
    for (final op in children.reversed) op.unapply(txn);
  }
}
