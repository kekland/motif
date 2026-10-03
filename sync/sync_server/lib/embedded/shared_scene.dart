import 'package:sync/server.dart' as sync;

import 'shared_scene/shared_scene_io.dart' if (dart.library.js_interop) 'shared_scene/shared_scene_web.dart';

abstract class SharedScene {
  SharedScene();

  Future<Uri?> get localUri;

  Uri uri(String host);
  Future<void> stop() async {}
}

Future<SharedScene> createSharedScene(sync.Server server, String sceneId) async {
  return createSharedSceneImpl(server, sceneId);
}
