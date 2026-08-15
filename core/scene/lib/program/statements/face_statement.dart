part of '../program.dart';

final class FaceStatement extends PlacedStatement {
  FaceStatement(
    List<EdgeRef> outer, {
    List<List<EdgeRef>> holes = const [],
    super.parent,
    super.id,
  }) : outer = outer.borrow(),
       holes = [for (final hole in holes) hole.borrow()];

  final List<Arg<EdgeRef>> outer;
  final List<List<Arg<EdgeRef>>> holes;

  @override
  late final _args = [...outer, for (final hole in holes) ...hole, ?parent];

  @override
  late final _products = [face];

  late final face = FaceRef(id, #face);

  @override
  void execute(EvalContext context) {
    final outer = [for (final arg in this.outer) context.resolve(arg)];
    final holes = [
      for (final hole in this.holes) [for (final arg in hole) context.resolve(arg)],
    ];

    final parent = context.resolveOptional(this.parent);
    final handle = context.transaction.makeFace(cellId('face'), outer, holes: holes, parent: parent);
    context.bind(face, handle);
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
  FaceStatement copyWith({List<EdgeRef>? outer, List<List<EdgeRef>>? holes, FrameRef? parent}) => .new(
    outer ?? this.outer.refs,
    holes: holes ?? [for (final hole in this.holes) hole.refs],
    parent: parent ?? this.parent?.ref,
    id: id,
  );
}
