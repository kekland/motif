part of '../_program.dart';

final class GeneratorStatement extends Statement with PlacedStatement, GeneratingStatement, FramedStatement {
  GeneratorStatement({
    required this.generator,
    List<FragmentSelector> inputs = const [],
    FrameRef? parent,
    Mat4? transform,
    super.id,
    super.modifiers,
  }) : inputs = inputs.map((i) => i.clone()).toList(),
       parent = .of(parent),
       transform = transform?.copy() ?? .identity() {
    selectors = [...this.inputs, ?this.parent];
  }

  final Generator generator;
  final List<FragmentSelector> inputs;
  final Mat4 transform;

  @override
  final ParentSelector? parent;

  @override
  bool get isLeaf => false;

  @override
  FrameRef get frame => id.cell(.frame, 0);

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield AddFrameOp(transform, size: null, parent: context.maybeResolve(parent));

    for (final input in inputs) {
      for (final r in input.resolved(context)) {
        if (!context.bundle.isLive(r)) continue;
        yield switch (r.kind) {
          .frame => DeleteFrameOp(r.asFrame),
          .vertex => DeleteVertexOp(r.asVertex),
          .edge => DeleteEdgeOp(r.asEdge),
          .face => DeleteFaceOp(r.asFace),
        };
      }
    }
  }

  @override
  Iterable<Statement> generate(EvalContext context) {
    final statements = inputs.map(context.resolve).toList();
    final slice = ProgramSlice(statements: statements);
    final output = generator.execute(context, slice).statements;
    final generatedIds = output.map((s) => s.id).toSet();

    final result = <Statement>[];
    for (final s in output) {
      if (s is PlacedStatement && !generatedIds.contains(s.parent?.ref.statementId)) {
        result.add(s.absorbReparent(frame, .identity()));
      } else {
        result.add(s);
      }
    }

    return result;
  }

  @override
  GeneratorStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    Generator? generator,
    List<FragmentSelector>? inputs,
    Mat4? transform,
    FrameRef? parent,
  }) => .new(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    generator: generator ?? this.generator,
    inputs: inputs ?? this.inputs,
    transform: transform ?? this.transform,
    parent: parent ?? this.parent?.ref,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .absorb;

  @override
  TransformAbsorb absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) {
    return .new((m) => copyWith(transform: m * transform), cell: frame);
  }

  @override
  Statement absorbReparent(FrameRef to, Mat4 parentTransform) => copyWith(parent: to, transform: parentTransform);
}
