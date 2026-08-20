import 'package:editor/client/client.dart';
import 'package:editor/imports.dart';

export 'widgets/editor_widget.dart';

part 'editor/transform.dart';
part 'editor/transient_edge.dart';
part 'editor/hit_test.dart';

const _syncUrl = String.fromEnvironment('SYNC_URL', defaultValue: 'ws://localhost:8085');
const _syncEnabled = bool.fromEnvironment('SYNC_ENABLED', defaultValue: false);

final class Editor extends Controller {
  Editor({Scene? scene}) : scene = scene ?? Scene(program: .new([])), super(logger: Logger('editor')) {
    logger.info('Editor initialized with sync URL: $_syncUrl (enabled: $_syncEnabled)');
    sync = _syncEnabled ? SceneSync(this.scene, uri: Uri.parse(_syncUrl)) : null;
    sync?.connect();
  }

  static Editor of(BuildContext context) => context.read<Editor>();
  static Editor watch(BuildContext context) => context.watch<Editor>();

  final Scene scene;
  late final SceneSync? sync;
  Program get program => scene.program;
  TopologyBundle get bundle => scene.bundle;
  SceneHistory get history => scene.history;
  SceneQuery get query => scene.query;
  SceneSelection get selection => scene.selection;

  Ref<H>? refOf<H extends CellHandle>(CellKey<H> cell) => scene.refOf(cell);
  Ref<H>? refOfHandle<H extends CellHandle>(H handle) => scene.refOf(bundle.key(handle) as CellKey<H>);
  CellKey<H> keyOf<H extends CellHandle>(Ref<H> ref) => scene.keyOf(ref);
  H? handleOf<H extends CellHandle>(Ref<H> ref) => scene.handleOf(ref);
  S statementOf<S extends Statement>(Ref ref) => scene.statementOf(ref);
  S statement<S extends Statement>(StatementId id) => scene.statement(id);
  Iterable<Ref> refsOf(Iterable<CellKey> keys) => scene.refsOf(keys);
  Iterable<CellKey> keysOf(Iterable<Ref> refs) => scene.keysOf(refs);
  D? styleOf<D extends CellStyle<D>>(Ref ref) => scene.styleOf(ref);

  final sceneKey = GlobalKey();
  RenderBox get renderScene => sceneKey.currentContext!.findRenderObject() as RenderBox;

  late final tool = ToolController(initialToolset: toolset);
  late final transientEdges = TransientEdges(this);

  SceneTransaction beginTransaction() => scene.beginTransaction();
  T edit<T>(T Function(SceneTransaction txn) callback, {Object? mergeKey}) {
    return scene.edit(callback, mergeKey: mergeKey);
  }
}

extension EditorContext on BuildContext {
  Editor get editor => Editor.of(this);
}
