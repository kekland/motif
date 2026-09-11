part of '../kernel.dart';

/// A reference to a addressable unit in the kernel:
/// - [CellRef]: for cells (frames, vertices, edges, faces)
/// - [CovertexRef]: for covertices (edge tangents)
sealed class Ref {}

// const _tagBits = 13;
const _subBits = 16;
const _kindBits = 2;

const _tagShift = _subBits + _kindBits;
const _subShift = _kindBits;

final class CellRef<H extends CellHandle> extends Ref {
  CellRef._(this.namespace, this.local) : hashCode = Mix64.hash32(namespace.hash32, local);
  CellRef.make({required U64 namespace, required int tag, int sub = 0, required CellKind kind})
    : this._(namespace, (tag << _tagShift) | (sub << _subShift) | kind.index);

  static final root = CellRef.frame(namespace: .zero, tag: 0);

  // dart format off
  static FrameRef frame({required U64 namespace, required int tag, int sub = 0}) => .make(namespace: namespace, tag: tag, sub: sub, kind: .frame);
  static VertexRef vertex({required U64 namespace, required int tag, int sub = 0}) => .make(namespace: namespace, tag: tag, sub: sub, kind: .vertex);
  static EdgeRef edge({required U64 namespace, required int tag, int sub = 0}) => .make(namespace: namespace, tag: tag, sub: sub, kind: .edge);
  static FaceRef face({required U64 namespace, required int tag, int sub = 0}) => .make(namespace: namespace, tag: tag, sub: sub, kind: .face);
  // dart format on

  final U64 namespace;
  final int local;

  @override
  final int hashCode;

  CellKind get kind => CellKind.values[local & 3];
  int get tag => local >>> _tagShift;
  int get sub => (local >>> _subShift) & 0xFFFF;

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

  CellRef copyWith({U64? namespace, int? tag, int? sub, CellKind? kind}) => .make(
    namespace: namespace ?? this.namespace,
    tag: tag ?? this.tag,
    sub: sub ?? this.sub,
    kind: kind ?? this.kind,
  );

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
