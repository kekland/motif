part of '../program.dart';

final class GroupStatement extends Statement with PlacedStatement {
  GroupStatement({
    super.id,
    super.enabled,
    FrameRef? parent,
  }) : parent = .of(parent);

  @override
  final ParentSelector? parent;

  FrameRef get ref => id.cell(.frame, 0);

  @override
  late final selectors = [?parent];

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield AddFrameOp(.identity(), size: null, parent: context.maybeResolve(parent));
  }

  @override
  GroupStatement copyWith({StatementId? id, bool? enabled, FrameRef? parent}) {
    return GroupStatement(
      id: id ?? this.id,
      enabled: enabled ?? this.enabled,
      parent: parent ?? this.parent?.ref,
    );
  }

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) {
    final children = context.bundle.frameChildren(context.bundle.frame(ref)!);
    return .forward(children.map((c) => c.ref(context.bundle)).toList());
  }

  @override
  ReparentRoute routeReparent(CellRef target) => .accept;

  @override
  GroupStatement reparented(FrameRef parent) => copyWith(parent: parent);
}
