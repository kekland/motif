import 'package:kernel/kernel.dart';
import 'package:program/program.dart';

part 'transaction.dart';

final class Scene {
  new({required this.program}) {
    _evaluation = .new(program);
  }

  Scene.empty() : this(program: .empty());

  final Program program;
  late final Evaluation _evaluation;

  Evaluation get evaluation => _evaluation;

  Bundle get bundle => _evaluation.bundle;
  // Map<StatementId, Object> get failures => _evaluation.failures;

  SceneTransaction? _activeTransaction;

  SceneTransaction beginTransaction() {
    if (_activeTransaction != null) throw StateError('transaction is already active');
    _activeTransaction = ._(this);
    return _activeTransaction!;
  }

  void _endTransaction(SceneTransaction txn) {
    assert(identical(txn, _activeTransaction), 'transaction mismatch');
    _activeTransaction = null;
  }

  T edit<T>(T Function(SceneTransaction txn) fn, {Object? mergeKey}) {
    final txn = beginTransaction();
    try {
      final result = fn(txn);
      txn.commit(mergeKey: mergeKey);
      return result;
    } catch (e) {
      print('SCENE EDIT ERROR: $e');
      txn.cancel();
      rethrow;
    }
  }

  void dispose() {
    _evaluation.dispose();
  }
}
