part of 'scene.dart';

final class SceneNotifier with ChangeNotifier, ChangeNotifierDisposable {
  SceneNotifier(this.scene);
  final Scene scene;

  final _statementNotifiers = <StatementId, ChangeNotifier>{};
  final _refNotifiers = <CellRef, ChangeNotifier>{};

  ChangeNotifier forStatement(StatementId id) {
    _statementNotifiers[id] ??= ChangeNotifier();
    return _statementNotifiers[id]!;
  }

  ChangeNotifier forRef(Ref ref) => switch (ref) {
    CovertexRef() => _forRef(ref.edge),
    CellRef() => _forRef(ref),
  };

  ChangeNotifier _forRef(CellRef ref) {
    _refNotifiers[ref] ??= ChangeNotifier();
    return _refNotifiers[ref]!;
  }

  void _update(EvaluationPass pass) {
    final movedFrames = pass.movedFrames.map((r) => scene.bundle.frame(r)).nonNulls.toList();

    for (final entry in _refNotifiers.entries) {
      final ref = entry.key;
      final notifier = entry.value;

      if (pass.moved.contains(ref) || pass.deleted.contains(ref) || _isRefInFrame(ref, movedFrames)) {
        notifier.notifyListeners();
      }
    }
  }

  bool _isRefInFrame(CellRef ref, Iterable<FrameHandle> frames) {
    if (frames.isEmpty) return false;
    final h = scene.bundle.handle(ref);
    if (h == null) return false;

    return frames.any((f) => scene.bundle.isAncestorOf(h, ancestor: f));
  }
}
