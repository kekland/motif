part of '../scene.dart';

abstract interface class SceneDelta {
  SceneDelta();

  factory SceneDelta.program(ProgramDelta delta) = ProgramSceneDelta;
  factory SceneDelta.composite(List<SceneDelta> deltas) = CompositeSceneDelta;

  bool get isEmpty;

  void reapply(Scene scene);
  void unapply(Scene scene);
}

final class ProgramSceneDelta extends SceneDelta {
  ProgramSceneDelta(this.delta);
  final ProgramDelta delta;

  @override
  bool get isEmpty => delta.isEmpty;

  @override
  void reapply(Scene scene) => delta.reapply(scene.program);

  @override
  void unapply(Scene scene) => delta.unapply(scene.program);
}

final class CompositeSceneDelta extends SceneDelta {
  CompositeSceneDelta(this.deltas);

  final List<SceneDelta> deltas;

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
}
