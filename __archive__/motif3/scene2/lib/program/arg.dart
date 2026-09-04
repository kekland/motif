part of 'program.dart';

/// An argument to a statement, that is resolved from other statements.
sealed class Arg<R extends Ref> {
  Arg(this._ref);

  R _ref;
  R get ref => _ref;

  /// Remaps the reference of this argument.
  ///
  /// Note that this method will mutate the arg in place.
  ///
  /// Returns [true] if the reference changed.
  bool _remap(Remap remapper) {
    final newValue = remapper(_ref) as R;
    assert(newValue.kind == _ref.kind, 'remapper changed the kind of the reference');

    if (newValue == _ref) return false;
    _ref = newValue;
    return true;
  }
}

final class Borrow<R extends Ref>(super._ref) extends Arg<R>;
final class Own<R extends Ref>(super._ref) extends Arg<R>;

extension _ArgBox<H extends CellHandle> on Ref<H> {
  Borrow<Ref<H>> borrow() => .new(this);
  Own<Ref<H>> own() => .new(this);
}

extension _ArgListBox<H extends CellHandle> on List<Ref<H>> {
  List<Borrow<Ref<H>>> borrow() => map(Borrow.new).toList();
  List<Own<Ref<H>>> own() => map(Own.new).toList();
}

extension _ArgListUnbox<H extends CellHandle> on List<Arg<Ref<H>>> {
  List<Ref<H>> get refs => [for (final e in this) e.ref];
}
