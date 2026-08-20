import 'dart:async';
import 'dart:typed_data';

import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:listen/listen.dart';
import 'package:signals/signals.dart';
import 'package:schema/scene.dart' as pb;

import 'program/program.dart';
import 'query/query.dart';

import 'serializer/serializer.dart';
export 'serializer/serializer.dart';

export 'program/program.dart';
export 'query/query.dart';

part 'delta/delta.dart';
part 'delta/history.dart';
part 'delta/transaction.dart';
part 'utils/embed_vertex.dart';
part 'utils/transform_session.dart';
part 'utils/resolved_style.dart';
part 'slice/slice.dart';

part 'selection/selection.dart';

final class Scene with ChangeNotifier {
  Scene({
    required this.program,
    StyleOverrides? styleOverrides,
  }) {
    history = .new(this);
    query = .new(this);
    selection = .new(this);
    this.styleOverrides = styleOverrides ?? .empty();
    evaluate();
  }

  factory Scene.decode({required pb.Scene scene}) => SceneCodec.decodeScene(scene);

  final Program program;
  late final StyleOverrides styleOverrides;

  late final SceneHistory history;
  late final SceneQuery query;
  late final SceneSelection selection;

  late final signal = Signal(this);

  Evaluation? _evaluation;

  TopologyBundle get bundle {
    assert(_evaluation != null, 'scene has not been evaluated yet.');
    return _evaluation!.bundle;
  }

  ExportTable get table {
    assert(_evaluation != null, 'scene has not been evaluated yet.');
    return _evaluation!.table;
  }

  LayoutOverrides get layout {
    assert(_evaluation != null, 'scene has not been evaluated yet.');
    return _evaluation!.layout!;
  }

  StyleTable get style {
    assert(_evaluation != null, 'scene has not been evaluated yet.');
    return _evaluation!.style;
  }

  Ref<H>? refOf<H extends CellHandle>(CellKey<H> cell) => table.refOf(cell);
  CellKey<H> keyOf<H extends CellHandle>(Ref<H> ref) => table.keyOf(ref) as CellKey<H>;
  H? handleOf<H extends CellHandle>(Ref<H> ref) => bundle.handle(table.keyOf(ref)!) as H?;
  S statementOf<S extends Statement>(Ref ref) => program.byId(ref.statement) as S;
  S statement<S extends Statement>(StatementId id) => program.byId(id) as S;
  D? styleOf<D extends CellStyle<D>>(Ref ref) => _evaluation!.style.of<D>(ref);

  Iterable<CellKey> keysOf(Iterable<Ref> refs) sync* {
    for (final r in refs) yield keyOf(r);
  }

  Iterable<Ref> refsOf(Iterable<CellKey> keys) sync* {
    for (final k in keys) yield refOf(k)!;
  }

  void evaluate() {
    final eval = dryExecute(program, styleOverrides: styleOverrides);
    _evaluation = eval;
    selection._onEvaluated();
    signal.set(this, force: true);
    notifyListeners();
  }

  TransformRouter resolveTransformRouter(Iterable<Ref> products) {
    assert(_evaluation != null, 'scene has not been evaluated yet.');
    return program.resolveTransformRouter(_evaluation!, products);
  }

  SceneTransaction? _activeTransaction;

  SceneTransaction beginTransaction() {
    if (_activeTransaction != null) throw StateError('transaction is already active');
    _activeTransaction = ._(this);
    return _activeTransaction!;
  }

  T edit<T>(T Function(SceneTransaction txn) fn, {Object? mergeKey}) {
    final txn = beginTransaction();
    try {
      final result = fn(txn);
      txn.commit(mergeKey: mergeKey);
      return result;
    } catch (e) {
      txn.cancel();
      rethrow;
    }
  }

  void _endTransaction(SceneTransaction txn) {
    assert(identical(txn, _activeTransaction), 'transaction mismatch');
    _activeTransaction = null;
  }

  @override
  void dispose() {
    history.dispose();
    signal.dispose();
    selection.dispose();
    super.dispose();
  }

  void applyRemote(SceneDelta delta) {
    delta.reapply(this);
    evaluate();
  }

  void load(Program program) {
    this.program.replaceAll(program.statements);
    history.clear();
    selection.clear();
    evaluate();
  }

  SceneSlice slice(Iterable<StatementId> selection) => .from(this, selection);
}
