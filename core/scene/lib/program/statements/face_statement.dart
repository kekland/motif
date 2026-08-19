part of '../program.dart';

final class FaceStatement extends PlacedStatement {
  FaceStatement(
    List<EdgeRef> outer, {
    List<List<EdgeRef>> holes = const [],
    this.style = .default_,
    super.parent,
    super.id,
  }) : outer = outer.borrow(),
       holes = [for (final hole in holes) hole.borrow()];

  final List<Arg<EdgeRef>> outer;
  final List<List<Arg<EdgeRef>>> holes;
  final FaceStyle style;

  @override
  late final _args = [...outer, for (final hole in holes) ...hole, ?parent];

  @override
  late final _products = [face];

  late final face = Ref.face(id, #face);

  @override
  void execute(EvalContext context) {
    final outer = [for (final arg in this.outer) context.resolve(arg)];
    final holes = [
      for (final hole in this.holes) [for (final arg in hole) context.resolve(arg)],
    ];

    final parent = context.resolveOptional(this.parent);
    final handle = context.transaction.makeFace(cellId('face'), outer, holes: holes, parent: parent);
    context.bind(face, handle, decoration: style);
  }

  @override
  TransformResult routeTransform(TransformContext context, Symbol product) {
    if (product != #face) return const .refused();
    return .forwarded([
      ...outer.refs,
      for (final hole in holes) ...hole.refs,
    ]);
  }

  @override
  FaceStatement copyWith({
    List<EdgeRef>? outer,
    List<List<EdgeRef>>? holes,
    FaceStyle? style,
    FrameRef? parent,
  }) => .new(
    outer ?? this.outer.refs,
    holes: holes ?? [for (final hole in this.holes) hole.refs],
    parent: parent ?? this.parent?.ref,
    style: style ?? this.style,
    id: id,
  );

  @override
  FaceStatement updateWith(FaceStatementPartial partial) => partial.apply(this);

  @override
  FaceStatementPartial partial({
    List<EdgeRef>? outer,
    List<List<EdgeRef>>? holes,
    FaceStylePartial? style,
    FrameRef? parent,
  }) => .new(
    outer: outer,
    holes: holes,
    style: style,
    parent: parent,
  );
}

final class const FaceStatementPartial({
  final List<EdgeRef>? outer,
  final List<List<EdgeRef>>? holes,
  final FaceStylePartial? style,
  final FrameRef? parent,
}) extends StatementPartial<FaceStatement> {
  @override
  FaceStatement apply(FaceStatement statement) => statement.copyWith(
    outer: outer,
    holes: holes,
    style: style?.apply(statement.style),
    parent: parent,
  );
}
