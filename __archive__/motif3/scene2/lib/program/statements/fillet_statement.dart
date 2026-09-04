part of '../program.dart';

final class FilletStatement extends Statement {
  FilletStatement(
    VertexRef vertex, {
    required EdgeRef edgeA,
    required EdgeRef edgeB,
    required double radiusA,
    required double radiusB,
    super.id,
    super.scope,
  }) : a = (edgeA.borrow(), radiusA),
       b = (edgeB.borrow(), radiusB),
       vertex = vertex.own();

  final Own<VertexRef> vertex;
  final (Borrow<EdgeRef>, double) a;
  final (Borrow<EdgeRef>, double) b;

  @override
  late final _args = [vertex, a.$1, b.$1];

  @override
  void performExecute(EvalContext context) {
    final v = context.resolve(vertex.ref);
    final edgeA = context.resolve(a.$1.ref);
    final edgeB = context.resolve(b.$1.ref);

    final radiusA = a.$2;
    final radiusB = b.$2;

    context.transaction.filletVertex(
      v,
      a: (edgeA, radiusA),
      b: (edgeB, radiusB),
    );
  }

  @override
  FilletStatement copyWith({
    StatementId? id,
    Scope? scope,
    VertexRef? vertex,
    EdgeRef? edgeA,
    EdgeRef? edgeB,
    double? radiusA,
    double? radiusB,
  }) => FilletStatement(
    vertex ?? this.vertex.ref,
    edgeA: edgeA ?? a.$1.ref,
    edgeB: edgeB ?? b.$1.ref,
    radiusA: radiusA ?? a.$2,
    radiusB: radiusB ?? b.$2,
    id: id ?? this.id,
    scope: scope ?? this.scope,
  );
}
