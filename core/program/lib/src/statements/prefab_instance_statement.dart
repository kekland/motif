part of '../_program.dart';

final class PrefabInstanceStatement extends Statement
    with PlacedStatement, FramedStatement, LayoutBoxStatement, GeneratingStatement
    implements LayoutContainer {
  PrefabInstanceStatement({
    required this.prefabId,
    this.overrides = const .new(),
    Mat4? transform,
    FrameRef? parent,
    this.size,
    this.layout,
    this.vertexStyle,
    this.edgeStyle,
    this.faceStyle,
    super.id,
    super.modifiers,
    super.name,
  }) : transform = transform ?? .identity(),
       parent = .of(parent) {
    selectors = [?this.parent];
  }

  PrefabOriginStatement origin(PrefabIndex index) => index.originOf(prefabId)!;

  @override
  final ParentSelector? parent;

  @override
  FrameRef get frame => id.cell(.frame, 0);

  @override
  final Mat4 transform;

  @override
  Layout resolveLayout(EvalContext context) => layout ?? origin(context.prefabs).resolveLayout(context);
  final Layout? layout;

  @override
  Size2 intrinsicSize(Evaluation evaluation) => origin(evaluation.prefabs).intrinsicSize(evaluation);

  @override
  LayoutSize resolveSize(EvalContext context) => size ?? origin(context.prefabs).resolveSize(context);
  final LayoutSize? size;

  final VertexStyle? vertexStyle;
  final EdgeStyle? edgeStyle;
  final FaceStyle? faceStyle;

  VertexStyle resolveVertexStyle(EvalContext context) => vertexStyle ?? origin(context.prefabs).vertexStyle;
  EdgeStyle resolveEdgeStyle(EvalContext context) => edgeStyle ?? origin(context.prefabs).edgeStyle;
  FaceStyle resolveFaceStyle(EvalContext context) => faceStyle ?? origin(context.prefabs).faceStyle;

  @override
  bool get isLeaf => false;

  @override
  ModifierStack resolveModifiers(EvalContext context) => modifiers ?? origin(context.prefabs).modifiers ?? .empty();

  PrefabInstanceStatement.fromOrigin(PrefabOriginStatement origin, {StatementId? id})
    : this(id: id, prefabId: origin.id, name: origin.name);

  final PrefabId prefabId;
  final GeneratorOverrides overrides;

  @override
  Iterable<Op> execute(EvalContext context) {
    final origin = this.origin(context.prefabs);

    final container = ContainerStatement(
      shape: origin.shape,
      layout: layout ?? origin.layout,
      vertexStyle: vertexStyle ?? origin.vertexStyle,
      edgeStyle: edgeStyle ?? origin.edgeStyle,
      faceStyle: faceStyle ?? origin.faceStyle,
      size: size ?? origin.size,
      transform: transform,
      parent: parent?.ref,
      id: id,
    );

    return container.execute(context);
  }

  @override
  Iterable<GeneratedStatement> generate(EvalContext context) {
    final sourceSlice = context.prefabs.sliceOf(prefabId);
    final overridden = sourceSlice.transform((i, s) {
      if (i == 0) return s;

      final overrides = this.overrides[s.id];
      if (overrides == null) return s;

      var out = overrides.partial?.apply(s) ?? s;
      if (out is PrefabInstanceStatement && overrides.children.isNotEmpty) {
        out = out.copyWith(overrides: .merged(out.overrides, overrides.children));
      }
      return out;
    });

    final output = <GeneratedStatement>[];
    final materialized = overridden.materializeRaw((i, s) => i == 0 ? id : context.derive(s.id.value));

    for (var i = 1; i < sourceSlice.statements.length; i++) {
      output.add((sourceSlice.statements[i].id, materialized.$2.statements[i]));
    }

    return output;
  }

  @override
  PrefabInstanceStatement copyWith({
    StatementId? id,
    ModifierStack? modifiers,
    String? name,
    PrefabId? prefabId,
    GeneratorOverrides? overrides,
    Layout? layout,
    LayoutSize? size,
    Mat4? transform,
    ObjectShape? shape,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  }) => .new(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    name: name ?? this.name,
    prefabId: prefabId ?? this.prefabId,
    overrides: overrides ?? this.overrides,
    transform: transform ?? this.transform,
    size: size ?? this.size,
    layout: layout ?? this.layout,
    // shape: shape ?? this.shape,
    vertexStyle: vertexStyle ?? this.vertexStyle,
    edgeStyle: edgeStyle ?? this.edgeStyle,
    faceStyle: faceStyle ?? this.faceStyle,
    parent: parent ?? this.parent?.ref,
  );

  @override
  PrefabInstanceStatement applyPartial(StatementPartial partial) => copyWith(
    modifiers: partial.field(#modifiers),
    name: partial.field(#name),
    prefabId: partial.field(#prefabId),
    layout: partial.field(#layout),
    size: partial.field(#layoutSize),
    transform: partial.field(#transform),
    shape: partial.field(#shape),
    vertexStyle: partial.field(#vertexStyle),
    edgeStyle: partial.field(#edgeStyle),
    faceStyle: partial.field(#faceStyle),
  );

  @override
  PrefabInstanceStatement? absorbChildUpdate(EvalContext context, List<StatementId> path, StatementPartial update) {
    return copyWith(overrides: .merged(overrides, .at(path, update)));
  }
}
