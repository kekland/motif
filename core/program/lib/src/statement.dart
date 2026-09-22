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
    this.modifiers = const [],
  }) : id = id ?? .allocate();

  final StatementId id;
  final List<Modifier> modifiers;
  late final List<Selector> selectors;

  Iterable<Op> execute(EvalContext context);

  Statement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
  });

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

  // ----
  // Routers
  // ----

  TransformRoute routeTransform(EvalContext context, Ref target) => .refuse;
  TransformAbsorb? absorbTransform(EvalContext context, Set<Ref> absorbed, Set<Ref> all) => null;

  DissolveIntent routeDissolve(Set<CellRef> targeted) => .new(targeted);
  ReparentRoute routeReparent(CellRef target) => .refuse;
  Statement absorbReparent(FrameRef to, Mat4 parentTransform) => this;
}
