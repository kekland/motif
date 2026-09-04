part of 'kernel.dart';

final class const Lineage<T extends CellHandle>(
  final CellKey<T> source, {
  final List<CellKey<T>> same = const [],
  final List<CellKey> raised = const [],
  final List<CellKey> reduced = const [],
}) {
  static FrameLineage frame(
    FrameKey source, {
    List<FrameKey> same = const [],
  }) => .new(source, same: same);

  static VertexLineage vertex(
    VertexKey source, {
    List<VertexKey> same = const [],
    List<CellKey> raised = const [],
  }) => .new(source, same: same, raised: raised);

  static EdgeLineage edge(
    EdgeKey source, {
    List<EdgeKey> same = const [],
    List<CellKey> reduced = const [],
    List<CellKey> raised = const [],
  }) => .new(source, same: same, reduced: reduced, raised: raised);

  static FaceLineage face(
    FaceKey source, {
    List<FaceKey> same = const [],
    List<CellKey> reduced = const [],
  }) => .new(source, same: same, reduced: reduced);

  Iterable<CellKey> get products sync* {
    yield* same;
    yield* raised;
    yield* reduced;
  }
}

typedef FrameLineage = Lineage<FrameHandle>;
typedef VertexLineage = Lineage<VertexHandle>;
typedef EdgeLineage = Lineage<EdgeHandle>;
typedef FaceLineage = Lineage<FaceHandle>;
