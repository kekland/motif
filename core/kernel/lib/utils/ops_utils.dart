part of '../kernel.dart';

extension type const CellPlacement._(FrameRef? parent) {
  CellPlacement.ref(FrameRef? parent) : this._(parent);
  CellPlacement.of(Bundle bundle, CellHandle h) : this._(bundle.parentOf(h)?.ref(bundle));

  static CellPlacement from(Bundle bundle, FrameHandle? parent) {
    final parentId = parent?.ref(bundle);
    return CellPlacement._(parentId);
  }

  static const append = CellPlacement._((null));

  FrameHandle? resolveParent(Transaction txn) {
    if (parent == null) return null;
    final handle = txn.bundle.frame(parent!);
    if (handle == null) throw StateError('referenced unknown frame $parent');
    return handle;
  }
}

extension OpsUtils on Transaction {
  CellHandle cellFor(CellRef ref) => _resolve(bundle.handle(ref), ref, bundle.isCellLive);
  FrameHandle frameFor(FrameRef ref) => _resolve(bundle.frame(ref), ref, bundle.isFrameLive);
  VertexHandle vertexFor(VertexRef ref) => _resolve(bundle.vertex(ref), ref, bundle.isVertexLive);
  EdgeHandle edgeFor(EdgeRef ref) => _resolve(bundle.edge(ref), ref, bundle.isEdgeLive);
  FaceHandle faceFor(FaceRef ref) => _resolve(bundle.face(ref), ref, bundle.isFaceLive);

  H _resolve<H extends CellHandle>(H? h, CellRef ref, bool Function(H) alive) {
    if (h == null || (_mode == .topology && !alive(h))) throw StateError('referenced unknown cell $ref');
    return h;
  }

  Covertex covertexFor(CovertexRef ref) => ref.resolve(bundle) ?? (throw StateError('referenced unknown vertex $ref'));
  Coedge coedgeFor(CoedgeRef ref) => ref.resolve(bundle) ?? (throw StateError('referenced unknown edge in $ref'));
  Cycle cycleFor(CycleRef ref) => ref.resolve(bundle) ?? (throw StateError('referenced unknown edge in $ref'));

  void markAdded(CellHandle h) => delta.markAdded(h.ref(bundle));
  void markDeleted(CellHandle h) => delta.markDeleted(h.ref(bundle));

  void markMoved(CellHandle h) => bundle._changeTracker.add(bundle, bundle._arenaOf(h.kind), h);
  void markFrameMoved(FrameHandle f) => bundle._changeTracker.add(bundle, bundle._frame, f);
  void markVertexMoved(VertexHandle v) => bundle._changeTracker.add(bundle, bundle._vertex, v);
  void markEdgeMoved(EdgeHandle e) => bundle._changeTracker.add(bundle, bundle._edge, e);
  void markFaceMoved(FaceHandle f) => bundle._changeTracker.add(bundle, bundle._face, f);

  // void markEdgeEndpointsMoved(EdgeHandle e) {
  //   delta.markMoved(bundle.edgeStart(e).ref(bundle));
  //   delta.markMoved(bundle.edgeEnd(e).ref(bundle));
  // }

  // void markCycleMoved(CycleRef c) {
  //   for (final c in c.coedges) delta.markMoved(.edge(c.edge));
  // }

  // CompositeOp<P, C> composite<P, C>(Composite<P, C> definition, P params) {
  //   final mark = ops.length;
  //   final cells = definition.topology(this, params);

  //   final topology = ops.sublist(mark).cast<TopologyOp>();
  //   definition.geometry(this, params, cells);

  //   final geometry = ops.sublist(mark + topology.length).cast<GeometryOp>();
  //   final op = CompositeOp(definition, params, cells, topology, geometry);
  //   ops.replaceRange(mark, ops.length, [op]);

  //   return op;
  // }

  // CompositeOp<P, C>? reshape<P, C>(CompositeOp<P, C> op, P params) {
  //   if (!op.definition.topologyEquals(op.params, params)) return null;
  //   final mark = ops.length;
  //   op.definition.geometry(this, params, op.cells);
  //   return op.withGeometry(ops.sublist(mark).cast<GeometryOp>());
  // }
}

// final class CellIdFactory {
//   new(this.namespace);
//   final int namespace;

//   var _tag = 0;
//   CellId next() => .make(namespace: namespace, tag: _tag++);
// }
