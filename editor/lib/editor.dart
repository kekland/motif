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
    // logger.info('Editor initialized with sync URL: $_syncUrl (enabled: $_syncEnabled)');
    // sync = _syncEnabled ? SceneSync(this.scene, uri: Uri.parse(_syncUrl)) : null;
    // sync?.connect();
  }

  static Editor of(BuildContext context) => context.read<Editor>();
  static Editor watch(BuildContext context) => context.watch<Editor>();

  final Scene scene;
  // late final SceneSync? sync;
  Program get program => scene.program;
  Bundle get bundle => scene.bundle;
  SceneHistory get history => scene.history;
  SceneQuery get query => scene.query;
  SceneSelection get selection => scene.selection;

  CellRef<H>? refOf<H extends CellHandle>(H cell) => scene.refOf(cell);
  H? handleOf<H extends CellHandle>(CellRef<H> ref) => scene.handleOf(ref);
  S? statement<S extends Statement>(StatementId id) => scene.statement(id);

  Iterable<CellRef> productsOf(StatementId id) => scene.productsOf(id);

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
