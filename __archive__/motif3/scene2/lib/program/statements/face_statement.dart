part of '../program.dart';

final class FaceStatement extends Statement with PlacedStatement {
  FaceStatement(
    List<EdgeRef> outer, {
    List<List<EdgeRef>> holes = const [],
    this.style = .default_,
    super.id,
    super.scope,
    FrameRef? parent,
  }) : outer = outer.borrow(),
       holes = [for (final hole in holes) hole.borrow()],
       parent = parent?.borrow();

  final List<Arg<EdgeRef>> outer;
  final List<List<Arg<EdgeRef>>> holes;
  final FaceStyle style;

  @override
  final Borrow<FrameRef>? parent;

  @override
  late final _args = [...outer, for (final hole in holes) ...hole, ?parent];

  late final ref = Ref.face(this, 'face');

  @override
  void performExecute(EvalContext context) {
    final outer = context.resolve.all(this.outer.refs);
    final holes = [for (final hole in this.holes) context.resolve.all(hole.refs)];

    final handle = context.transaction.makeFace(
      ref.cellId,
      outer,
      holes: holes,
      parent: context.resolve.maybe(parent?.ref),
    );

    context.bind(ref, handle, style: style);
  }

  @override
  FaceStatement copyWith({
    StatementId? id,
    Scope? scope,
    List<EdgeRef>? outer,
    List<List<EdgeRef>>? holes,
    FaceStyle? style,
    FrameRef? parent,
  }) => .new(
    id: id ?? this.id,
    scope: scope ?? this.scope,
    outer ?? this.outer.refs,
    holes: holes ?? [for (final hole in this.holes) hole.refs],
    style: style ?? this.style,
    parent: parent ?? this.parent?.ref,
  );
}
