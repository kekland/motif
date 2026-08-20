part of '../scene.dart';

final class SceneHistory {
  SceneHistory(this.scene);
  final Scene scene;

  final _entries = <SceneDelta>[];
  var _cursor = 0;
  Object? _mergeKey;

  bool get canUndo => _cursor > 0;
  bool get canRedo => _cursor < _entries.length;

  final _streamController = StreamController<SceneDelta>.broadcast();
  Stream<SceneDelta> get stream => _streamController.stream;

  void commit(SceneDelta delta, {Object? mergeKey}) {
    if (delta.isEmpty) {
      scene.evaluate();
      return;
    }

    _entries.removeRange(_cursor, _entries.length);

    if (mergeKey != null && mergeKey == _mergeKey && _cursor > 0) {
      final merged = _entries[_cursor - 1].coalesce(delta);
      if (merged != null) {
        if (merged.isEmpty) {
          _entries.removeAt(_cursor - 1);
          _cursor--;
          _mergeKey = null;
        } else {
          _entries[_cursor - 1] = merged;
        }

        scene.evaluate();
        return;
      }
    }

    _entries.add(delta);
    _cursor++;
    _mergeKey = mergeKey;
    scene.evaluate();
    _streamController.add(delta);
  }

  void undo() {
    if (!canUndo) return;
    _mergeKey = null;
    final entry = _entries[_cursor--];
    entry.unapply(scene);
    scene.evaluate();
    _streamController.add(entry.invert());
  }

  void redo() {
    if (!canRedo) return;
    _mergeKey = null;
    final entry = _entries[_cursor++];
    entry.reapply(scene);
    scene.evaluate();
    _streamController.add(entry);
  }

  void clear() {
    _entries.clear();
    _cursor = 0;
    _mergeKey = null;
  }

  void dispose() {
    _streamController.close();
  }
}
