part of 'program.dart';

/// Identifier for a statement in a program. Guaranteed to be unique and increasing.
extension type const StatementId._(int internal) {
  StatementId.generate() : this._(_value++);
  StatementId.fromValue(String value) : this._(int.parse(value));

  static var _value = 0;

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

  void execute(EvalContext context);

  Statement copyWith();
  Statement updateWith(covariant StatementPartial partial) => partial.apply(this);
  
  StatementPartial partial();
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

sealed class StatementPartial<T extends Statement> {
  const StatementPartial();
  T apply(T statement);
}
