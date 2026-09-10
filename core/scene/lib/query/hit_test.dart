import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:scene/scene.dart';

extension SceneHitEntryExt<R extends Ref> on HitEntry<R> {
  StatementId get statementId => ref.statementId;
}

final class SceneHitResult {
  SceneHitResult({
    required this.position,
    required this.entries,
    required this.statements,
  });

  final Vec2 position;
  final List<HitEntry> entries;
  final List<StatementId> statements;

  Iterable<FrameHitEntry> get frames => entries.whereType<FrameHitEntry>();
  Iterable<FaceHitEntry> get faces => entries.whereType<FaceHitEntry>();
  Iterable<EdgeHitEntry> get edges => entries.whereType<EdgeHitEntry>();
  Iterable<VertexHitEntry> get vertices => entries.whereType<VertexHitEntry>();
  Iterable<CovertexHitEntry> get coverties => entries.whereType<CovertexHitEntry>();

  Iterable<Ref> get refs => entries.map((e) => e.ref);

  bool get isEmpty => entries.isEmpty;
  bool get isNotEmpty => entries.isNotEmpty;

  HitEntry? get top => isNotEmpty ? entries.first : null;
}

extension SceneHitTestQuery on SceneQuery {
  SceneHitResult _remapHitResult(Vec2 position, HitResult result) {
    final entries = result.entries;

    int priority(Ref r) => switch (r) {
      CovertexRef() => 0,
      CellRef(kind: .vertex) => 1,
      CellRef(kind: .edge) => 2,
      CellRef(kind: .face) => 3,
      CellRef(kind: .frame) => 4,
    };

    final evaluation = scene.evaluation;
    entries.sort((a, b) {
      final pa = priority(a.ref), pb = priority(b.ref);
      if (pa != pb) return pa.compareTo(pb);
      return evaluation.drawOrder.indexOf(b.ref.cell).compareTo(evaluation.drawOrder.indexOf(a.ref.cell));
    });

    final statements = <StatementId>[];
    for (final entry in entries) {
      final id = entry.statementId;
      if (statements.contains(id)) continue;
      statements.add(id);
    }

    return SceneHitResult(
      position: position,
      entries: entries,
      statements: statements,
    );
  }

  SceneHitResult hitTest(Vec2 p, {double tolerance = 0.0}) {
    final result = scene.bundle.query.hitTest(
      p,
      tolerance: tolerance,
      includeCovertices: scene.selection.visibleCovertices,
    );

    return _remapHitResult(p, result);
  }

  SceneHitResult hitTestRect(Aabb2 rect, {HitTestRectMode mode = .normal}) {
    final result = scene.bundle.query.hitTestRect(rect, mode: mode);
    return _remapHitResult(rect.center, result);
  }
}
