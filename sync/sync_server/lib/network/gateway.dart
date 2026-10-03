import 'dart:io';
import 'dart:typed_data';

import 'package:asset/asset.dart';
import 'package:protobuf/protobuf.dart' as protobuf;
import 'package:shared/shared.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'package:sync/schema.dart' as pb;
import 'package:sync/sync.dart' as sync;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:web_socket_channel/web_socket_channel.dart';

typedef Admit = bool Function(String? sceneId, String? token);

final class ServerHttpGateway {
  ServerHttpGateway(
    this.server, {
    Admit? admit,
    this.allowCreate = true,
  }) : admit = admit ?? ((_, _) => true);

  final sync.Server server;
  final Admit admit;
  final bool allowCreate;

  HttpServer? _httpServer;

  Handler get handler {
    final router = Router();
    router.post('/scene/list', _handleSceneList);
    router.post('/scene/create', _handleSceneCreate);
    router.post('/scene/get', _handleSceneGet);
    router.get('/scene/<id>/ws', _handleSceneWs);
    router.get('/scene/<id>/asset/<hash>', _handleAssetGet);
    router.put('/scene/<id>/asset/<hash>', _handleAssetPut);

    return const Pipeline().addMiddleware(_cors).addMiddleware(logRequests()).addHandler(router.call);
  }

  Future<int> listen(InternetAddress address, int port) async {
    _httpServer = await shelf_io.serve(handler, address, port);
    return _httpServer!.port;
  }

  Future<void> close() async {
    await _httpServer?.close(force: true);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Request handling
  // -------------------------------------------------------------------------------------------------------------------

  Future<Response> _handleSceneList(Request r) async {
    if (!admit(null, _token(r))) return .forbidden('');
    return _proto(pb.ListScenesResponse(scenes: await server.listScenes()));
  }

  Future<Response> _handleSceneCreate(Request r) async {
    if (!allowCreate || !admit(null, _token(r))) return Response.forbidden('');
    final req = pb.CreateSceneRequest.fromBuffer(await _bytes(r));
    final (info, program) = await server.createScene(
      program: req.hasProgram() ? req.program : null,
      title: req.hasTitle() ? req.title : null,
    );

    return _proto(pb.CreateSceneResponse(info: info, program: program));
  }

  Future<Response> _handleSceneGet(Request r) async {
    final req = pb.GetSceneRequest.fromBuffer(await _bytes(r));
    if (!admit(req.id, _token(r))) return Response.forbidden('');
    final scene = await server.openScene(req.id);
    if (scene == null) return Response.notFound('');
    return _proto(pb.GetSceneResponse(info: scene.info, program: scene.program));
  }

  Future<Response> _handleSceneWs(Request r, String id) async {
    final clientId = r.url.queryParameters['client'] ?? '';
    if (!_isValidUuid(clientId)) return Response.forbidden('');
    final client = pb.Client(id: clientId);

    final token = r.url.queryParameters['token'] ?? _token(r);
    if (!admit(id, token)) return Response.forbidden('');

    return webSocketHandler((channel, _) async {
      final scene = await server.openScene(id);
      if (scene == null) return channel.sink.close(4404, 'Scene not found');
      scene.join(WebSocketServerConnection(channel), client);
    })(r);
  }

  Future<Response> _handleAssetGet(Request r, String id, String hash) async {
    if (!admit(id, _token(r))) return Response.forbidden('');
    final scene = await server.openScene(id);
    if (scene == null) return Response.notFound('scene not found');

    final bytes = await scene.storage.readAsset(.new(value: hash));
    if (bytes == null) return Response.notFound('asset not found');

    const headers = {
      'content-type': 'application/octet-stream',
      'cache-control': 'public, max-age=31536000, immutable',
    };

    return .ok(bytes, headers: headers);
  }

  Future<Response> _handleAssetPut(Request r, String id, String hash) async {
    if (!admit(id, _token(r))) return Response.forbidden('');
    final scene = await server.openScene(id);
    if (scene == null) return Response.notFound('scene not found');

    final bytes = await _bytes(r);
    if (Hash.compute(bytes).value != hash) return Response.badRequest(body: 'hash mismatch');
    await scene.storage.writeAsset(.new(value: hash), bytes);
    return Response.ok('');
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Utils
  // -------------------------------------------------------------------------------------------------------------------

  static String? _token(Request r) {
    return r.headers['authorization']?.replaceFirst('Bearer ', '');
  }

  static Future<Uint8List> _bytes(Request r) async {
    return Uint8List.fromList(await r.read().expand((x) => x).toList());
  }

  static Response _proto(protobuf.GeneratedMessage m) {
    return .ok(m.writeToBuffer(), headers: {'content-type': 'application/x-protobuf'});
  }

  static Handler _cors(Handler inner) => (r) async {
    const headers = {
      'access-control-allow-origin': '*',
      'access-control-allow-methods': 'GET, POST, PUT, OPTIONS',
      'access-control-allow-headers': 'content-type, authorization',
    };

    if (r.method == 'OPTIONS') return Response.ok('', headers: headers);
    return (await inner(r)).change(headers: headers);
  };

  static bool _isValidUuid(String id) {
    try {
      Uuid.parse(id);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final class WebSocketServerConnection extends sync.ServerConnection {
  WebSocketServerConnection(this._channel);
  final WebSocketChannel _channel;

  @override
  Stream<pb.ClientEvent> get events {
    return _channel.stream.where((m) => m is List<int>).map((m) => pb.ClientEvent.fromBuffer(m as List<int>));
  }

  @override
  void send(pb.ServerEvent event) {
    _channel.sink.add(event.writeToBuffer());
  }

  @override
  Future<void> close() => _channel.sink.close();
}
