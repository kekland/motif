part of 'program.dart';

/// Identifier for a statement in a program. Guaranteed to be unique and increasing.
extension type const StatementId._(int internal) {
  StatementId.generate() : this._(_next++);

  factory StatementId.fromValue(String value) {
    final parsed = int.parse(value);
    if (parsed >= _next) _next = parsed + 1;
    return StatementId._(parsed);
  }

  static var _next = 0;

  String get value => internal.toString();
}

sealed class Statement {
  Statement({StatementId? id}) : id = id ?? .generate();
  final StatementId id;

  Iterable<Arg> get _args;
  Iterable<Ref> get _products;

  Iterable<Arg> get args => _args;
  Iterable<Ref> get products => _products;

  CellId get baseId => .new('s${id.value}');
  CellId cellId(String key) => baseId.derive(key);

  TransformResult routeTransform(TransformContext context, Symbol product) => const .refused();
  DissolveResult routeDissolve(DissolveContext context, Set<Ref> lost) => const .cascade();

  void execute(EvalContext context);

  Statement copyWith({StatementId? id});
  Statement copyWithRefs(Ref Function(Ref) remap, {StatementId? id}) {
    var touched = id != this.id;
    final s = copyWith(id: id);
    for (final arg in s._args) {
      final newRef = remap(arg.ref);
      if (newRef != arg.ref) touched = true;
      arg.ref = newRef;
    }

    if (!touched) return this;
    return s;
  }
}

sealed class PlacedStatement extends Statement {
  PlacedStatement({super.id, FrameRef? parent}) : parent = parent?.borrow();

  final Arg<FrameRef>? parent;
}

sealed class Arg<R extends Ref> {
  Arg(this.ref);
  R ref;

  bool get isBorrow;
  bool get isOwn;
}

final class Borrow<R extends Ref> extends Arg<R> {
  Borrow(super.ref);

  // dart format off
  @override bool get isBorrow => true;
  @override bool get isOwn => false;
  // dart format on
}

final class Own<R extends Ref> extends Arg<R> {
  Own(super.ref);

  // dart format off
  @override bool get isBorrow => false;
  @override bool get isOwn => true;
  // dart format on
}
