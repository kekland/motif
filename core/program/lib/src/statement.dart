part of '_program.dart';

/// A [Statement] is the fundamental unit of a program.
///
/// A statement can be executed, producing kernel operations. A statement can have [Selector]s, which indicate
/// dependencies on other statements/cells.
///
/// A statement also carries a list of [Modifier]s, which are statements that will be executed exactly after the base
/// statement runs. By definition, the modifier's dependencies is the base statement and any previous modifiers in the
/// stack.
sealed class Statement {
  Statement({
    StatementId? id,
    this.modifiers,
    String? name,
  }) : id = id ?? .allocate(),
       name = name != null && name.isNotEmpty ? name : null;

  final StatementId id;
  final ModifierStack? modifiers;
  late final List<Selector> selectors;
  final String? name;

  Iterable<Op> execute(EvalContext context);
  ModifierStack resolveModifiers(EvalContext context) => modifiers ?? .empty();

  Statement copyWith({
    StatementId? id,
    ModifierStack? modifiers,
    String? name,
  });

  Statement applyPartial(StatementPartial partial);

  /// Tries to apply a given [remap] to the statement and its selectors. Returns `null` if the remap is refused.
  Statement? maybeRemap(Remap remap) {
    final copy = copyWith();
    var touched = false;
    for (final s in copy.selectors) {
      final result = s._remap(remap);
      if (result == .refused) return null;
      if (result == .changed) touched = true;
    }

    final newId = remap.statement(id);
    if (newId != null) touched = true;

    if (!touched) return this;
    return copy.copyWith(id: newId);
  }

  /// Applies the given [remap] to the statement. Throws if the remap is refused.
  Statement remap(Remap remap) {
    final result = maybeRemap(remap);
    if (result == null) throw StateError('failed to remap statement $id');
    return result;
  }

  /// Returns [true] if this statement would produce the same result.
  bool isEquivalentTo(covariant Statement other) => false;

  // ----
  // Routers
  // ----

  TransformRoute routeTransform(EvalContext context, Ref target) => .refuse;
  TransformAbsorb? absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) => null;

  DissolveIntent routeDissolve(Set<CellRef> targeted) => .new(targeted);
  ReparentRoute routeReparent(CellRef target) => .refuse;
  Statement absorbReparent(FrameRef to, Mat4 parentTransform) => this;
}

class StatementPartial<S extends Statement>(final Map<Symbol, Object?> fields) extends Partial<S> {
  static StatementPartial? merged(Iterable<StatementPartial> partials) {
    if (partials.isEmpty) return null;

    final mergedFields = <Symbol, Object?>{};
    for (final partial in partials) mergedFields.addAll(partial.fields);
    return .new(mergedFields);
  }

  StatementPartial.modifiers(ModifierStack modifiers) : this({#modifiers: modifiers});
  StatementPartial.name(String name) : this({#name: name});

  StatementPartial.transform(Mat4 transform) : this({#transform: transform});
  StatementPartial.layoutSize(LayoutSize layoutSize) : this({#layoutSize: layoutSize});

  StatementPartial.vertexStyle(VertexStyle vertexStyle) : this({#vertexStyle: vertexStyle});
  StatementPartial.edgeStyle(EdgeStyle edgeStyle) : this({#edgeStyle: edgeStyle});
  StatementPartial.faceStyle(FaceStyle faceStyle) : this({#faceStyle: faceStyle});

  StatementPartial.objectShape(ObjectShape objectShape) : this({#objectShape: objectShape});

  StatementPartial.position(Vec2 position) : this({#position: position});

  StatementPartial.text(String text) : this({#text: text});
  StatementPartial.textFormat(TextFormat textFormat) : this({#textFormat: textFormat});
  StatementPartial.paragraphFormat(ParagraphFormat paragraphFormat) : this({#paragraphFormat: paragraphFormat});

  StatementPartial.corners(Map<int, CornerRadius> corners) : this({#corners: corners});
  StatementPartial.radius(CornerRadius radius) : this({#radius: radius});

  StatementPartial.glueVerticesPosition(GlueVerticesPosition glueVerticesPosition)
    : this({#glueVerticesPosition: glueVerticesPosition});

  StatementPartial.layout(Layout layout) : this({#layout: layout});

  T? field<T>(Symbol id) => fields[id] as T?;

  @override
  S apply(S statement) => statement.applyPartial(this) as S;
}
