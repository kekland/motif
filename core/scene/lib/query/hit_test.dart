import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:scene/scene.dart';

sealed class SceneHitEntry<H extends CellHandle> {
  const SceneHitEntry({
    required this.ref,
    required this.handle,
    required this.distance,
  });

  final CellRef<H> ref;
  final H handle;
  final double distance;

  CellKind get kind => ref.kind;
  StatementId get statementId => ref.statementId;
}

final class FrameSceneHitEntry extends SceneHitEntry<FrameHandle> {
  const FrameSceneHitEntry({
    required super.ref,
    required super.handle,
    required super.distance,
    required this.point,
  });

  final Vec2 point;
}

final class VertexSceneHitEntry extends SceneHitEntry<VertexHandle> {
  const VertexSceneHitEntry({
    required super.ref,
    required super.handle,
    required super.distance,
  });
}

final class EdgeSceneHitEntry extends SceneHitEntry<EdgeHandle> {
  const EdgeSceneHitEntry({
    required super.ref,
    required super.handle,
    required super.distance,
    required this.t,
  });

  final double t;
}

final class FaceSceneHitEntry extends SceneHitEntry<FaceHandle> {
  const FaceSceneHitEntry({
    required super.ref,
    required super.handle,
    required super.distance,
    required this.point,
  });

  final Vec2 point;
}

final class SceneHitResult {
  SceneHitResult({
    required this.position,
    required this.entries,
    required this.statements,
  });

  final Vec2 position;
  final List<SceneHitEntry> entries;
  final List<StatementId> statements;

  Iterable<FrameSceneHitEntry> get frames => entries.whereType<FrameSceneHitEntry>();
  Iterable<FaceSceneHitEntry> get faces => entries.whereType<FaceSceneHitEntry>();
  Iterable<EdgeSceneHitEntry> get edges => entries.whereType<EdgeSceneHitEntry>();
  Iterable<VertexSceneHitEntry> get vertices => entries.whereType<VertexSceneHitEntry>();

  Iterable<CellRef> get refs => entries.map((e) => e.ref);

  bool get isEmpty => entries.isEmpty;
  bool get isNotEmpty => entries.isNotEmpty;

  SceneHitEntry? get top => isNotEmpty ? entries.first : null;
}

extension SceneHitTestQuery on SceneQuery {
  SceneHitResult _remapHitResult(Vec2 position, HitResult result) {
    final entries = <SceneHitEntry>[];
    final statements = <StatementId>[];

    for (final entry in result.entries) {
      final handle = entry.handle;
      final ref = scene.refOf(handle);

      final SceneHitEntry sceneEntry = switch (entry) {
        FrameHitEntry f => FrameSceneHitEntry(
          handle: handle.asFrame,
          ref: ref.asFrame,
          distance: f.distance,
          point: f.point,
        ),
        VertexHitEntry v => VertexSceneHitEntry(
          handle: handle.asVertex,
          ref: ref.asVertex,
          distance: v.distance,
        ),
        EdgeHitEntry e => EdgeSceneHitEntry(
          handle: handle.asEdge,
          ref: ref.asEdge,
          distance: e.distance,
          t: e.t,
        ),
        FaceHitEntry f => FaceSceneHitEntry(
          handle: handle.asFace,
          ref: ref.asFace,
          distance: f.distance,
          point: f.point,
        ),
      };

      entries.add(sceneEntry);

      final statementId = sceneEntry.statementId;
      if (!statements.contains(statementId)) {
        statements.add(statementId);
      }
    }

    return SceneHitResult(
      position: position,
      entries: entries,
      statements: statements,
    );
  }

  SceneHitResult hitTest(Vec2 p, {double tolerance = 0.0}) {
    final result = scene.bundle.query.hitTest(p, tolerance: tolerance);
    return _remapHitResult(p, result);
  }

  SceneHitResult hitTestRect(Aabb2 rect, {HitTestRectMode mode = .normal}) {
    final result = scene.bundle.query.hitTestRect(rect, mode: mode);
    return _remapHitResult(rect.center, result);
  }
}
