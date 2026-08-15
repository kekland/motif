part of '../scene.dart';

final class SceneHistory {
  SceneHistory(this.scene);
  final Scene scene;

  final _entries = <SceneDelta>[];
  var _cursor = 0;

  bool get canUndo => _cursor > 0;
  bool get canRedo => _cursor < _entries.length;

  void commit(SceneDelta delta) {
    if (delta.isEmpty) return;
    _entries.removeRange(_cursor, _entries.length);
    _entries.add(delta);
    _cursor++;
    scene.evaluate();
  }

  void undo() {
    if (!canUndo) return;
    _cursor--;
    _entries[_cursor].unapply(scene);
    scene.evaluate();
  }

  void redo() {
    if (!canRedo) return;
    _entries[_cursor].reapply(scene);
    _cursor++;
    scene.evaluate();
  }
}
