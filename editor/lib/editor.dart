import 'package:editor/client/client.dart';
import 'package:editor/imports.dart';
import 'package:editor/widgets/tabs/tab_bar.dart';

export 'widgets/editor_widget.dart';

part 'editor/transform.dart';
part 'editor/transient_edge.dart';
part 'editor/hit_test.dart';
part 'editor/transient_stroke.dart';
part 'editor/clients.dart';

final class Editor extends Controller {
  Editor({
    required this.scene,
    this.onPointerChanged,
  }) : super(logger: Logger('editor')) {
    $effect(() {
      final tab = this.tab.value;
      if (panelsRootKey.currentState == null) return;

      if (tab == null) {
        panels.collapse(.tab);
      } else {
        panels.expand(.tab);
      }
    });
  }

  static Editor of(BuildContext context) => context.read<Editor>();
  static Editor watch(BuildContext context) => context.watch<Editor>();

  final Scene scene;
  final PointerChangedCallback? onPointerChanged;
  // late final SceneSync? sync;
  Program get program => scene.program;
  Bundle get bundle => scene.bundle;
  SceneHistory get history => scene.history;
  SceneQuery get query => scene.query;
  SceneSelection get selection => scene.selection;
  Evaluation get evaluation => scene.evaluation;

  CellRef<H>? refOf<H extends CellHandle>(H cell) => scene.refOf(cell);
  H? handleOf<H extends CellHandle>(CellRef<H> ref) => scene.handleOf(ref);
  S? statement<S extends Statement>(StatementId id) => scene.statement(id);

  Iterable<CellRef> productsOf(StatementId id) => scene.productsOf(id);

  final sceneKey = GlobalKey();
  RenderBox get renderScene => sceneKey.currentContext!.findRenderObject() as RenderBox;

  final panelsRootKey = GlobalKey<PanelsState<EditorPanel>>();
  PanelsState<EditorPanel> get panels => panelsRootKey.currentState!;

  final commanderRootKey = GlobalKey<CommanderRootState>();
  CommanderRootState get commander => commanderRootKey.currentState!;

  late final tab = $signal<EditorTab?>(null);

  late final tool = ToolController(initialToolset: toolset);
  late final transientEdges = TransientEdges(this);
  late final transientStrokes = TransientStrokes(this);
  late final clients = EditorClients();

  SceneTransaction beginTransaction() => scene.beginTransaction();
  T edit<T>(T Function(SceneTransaction txn) callback, {Object? mergeKey}) {
    return scene.edit(callback, mergeKey: mergeKey);
  }
}

extension EditorContext on BuildContext {
  Editor get editor => Editor.of(this);
}
