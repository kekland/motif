part of 'scene.dart';

final class SceneNotifier with ChangeNotifier, ChangeNotifierDisposable {
  SceneNotifier(this.scene);
  final Scene scene;

  final _statementSignals = <StatementId, Signal<int>>{};
  final _refSignals = <CellRef, Signal<int>>{};

  Signal forStatement(StatementId id) {
    return _statementSignals[id] ??= .new(0);
  }

  Signal _forRef(CellRef ref) {
    return _refSignals[ref] ??= .new(0);
  }

  Signal forRef(Ref ref) => switch (ref) {
    CovertexRef() => _forRef(ref.edge),
    CellRef() => _forRef(ref),
  };

  void _update(EvalPass pass) {
    final movedFrames = pass.moved.whereFrame().map((f) => scene.bundle.frame(f)).nonNulls.toList();

    for (final entry in _refSignals.entries) {
      final ref = entry.key;

      if (pass.moved.contains(ref) || pass.deleted.contains(ref) || _isRefInFrame(ref, movedFrames)) {
        final signal = entry.value;
        signal.set(signal.value + 1, force: true);
      }
    }

    for (final entry in _statementSignals.entries) {
      if (pass.evaluated.contains(entry.key)) {
        final signal = entry.value;
        signal.set(signal.value + 1, force: true);
      }
    }
  }

  bool _isRefInFrame(CellRef ref, Iterable<FrameHandle> frames) {
    if (frames.isEmpty) return false;
    final h = scene.bundle.handle(ref);
    if (h == null) return false;

    return frames.any((f) => scene.bundle.isAncestorOf(h, ancestor: f));
  }

  @override
  void dispose() {
    for (final signal in _statementSignals.values) signal.dispose();
    for (final signal in _refSignals.values) signal.dispose();
    super.dispose();
  }
}
