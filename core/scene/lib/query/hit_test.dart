import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:scene/scene.dart';
import 'package:shared/shared.dart';

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
  HitEntry? topWhere(bool Function(HitEntry e) test) => entries.firstWhereOrNull(test);
}

extension SceneHitTestQuery on SceneQuery {
  SceneHitResult _remapHitResult(Vec2 position, HitResult result, {bool onlyIfParentSelected = true}) {
    final rawEntries = result.entries;
    final entries = <HitEntry>[];

    if (onlyIfParentSelected) {
      // Entries can only be hit if their parent is selected.
      // Vertices, edges, faces can only be hit if their dependent is selected.
      for (final e in rawEntries) {
        final cell = e.ref.cell;
        final parent = bundle.query.parent(cell);
        if (parent == .root || scene.selection.frames.contains(parent)) {
          entries.add(e);
        } else {
          final dependents = bundle.cellDirectDependents(cell);
          if (dependents.any((d) => scene.selection.cells.contains(d))) {
            entries.add(e);
          }
        }
      }
    } else {
      entries.addAll(rawEntries);
    }

    // Sort hit entries by their priority
    int priority(Ref r) => switch (r) {
      CovertexRef() => 0,
      CellRef(kind: .vertex) => 1,
      CellRef(kind: .edge) => 2,
      CellRef(kind: .face) => 3,
      CellRef(kind: .frame) => 3,
    };

    entries.sort((a, b) {
      final pa = priority(a.ref), pb = priority(b.ref);
      if (pa != pb) return pa.compareTo(pb);
      return 0;
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

  SceneHitResult hitTest(Vec2 p, {double tolerance = 0.0, HitTestCovertexMode? covertexMode}) {
    final result = scene.bundle.query.hitTest(
      p,
      tolerance: tolerance,
      covertexMode: covertexMode ?? .some(scene.selection.visibleCovertices),
    );

    return _remapHitResult(p, result);
  }

  SceneHitResult hitTestRect(Aabb2 rect, {HitTestRectMode mode = .normal}) {
    final result = scene.bundle.query.hitTestRect(rect, mode: mode);
    return _remapHitResult(rect.center, result, onlyIfParentSelected: false);
  }
}
