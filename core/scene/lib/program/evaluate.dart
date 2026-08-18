part of 'program.dart';

final class Evaluation {
  Evaluation._(
    this.bundle,
    this.table,
    this.style,
    this.styleOverrides,
    this.layout,
  );

  final TopologyBundle bundle;
  final ExportTable table;
  final StyleTable style;
  final StyleOverrides? styleOverrides;
  final LayoutOverrides? layout;

  CellHandle? cell(Ref ref) {
    final cell = table.keyOf(ref);
    return cell == null ? null : bundle.handle(cell);
  }

  VertexHandle? vertex(VertexRef ref) {
    final cell = table.keyOf(ref);
    return cell == null ? null : bundle.vertex(cell.id);
  }

  EdgeHandle? edge(EdgeRef ref) {
    final cell = table.keyOf(ref);
    return cell == null ? null : bundle.edge(cell.id);
  }

  FaceHandle? face(FaceRef ref) {
    final cell = table.keyOf(ref);
    return cell == null ? null : bundle.face(cell.id);
  }

  FrameHandle? frame(FrameRef ref) {
    final cell = table.keyOf(ref);
    return cell == null ? null : bundle.frame(cell.id);
  }
}

Evaluation dryExecute(
  Program program, {
  LayoutOverrides? layout,
  StyleOverrides? decoration,
}) {
  final resolvedLayout = layout ?? solveLayout(program.layoutBoxes);

  final bundle = TopologyBundle();
  final transaction = bundle.beginTransaction();
  final table = ExportTable();
  final decorationTable = StyleTable();
  final context = EvalContext(
    transaction: transaction,
    exports: table,
    layout: resolvedLayout,
    decoration: decorationTable,
    decorationOverrides: decoration,
  );

  for (final stmt in program._statements) {
    _executeOne(context, stmt);
  }

  transaction.commit();
  return Evaluation._(bundle, table, decorationTable, decoration, resolvedLayout);
}

(List<TopologyOp>, bool) _executeOne(EvalContext context, Statement stmt) {
  final txn = context.transaction;
  final mark = txn.ops.length;

  try {
    stmt.execute(context);
    final ops = txn.ops.sublist(mark);
    return (ops, ops.isNotEmpty);
  } on UnresolvedRef {
    for (var i = txn.ops.length - 1; i >= mark; i--) {
      txn.ops[i].unapply(txn);
    }

    txn.ops.removeRange(mark, txn.ops.length);
    return ([], false);
  }
}
