import 'dart:io';
import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';
import 'package:server/imports.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

Future<void> main() async {
  hierarchicalLoggingEnabled = true;
  logger.onRecord.listen(logColorizedStdout);
  logger.level = switch (env.mode) {
    .development => .FINEST,
    .production => .INFO,
  };

  final storage = SceneStorage('scenes.db');
  final rooms = Rooms(storage);

  final router = Router()
    ..post('/scenes/create', (Request request) async {
      final body = CreateSceneRequest.fromBuffer(await _read(request));
      final room = await rooms.create(body.program);
      return _proto(CreateSceneResponse(id: room.id, program: body.program));
    })
    ..post('/scenes/get', (Request request) async {
      final body = GetSceneRequest.fromBuffer(await _read(request));
      final room = await rooms.load(body.id);
      if (room == null) return Response.notFound(null);
      return _proto(GetSceneResponse(program: room.program));
    })
    ..get('/scenes/<id>/ws', (Request request, String id) {
      final clientId = request.url.queryParameters['client'];
      if (clientId == null || !Uuid.isValidUUID(fromString: clientId)) {
        return Response.badRequest(body: 'client id required');
      }

      return webSocketHandler((WebSocketChannel channel, _) async {
        final room = await rooms.join(id, channel, Client(id: clientId));
        if (room == null) await channel.sink.close(4404, 'scene not found');
      })(request);
    });

  final handler = const Pipeline().addMiddleware(logRequests()).addMiddleware(_cors).addHandler(router.call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, env.port);
  logger.info('listening on :${server.port}');

  await ProcessSignal.sigint.watch().first;
  logger.info('shutting down');
  await server.close(force: true);
  await rooms.close();
  storage.dispose();
  exit(0);
}

Future<Uint8List> _read(Request request) async {
  final builder = BytesBuilder(copy: false);
  await for (final chunk in request.read()) {
    builder.add(chunk);
  }
  return builder.takeBytes();
}

Response _proto(GeneratedMessage message) => Response.ok(
  message.writeToBuffer(),
  headers: {'content-type': 'application/x-protobuf'},
);

Handler _cors(Handler inner) => (request) async {
  const headers = {
    'access-control-allow-origin': '*',
    'access-control-allow-methods': 'GET, POST, OPTIONS',
    'access-control-allow-headers': 'content-type',
  };
  if (request.method == 'OPTIONS') return Response.ok(null, headers: headers);
  return (await inner(request)).change(headers: headers);
};
