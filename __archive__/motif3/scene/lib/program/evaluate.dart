part of 'program.dart';

final class Evaluation {
  Evaluation._(
    this.bundle,
    this.cells,
    this.style,
    this.styleOverrides,
    this.layout,
  );

  final TopologyBundle bundle;
  final CellTable cells;
  final StyleTable style;
  final StyleOverrides? styleOverrides;
  final LayoutOverrides? layout;

  CellGraph get cellGraph => ._((bundle, cells));

  CellHandle? cell(Ref ref) {
    final cell = cells.keyOf(ref);
    return cell == null ? null : bundle.handle(cell);
  }

  VertexHandle? vertex(VertexRef ref) {
    final cell = cells.keyOf(ref);
    return cell == null ? null : bundle.vertex(cell.id);
  }

  EdgeHandle? edge(EdgeRef ref) {
    final cell = cells.keyOf(ref);
    return cell == null ? null : bundle.edge(cell.id);
  }

  FaceHandle? face(FaceRef ref) {
    final cell = cells.keyOf(ref);
    return cell == null ? null : bundle.face(cell.id);
  }

  FrameHandle? frame(FrameRef ref) {
    final cell = cells.keyOf(ref);
    return cell == null ? null : bundle.frame(cell.id);
  }
}

Evaluation dryExecute(
  Program program, {
  LayoutOverrides? layout,
  StyleOverrides? styleOverrides,
}) {
  final resolvedLayout = layout ?? solveLayout(program.layoutBoxes);

  final bundle = TopologyBundle();
  final transaction = bundle.beginTransaction();
  final table = CellTable();
  final decorationTable = StyleTable();
  final context = EvalContext(
    transaction: transaction,
    cells: table,
    layout: resolvedLayout,
    style: decorationTable,
    styleOverrides: styleOverrides,
  );

  for (final stmt in program._statements) {
    _executeOne(context, stmt);
  }

  transaction.commit();
  return Evaluation._(bundle, table, decorationTable, styleOverrides, resolvedLayout);
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
