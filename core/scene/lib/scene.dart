import 'dart:async';

import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:state/state.dart';

import 'query.dart';
export 'query.dart';

part 'transaction.dart';
part 'selection.dart';
part 'history.dart';

part 'utils/embed_vertex.dart';
part 'utils/resolved_style.dart';
part 'utils/transform_session.dart';

final class Scene with ChangeNotifier {
  new({required this.program}) {
    evaluation = .new(program);
    selection = .new(this);
    query = .new(this);
    history = .new(this);

    evaluation.addUpdateListener((_) {
      selection._onEvaluated();
      signal.set(this, force: true);
      notifyListeners();
    });
  }

  Scene.empty() : this(program: .empty());

  final Program program;

  late final Evaluation evaluation;
  late final SceneSelection selection;
  late final SceneQuery query;
  late final SceneHistory history;

  late final signal = Signal(this);

  Bundle get bundle => evaluation.bundle;

  S? statement<S extends Statement>(StatementId id) => program.statement<S>(id);
  Iterable<CellRef> productsOf(StatementId id) => evaluation.productsOf(id);

  CellRef<H> refOf<H extends CellHandle>(H handle) => bundle.ref<H>(handle);
  H? handleOf<H extends CellHandle>(CellRef<H> ref) => bundle.handle<H>(ref);

  Placement? layoutOf(StatementId id) => evaluation.layoutOf(id);
  CellStyle<H> styleOf<H extends CellHandle>(CellRef<H> ref) => evaluation.styleOf<H>(ref);

  // -------------------------------------------------------------------------------------------------------------------
  // Transaction
  // -------------------------------------------------------------------------------------------------------------------

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
    } catch (e, st) {
      print('SCENE EDIT ERROR: $e');
      print(st);
      txn.cancel();
      rethrow;
    }
  }

  @override
  void dispose() {
    evaluation.dispose();
    selection.dispose();
    signal.dispose();
    super.dispose();
  }
}
