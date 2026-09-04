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

  DissolveIntent routeDissolve(Set<Ref> targeted) => .new(lose: targeted);

  DissolveRemains routeDissolveRemains(RemainsContext context, Set<Ref> lostProducts) {
    final statements = <Statement>[];
    final refMap = <Ref, Ref>{};
    Ref<H> localResolve<H extends CellHandle>(Ref<H> ref) => (refMap[ref] ?? context.resolve(ref)) as Ref<H>;
    Ref<H>? maybeLocalResolve<H extends CellHandle>(Ref<H>? ref) => ref == null ? null : localResolve(ref);

    final bakedByKey = <CellKey, Ref>{};

    final liveProducts = _products.where((p) => !lostProducts.contains(p));
    final liveFrames = liveProducts.where((r) => r.kind == .frame).cast<FrameRef>();
    final liveVertices = liveProducts.where((r) => r.kind == .vertex).cast<VertexRef>();
    final liveEdges = liveProducts.where((r) => r.kind == .edge).cast<EdgeRef>();

    for (final frame in liveFrames) {
      final handle = context.cell(frame)?.asFrame;
      if (handle == null) continue;

      final key = context.bundle.key(handle);
      final existing = bakedByKey[key];
      if (existing != null) {
        refMap[frame] = existing;
        continue;
      }

      final (space, parent) = context.survivingSpace(handle);
      final baked = FrameStatement(
        transform: context.bundle.frameTransform(handle, space: space),
        parent: maybeLocalResolve(parent),
      );
      statements.add(baked);
      refMap[frame] = baked.frame;
      bakedByKey[key] = baked.frame;
    }

    for (final vertex in liveVertices) {
      final handle = context.cell(vertex)?.asVertex;
      if (handle == null) continue;
      final key = context.bundle.key(handle);

      final existing = bakedByKey[key];
      if (existing != null) {
        refMap[vertex] = existing;
        continue;
      }

      final (space, parent) = context.survivingSpace(handle);
      final baked = VertexStatement(
        context.bundle.vertexPosition(handle, space: space),
        parent: maybeLocalResolve(parent),
      );
      statements.add(baked);
      refMap[vertex] = baked.vertex;
      bakedByKey[key] = baked.vertex;
    }

    for (final edge in liveEdges) {
      final handle = context.cell(edge)?.asEdge;
      if (handle == null) continue;
      final key = context.bundle.key(handle);
      final existing = bakedByKey[key];
      if (existing != null) {
        refMap[edge] = existing;
        continue;
      }

      final (space, parent) = context.survivingSpace(handle);

      final start = localResolve(context.ref(context.bundle.edgeStart(handle))!).cast<VertexHandle>();
      final end = localResolve(context.ref(context.bundle.edgeEnd(handle))!).cast<VertexHandle>();

      final cubic = context.bundle.edgeCubic(handle, space: space);
      final baked = EdgeStatement(
        start,
        end,
        startTangent: cubic.p1 - cubic.p0,
        endTangent: cubic.p2 - cubic.p3,
        style: context.style(edge) ?? .default_,
        parent: maybeLocalResolve(parent),
      );

      statements.add(baked);
      refMap[edge] = baked.edge;
      bakedByKey[key] = baked.edge;
    }

    return .new(statements, refMap);
  }

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
