import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:listen/listen.dart';
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

part 'selection/selection.dart';

final class Scene with ChangeNotifier {
  Scene({required this.program}) {
    history = .new(this);
    query = .new(this);
    selection = .new(this);
    evaluate();
  }

  factory Scene.decode({required pb.Scene scene}) => SceneCodec.decodeScene(scene);

  final Program program;

  late final SceneHistory history;
  late final SceneQuery query;
  late final SceneSelection selection;

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

  Ref<H>? refOf<H extends CellHandle>(CellKey<H> cell) => table.refOf(cell);
  CellKey<H> keyOf<H extends CellHandle>(Ref<H> ref) => table.keyOf(ref) as CellKey<H>;
  H handleOf<H extends CellHandle>(Ref<H> ref) => bundle.handle(table.keyOf(ref)!) as H;
  S statementOf<S extends Statement>(Ref ref) => program.byId(ref.statement) as S;
  S statement<S extends Statement>(StatementId id) => program.byId(id) as S;

  Iterable<CellKey> keysOf(Iterable<Ref> refs) sync* {
    for (final r in refs) yield keyOf(r);
  }

  Iterable<Ref> refsOf(Iterable<CellKey> keys) sync* {
    for (final k in keys) yield refOf(k)!;
  }

  void evaluate() {
    final eval = dryExecute(program);
    _evaluation = eval;
    notifyListeners();
  }

  TransformRouter resolveTransformRouter(Iterable<Ref> products) {
    assert(_evaluation != null, 'scene has not been evaluated yet.');
    return program.resolveTransformRouter(_evaluation!, products);
  }

  var _editing = false;
  T edit<T>(T Function(SceneTransaction txn) fn) {
    if (_editing) throw StateError('cannot edit scene while already editing');
    _editing = true;

    final txn = SceneTransaction._(this);
    try {
      final result = fn(txn);
      history.commit(txn._build());
      return result;
    } catch (_) {
      txn._rollback();
      rethrow;
    } finally {
      _editing = false;
    }
  }

  @override
  void dispose() {
    selection.dispose();
    super.dispose();
  }
}
