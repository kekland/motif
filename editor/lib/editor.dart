import 'package:editor/imports.dart';
import 'package:editor/widgets/tabs/tab_bar.dart';
import 'package:flutter/services.dart';

export 'widgets/editor_widget.dart';
export 'editor_sync.dart';

part 'editor/clients.dart';
part 'editor/globals.dart';
part 'editor/hit_test.dart';
part 'editor/transform.dart';
part 'editor/transient_edge.dart';
part 'editor/transient_stroke.dart';

final _logger = Logger('editor');

final class Editor extends Controller {
  Editor({
    required this.sync,
    required this.scene,
  }) : super(logger: _logger) {
    $effect(() {
      final tab = this.tab.value;
      if (panelsRootKey.currentState == null) return;

      if (tab == null) {
        panels.collapse(.tab);
      } else {
        panels.expand(.tab);
      }
    });

    scene.prepare().then((_) => isLoaded.value = true);
  }

  static Editor of(BuildContext context) => context.read<Editor>();
  static Editor watch(BuildContext context) => context.watch<Editor>();

  EditorBuiltinFonts get builtinFonts => EditorBuiltinFonts.instance;

  final EditorSync sync;
  final Scene scene;

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

  late final canvasFocusScopeNode = $customDisposable(FocusScopeNode(), (n) => n.dispose());
  bool get areCanvasActionsEnabled => canvasFocusScopeNode.hasPrimaryFocus || commander.isVisible.value;

  final sceneKey = GlobalKey();
  RenderBox get renderScene => sceneKey.currentContext!.findRenderObject() as RenderBox;

  final panelsRootKey = GlobalKey<PanelsState<EditorPanel>>();
  PanelsState<EditorPanel> get panels => panelsRootKey.currentState!;

  final commanderRootKey = GlobalKey<CommanderRootState>();
  CommanderRootState get commander => commanderRootKey.currentState!;

  late final tab = $signal<EditorTab?>(null);
  late final isLoaded = $signal<bool>(false);

  late final tool = $disposable(ToolController(initialToolset: toolset));
  late final transientEdges = $disposable(TransientEdges(this));
  late final transientStrokes = $disposable(TransientStrokes(this));

  void invoke(Intent intent) {
    Actions.invoke(sceneKey.currentState!.context, intent);
  }

  SceneTransaction beginTransaction() => scene.beginTransaction();
  T edit<T>(T Function(SceneTransaction txn) callback, {Object? mergeKey}) {
    return scene.edit(callback, mergeKey: mergeKey);
  }

  // Move this somewhere else, but it's ok for now
  StatementId? cursorTextEditStatement;

  Future<ImageId> uploadImageAsset(Uint8List data, {required String mimeType}) async {
    final hash = Hash.compute(data);
    final id = ImageId(hash: hash);

    await uploadAsset(id, data, (cache) {
      final image = cache.image[id]!;
      return ImageAsset(
        hash: hash,
        size: data.lengthInBytes,
        width: image.width,
        height: image.height,
        mimeType: mimeType,
      );
    });

    return id;
  }

  Future<AssetId> uploadAsset(
    AssetId id,
    Uint8List data,
    Asset Function(SceneAssetCache cache) createAsset,
  ) async {
    await scene.assetCache.add(id, data);
    final asset = createAsset(scene.assetCache);
    program.assetManifest.insertUnsynced(asset);

    sync.saveAsset(data).then((hash) {
      scene.editTransient((txn) => txn.addAsset(asset));
    });
    return asset.id;
  }

  void maybeAddAsset(Asset asset) {
    if (program.assetManifest.contains(asset.id)) return;
    scene.edit((txn) => txn.addAsset(asset));
  }

  @override
  void dispose() {
    scene.dispose();
    super.dispose();
  }
}

extension EditorContext on BuildContext {
  Editor get editor => Editor.of(this);
}
