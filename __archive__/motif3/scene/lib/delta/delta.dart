part of '../scene.dart';

sealed class SceneDelta {
  SceneDelta();

  factory SceneDelta.program(ProgramDelta delta) = ProgramSceneDelta;
  factory SceneDelta.decoration(Ref ref, CellStylePartial? before, CellStylePartial? after) = DecorationSceneDelta;
  factory SceneDelta.composite(List<SceneDelta> deltas) = CompositeSceneDelta;
  factory SceneDelta.empty() = EmptySceneDelta;
  factory SceneDelta.coalesced(Iterable<SceneDelta> deltas) => _coalesceAll(deltas);

  bool get isEmpty;

  void reapply(Scene scene);
  void unapply(Scene scene);

  SceneDelta? coalesce(SceneDelta next);
  bool commutesWith(SceneDelta other);
  SceneDelta invert();
}

final class EmptySceneDelta extends SceneDelta {
  @override
  bool get isEmpty => true;

  @override
  void reapply(Scene scene) {}

  @override
  void unapply(Scene scene) {}

  @override
  SceneDelta? coalesce(SceneDelta next) => next;

  @override
  bool commutesWith(SceneDelta other) => true;

  @override
  SceneDelta invert() => this;
}

final class ProgramSceneDelta(final ProgramDelta delta) extends SceneDelta {
  @override
  bool get isEmpty => delta.isEmpty;

  @override
  void reapply(Scene scene) => delta.reapply(scene.program);

  @override
  void unapply(Scene scene) => delta.unapply(scene.program);

  @override
  SceneDelta? coalesce(SceneDelta next) {
    if (next is! ProgramSceneDelta) return null;
    return .program(delta.coalesce(next.delta));
  }

  @override
  bool commutesWith(SceneDelta other) => switch (other) {
    DecorationSceneDelta _ => true,
    EmptySceneDelta _ => true,
    _ => false,
  };

  @override
  SceneDelta invert() => .program(delta.invert());
}

final class DecorationSceneDelta(
  final Ref ref,
  final CellStylePartial? before,
  final CellStylePartial? after,
) extends SceneDelta {
  @override
  bool get isEmpty => before == after;

  @override
  void reapply(Scene scene) => scene.styleOverrides.set(ref, after);

  @override
  void unapply(Scene scene) => scene.styleOverrides.set(ref, before);

  @override
  SceneDelta? coalesce(SceneDelta next) {
    if (next is! DecorationSceneDelta) return null;
    if (next.ref != ref) return null;
    if (before == next.after) return .empty();
    return .decoration(ref, before, next.after);
  }

  @override
  bool commutesWith(SceneDelta other) => switch (other) {
    DecorationSceneDelta d => d.ref != ref,
    ProgramSceneDelta _ => true,
    EmptySceneDelta _ => true,
    _ => false,
  };

  @override
  SceneDelta invert() => .decoration(ref, after, before);
}

final class CompositeSceneDelta(final List<SceneDelta> deltas) extends SceneDelta {
  @override
  bool get isEmpty => deltas.every((d) => d.isEmpty);

  @override
  void reapply(Scene scene) {
    for (final delta in deltas) delta.reapply(scene);
  }

  @override
  void unapply(Scene scene) {
    for (final delta in deltas.reversed) delta.unapply(scene);
  }

  @override
  SceneDelta? coalesce(SceneDelta next) {
    final merged = [...deltas];
    if (_foldInto(merged, next)) return _coalesceAll(merged);
    return null;
  }

  @override
  bool commutesWith(SceneDelta other) => deltas.every((d) => d.commutesWith(other));

  @override
  SceneDelta invert() => .composite(deltas.reversed.map((d) => d.invert()).toList());
}

SceneDelta _coalesceAll(Iterable<SceneDelta> deltas) {
  final merged = <SceneDelta>[];

  void add(SceneDelta delta) {
    if (delta.isEmpty) return;
    if (delta is CompositeSceneDelta) {
      for (final d in delta.deltas) add(d);
    } else if (!_foldInto(merged, delta)) {
      merged.add(delta);
    }
  }

  for (final delta in deltas) add(delta);
  return switch (merged.length) {
    0 => .empty(),
    1 => merged.single,
    _ => .composite(merged),
  };
}

bool _foldInto(List<SceneDelta> deltas, SceneDelta next) {
  for (var i = deltas.length - 1; i >= 0; i--) {
    final merged = deltas[i].coalesce(next);
    if (merged != null) {
      if (merged.isEmpty) {
        deltas.removeAt(i);
      } else {
        deltas[i] = merged;
      }

      return true;
    }

    if (!deltas[i].commutesWith(next)) return false;
  }

  return false;
}
