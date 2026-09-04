part of '../kernel.dart';

final class const Lineage<T extends CellHandle>(
  final CellRef<T> source, {
  final List<CellRef<T>> same = const [],
  final List<CellRef> raised = const [],
  final List<CellRef> reduced = const [],
}) {
  static FrameLineage frame(
    FrameRef source, {
    List<FrameRef> same = const [],
  }) => .new(source, same: same);

  static VertexLineage vertex(
    VertexRef source, {
    List<VertexRef> same = const [],
    List<CellRef> raised = const [],
  }) => .new(source, same: same, raised: raised);

  static EdgeLineage edge(
    EdgeRef source, {
    List<EdgeRef> same = const [],
    List<CellRef> reduced = const [],
    List<CellRef> raised = const [],
  }) => .new(source, same: same, reduced: reduced, raised: raised);

  static FaceLineage face(
    FaceRef source, {
    List<FaceRef> same = const [],
    List<CellRef> reduced = const [],
  }) => .new(source, same: same, reduced: reduced);

  Iterable<CellRef> get products sync* {
    yield* same;
    yield* raised;
    yield* reduced;
  }
}

typedef FrameLineage = Lineage<FrameHandle>;
typedef VertexLineage = Lineage<VertexHandle>;
typedef EdgeLineage = Lineage<EdgeHandle>;
typedef FaceLineage = Lineage<FaceHandle>;
