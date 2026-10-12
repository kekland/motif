part of '../_program.dart';

final class PrefabInstanceStatement extends ContainerStatement with GeneratingStatement {
  PrefabInstanceStatement({
    required this.prefabId,
    this.overrides = const {},
    super.layout,
    super.size,
    super.transform,
    super.shape,
    super.vertexStyle,
    super.edgeStyle,
    super.faceStyle,
    super.parent,
    super.id,
    super.modifiers,
    super.name,
  });

  PrefabInstanceStatement.fromOrigin(PrefabOriginStatement origin, {StatementId? id})
    : this(
        prefabId: origin.id,
        layout: origin.layout,
        size: origin.size,
        transform: origin.transform,
        shape: origin.shape,
        vertexStyle: origin.vertexStyle,
        edgeStyle: origin.edgeStyle,
        faceStyle: origin.faceStyle,
        parent: origin.parent?.ref,
        id: id,
        modifiers: origin.modifiers,
        name: origin.name,
      );

  final StatementId prefabId;
  final Map<StatementId, StatementPartial> overrides;

  @override
  Iterable<Op> execute(EvalContext context) {
    final origin = context._evaluation.prefabs.originOf(prefabId);
    if (origin == null) throw Exception('prefab origin not found: $prefabId');

    final container = ContainerStatement(
      layout: origin.layout,
      shape: origin.shape,
      vertexStyle: origin.vertexStyle,
      edgeStyle: origin.edgeStyle,
      faceStyle: origin.faceStyle,
      size: size,
      transform: transform,
      parent: parent?.ref,
      id: id,
    );

    return container.execute(context);
  }

  @override
  Iterable<Statement> generate(EvalContext context) {
    final origin = context._evaluation.prefabs.originOf(prefabId);
    if (origin == null) throw Exception('prefab origin not found: $prefabId');

    final rawSlice = context._evaluation.prefabs.sliceOf(origin.id);
    final slice = rawSlice.materializeRaw((i, s) {
      if (i == 0) return id;
      return context.derive(s.id.value);
    });

    final output = <Statement>[];
    for (var i = 1; i < slice.statements.length; i++) {
      final stmt = slice.statements[i];
      final override = overrides[stmt.id];
      if (override != null) {
        output.add(override.apply(stmt));
      } else {
        output.add(stmt);
      }
    }

    return output;
  }

  @override
  PrefabInstanceStatement copyWith({
    StatementId? id,
    ModifierStack? modifiers,
    String? name,
    StatementId? prefabId,
    Map<StatementId, StatementPartial>? overrides,
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
    layout: layout ?? this.layout,
    size: size ?? this.size,
    transform: transform ?? this.transform,
    shape: shape ?? this.shape,
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
  PrefabInstanceStatement? absorbChildUpdate(StatementId child, StatementPartial<Statement> update) {
    final override = overrides[child];
    final newOverrides = {...overrides};

    if (override != null) {
      newOverrides[child] = .merged([override, update]);
    } else {
      newOverrides[child] = update;
    }

    return copyWith(overrides: newOverrides);
  }
}
