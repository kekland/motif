part of '../program.dart';

final class GeneratorStatement extends Statement {
  new({
    required List<FragmentSelector> selectors,
    required this.generator,
    super.id,
    super.enabled,
  }) : selectors = selectors.map((s) => s.clone()).toList();

  @override
  final List<FragmentSelector> selectors;
  final Generator generator;

  @override
  Iterable<Op<dynamic>> execute(EvalContext context) sync* {
    for (final s in selectors) {
      final p = s.resolved(context);
      for (final r in p) {
        yield switch (r.kind) {
          .frame => DeleteFrameOp(r.asFrame),
          .vertex => DeleteVertexOp(r.asVertex),
          .edge => DeleteEdgeOp(r.asEdge),
          .face => DeleteFaceOp(r.asFace),
        };
      }
    }
  }

  Iterable<Statement> generate(EvalContext context) {
    final inputs = selectors.map((s) => context.resolve(s)).toList();
    final input = ProgramSlice.merged(
      inputs,
      indexOf: (id) => context._evaluation.indexOf(id)!,
    );

    final output = generator.execute(context, input).statements;
    final idMap = {
      for (final s in output)
        if (!context.derived(s.id)) s.id: context.derive(s.id.value),
    };
    if (idMap.isEmpty) return output;

    final remap = Remap.namespace(idMap);
    return [for (final s in output) s.remap(remap)!];
  }

  @override
  GeneratorStatement copyWith({
    StatementId? id,
    bool? enabled,
    List<FragmentSelector>? selectors,
    Generator? generator,
  }) => .new(
    id: id ?? this.id,
    enabled: enabled ?? this.enabled,
    selectors: selectors ?? this.selectors,
    generator: generator ?? this.generator,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .forward([
    for (final input in selectors)
      for (final s in context.resolve(input).statements) ...context.productsOf(s.id),
  ]);
}
