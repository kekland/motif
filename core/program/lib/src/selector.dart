part of '_program.dart';

/// A [Selector] represents a [Statement]'s dependency on a cell or a [Statement].
///
/// Selectors may carry semantic meaning, which are used by routers to determine certain actions. For example, a
/// dependency on a [FrameRef] directly implies a direct, possibly mutating relationship with that frame, while using a
/// [ParentSelector] to refer to that frame implies a parent-child relationship, meaning that the object is indirectly
/// related to the frame.
sealed class Selector<T> {
  Selector(this.refs);

  T _resolve(EvalContext context);

  /// Cells that this selector depends on.
  final Iterable<CellRef> refs;

  /// Statements that this selector depends on.
  late final Set<StatementId> dependencies = {for (final r in refs) r.statementId};

  /// Set of cells that this selector resolves to.
  Iterable<CellRef> resolved(EvalContext context);

  /// Returns the result of attempting to remap this selector using the given [remap].
  ///
  /// Note that this mutates the selector, so it has to be cloned before remapping.
  RemapResult _remap(Remap remap);

  Selector<T> clone();
}

// extension SelectorIterableExtension on Iterable<Selector> {
//   Set<StatementId> get dependencies => {for (final s in this) ...s.dependencies};
// }

extension SelectorCellExtension<H extends CellHandle> on CellRef<H> {
  CellSelector<H> selector() => CellSelector(this);
}

typedef FrameSelector = Selector<FrameRef>;
typedef VertexSelector = Selector<VertexRef>;
typedef EdgeSelector = Selector<EdgeRef>;
typedef FaceSelector = Selector<FaceRef>;
