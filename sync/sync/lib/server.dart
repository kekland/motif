import 'package:sync/server.dart';
import 'package:sync/schema.dart' as pb;

export 'server/connection.dart';
export 'server/scene.dart';
export 'server/storage.dart';

class Server {
  Server(this.indexStorage);

  final IndexStorage indexStorage;

  final _scenes = <String, Future<ServerScene?>>{};
  final _closingScenes = <String, Future<void>>{};

  Future<List<pb.SceneInfo>> listScenes() async {
    return await indexStorage.listScenes();
  }

  Future<(pb.SceneInfo, pb.Program)> createScene({pb.Program? program, String? title, String? path}) async {
    final _title = title ?? 'Untitled';

    final _program = program ?? .create();
    _program.settings.title = _title;

    final info = await indexStorage.create(_program, path: path);
    return (info, _program);
  }

  Future<ServerScene?> openScene(String id) async {
    await _closingScenes[id];
    return _scenes[id] ??= _openScene(id);
  }

  Future<void> close() async {
    for (final scene in await Future.wait(_scenes.values)) await scene?.close();
    _scenes.clear();
    _closingScenes.clear();
    await indexStorage.close();
  }

  Future<ServerScene?> _openScene(String id) async {
    final storage = await indexStorage.open(id);
    if (storage == null) {
      _scenes.remove(id);
      return null;
    }

    return .new(
      info: await storage.loadInfo(),
      indexStorage: indexStorage,
      storage: storage,
      program: await storage.loadProgram(),
      onEmpty: () => _closeScene(id),
    );
  }

  Future<void> _closeScene(String id) async {
    final scene = await _scenes[id];
    if (scene == null || !scene.canBeClosed) return;

    _scenes.remove(id);
    await (_closingScenes[id] = scene.close());
    _closingScenes.remove(id);
  }
}
