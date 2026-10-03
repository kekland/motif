import 'package:sync/server.dart' as sync;

import '../shared_scene.dart';

Future<SharedScene> createSharedSceneImpl(sync.Server server, String sceneId) async {
  throw UnsupportedError('SharedScene is not supported on the web');
}
