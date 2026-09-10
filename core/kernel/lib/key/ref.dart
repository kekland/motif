part of '../kernel.dart';

/// A reference to a addressable unit in the kernel:
/// - [CellRef]: for cells (frames, vertices, edges, faces)
/// - [CovertexRef]: for covertices (edge tangents)
sealed class Ref {}

final class CellRef<H extends CellHandle> extends Ref {
  CellRef._(this.namespace, this.local) : hashCode = Mix.mix(namespace, local);
  CellRef.make({required int namespace, required int tag, int sub = 0, required CellKind kind})
    : this._(namespace, (tag << 16 | sub) << 2 | kind.index);

  static final root = CellRef.frame(namespace: 0, tag: 0);

  // dart format off
  static FrameRef frame({required int namespace, required int tag, int sub = 0}) => .make(namespace: namespace, tag: tag, sub: sub, kind: .frame);
  static VertexRef vertex({required int namespace, required int tag, int sub = 0}) => .make(namespace: namespace, tag: tag, sub: sub, kind: .vertex);
  static EdgeRef edge({required int namespace, required int tag, int sub = 0}) => .make(namespace: namespace, tag: tag, sub: sub, kind: .edge);
  static FaceRef face({required int namespace, required int tag, int sub = 0}) => .make(namespace: namespace, tag: tag, sub: sub, kind: .face);
  // dart format on

  final int namespace;
  final int local;

  @override
  final int hashCode;

  CellKind get kind => CellKind.values[local & 3];
  int get tag => local >>> 18;
  int get sub => (local >>> 2) & 0xFFFF;

  FrameRef get asFrame {
    assert(kind == .frame);
    return this as FrameRef;
  }

  VertexRef get asVertex {
    assert(kind == .vertex);
    return this as VertexRef;
  }

  EdgeRef get asEdge {
    assert(kind == .edge);
    return this as EdgeRef;
  }

  FaceRef get asFace {
    assert(kind == .face);
    return this as FaceRef;
  }

  CellRef copyWith({int? namespace, int? tag, int? sub, CellKind? kind}) => .make(
    namespace: namespace ?? this.namespace,
    tag: tag ?? this.tag,
    sub: sub ?? this.sub,
    kind: kind ?? this.kind,
  );

  /// Equal across type arguments: a `CellRef<FrameHandle>` and a `CellRef<CellHandle>` naming the same cell are the same key.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CellRef && other.namespace == namespace && other.local == local;
}

typedef FrameRef = CellRef<FrameHandle>;
typedef VertexRef = CellRef<VertexHandle>;
typedef EdgeRef = CellRef<EdgeHandle>;
typedef FaceRef = CellRef<FaceHandle>;

extension RefIterableExt on Iterable<Ref> {
  Iterable<CellRef> get cells => whereType<CellRef>();
  Iterable<CovertexRef> get covertices => whereType<CovertexRef>();
}
