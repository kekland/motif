import 'dart:async';

import 'package:collection/collection.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:state/initializer.dart';
import 'package:state/state.dart';

import 'query.dart';
export 'query.dart';

part 'transaction.dart';
part 'selection.dart';
part 'history.dart';
part 'notifier.dart';

part 'utils/embed_vertex.dart';
part 'utils/resolved_style.dart';
part 'utils/transform_session.dart';
part 'utils/covertices.dart';

final class Scene with ChangeNotifier {
  new({required this.program}) {
    evaluation = .new(program);
    selection = .new(this);
    query = .new(this);
    history = .new(this);
    notifier = .new(this);

    evaluation.addUpdateListener((pass) {
      selection._onEvaluated();
      signal.set(this, force: true);
      notifier._update(pass);
      notifyListeners();
    });
  }

  Scene.empty() : this(program: .empty());

  final Program program;

  late final Evaluation evaluation;
  late final SceneSelection selection;
  late final SceneQuery query;
  late final SceneHistory history;
  late final SceneNotifier notifier;

  late final signal = Signal(this);

  Bundle get bundle => evaluation.bundle;

  S? statement<S extends Statement>(StatementId id) => program.statement<S>(id);
  Iterable<CellRef> productsOf(StatementId id) => evaluation.productsOf(id);

  CellRef<H> refOf<H extends CellHandle>(H handle) => bundle.ref<H>(handle);
  H? handleOf<H extends CellHandle>(CellRef<H> ref) => bundle.handle<H>(ref);

  Placement? layoutOf(StatementId id) => evaluation.layoutOf(id);
  CellStyle<H> styleOf<H extends CellHandle>(CellRef<H> ref) => evaluation.style.of<H>(ref)!;

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
    notifier.dispose();
    evaluation.dispose();
    selection.dispose();
    signal.dispose();
    super.dispose();
  }
}
