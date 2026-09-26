import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:state/state.dart';

import 'query.dart';
export 'query.dart';

part 'transaction.dart';
part 'selection.dart';
part 'history.dart';
part 'notifier.dart';
part 'tree.dart';

part 'utils/embed_vertex.dart';
part 'utils/embed_edge.dart';
part 'utils/resolved_style.dart';
part 'utils/transform_session.dart';
part 'utils/covertices.dart';
part 'utils/ticker_provider.dart';
part 'utils/transient_transform_animator.dart';

final _log = Logger('scene');

final class Scene with ChangeNotifier, ChangeNotifierDisposable {
  new({
    required this.id,
    required this.program,
    this.assetResolver,
  }) {
    evaluation = .new(program);
    selection = .new(this);
    query = .new(this);
    history = .new(this);
    notifier = .new(this);
    tree = .new(this);
    tickerProviderKey = .new();
    transientTransformAnimator = .new(this);

    evaluation.addUpdateListener((pass) {
      selection._onEvaluated();
      signal.set(this, force: true);
      notifier._update(pass);
      notifyListeners();
    });

    program.assetResolver = assetResolver;
  }

  Scene.empty(String id) : this(id: id, program: .empty());

  final String id;
  final Program program;
  final AssetResolver? assetResolver;

  late final GlobalKey<SceneTickerProviderState> tickerProviderKey;
  late final Evaluation evaluation;
  late final SceneSelection selection;
  late final SceneQuery query;
  late final SceneHistory history;
  late final SceneNotifier notifier;
  late final SceneTree tree;
  late final TransientTransformAnimator transientTransformAnimator;

  late final signal = Signal(this);

  Bundle get bundle => evaluation.bundle;

  S? statement<S extends Statement>(StatementId id) => evaluation.statement<S>(id);
  Iterable<CellRef> productsOf(StatementId id) => evaluation.productsOf(id);

  CellRef<H> refOf<H extends CellHandle>(H handle) => bundle.ref<H>(handle);
  H? handleOf<H extends CellHandle>(CellRef<H> ref) => bundle.handle<H>(ref);

  Placement? layoutOf(StatementId id) => evaluation.layout.placementOf(id);
  CellStyle<H>? styleOf<H extends CellHandle>(CellRef<H> ref) => evaluation.style.of<H>(ref);

  // -------------------------------------------------------------------------------------------------------------------
  // Initialization
  // -------------------------------------------------------------------------------------------------------------------

  Future<void> prepare() async {
    await evaluation.prepare();
    evaluation.performInitialPass();
  }

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

  void _editTransient(void Function(EvalPass) fn) {
    if (_activeTransaction != null) {
      final pass = _activeTransaction!._pass;
      fn(pass);
      _activeTransaction!._dirty = true;
      _activeTransaction!.flush();
    } else {
      final pass = evaluation.beginPass();
      fn(pass);
      pass.drain();
    }
  }

  T edit<T>(T Function(SceneTransaction txn) fn, {Object? mergeKey}) {
    final txn = beginTransaction();
    try {
      final result = fn(txn);
      txn.commit(mergeKey: mergeKey);
      return result;
    } catch (e, st) {
      _log.severe('scene edit error', e, st);
      txn.cancel();
      rethrow;
    }
  }

  @override
  void dispose() {
    transientTransformAnimator.dispose();
    notifier.dispose();
    evaluation.dispose();
    selection.dispose();
    signal.dispose();
    tree.dispose();
    super.dispose();
  }

  Scene clone() => .new(id: id, program: program.clone());
}
