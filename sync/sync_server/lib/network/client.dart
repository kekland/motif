import 'dart:typed_data';

import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart' as protobuf;

import 'package:sync/sync.dart' as sync;
import 'package:sync/schema.dart' as pb;
import 'package:web_socket_channel/web_socket_channel.dart';

final class NetworkClient extends sync.Client {
  NetworkClient(this.uri, {this.token, http.Client? client}) : client = client ?? .new();

  final Uri uri;
  final String? token;
  final http.Client client;

  @override
  Future<pb.ListScenesResponse> listScenes() async {
    return .fromBuffer(await _post('/scene/list', null));
  }

  @override
  Future<pb.CreateSceneResponse> createScene({pb.Program? program, String? title}) async {
    final request = pb.CreateSceneRequest(program: program, title: title);
    return .fromBuffer(await _post('/scene/create', request));
  }

  @override
  Future<pb.GetSceneResponse> getScene(String id) async {
    final request = pb.GetSceneRequest(id: id);
    return .fromBuffer(await _post('/scene/get', request));
  }

  @override
  Future<sync.ClientConnection> connect(String id, pb.Client client) async {
    final ws = uri.replace(
      scheme: uri.scheme == 'https' ? 'wss' : 'ws',
      path: '${uri.path}/scene/$id/ws',
      queryParameters: {
        'client': client.id,
        if (token != null) 'token': token,
      },
    );

    final channel = WebSocketChannel.connect(ws);
    await channel.ready;
    return WebSocketClientConnection(channel);
  }

  @override
  Future<Uint8List> loadAsset(String sceneId, Hash hash) async {
    final response = await client.get(_assetUri(sceneId, hash), headers: _headers());
    return _parseResponse(response);
  }

  @override
  Future<void> saveAsset(String sceneId, Hash hash, Uint8List data) async {
    final response = await client.put(_assetUri(sceneId, hash), headers: _headers(), body: data);
    _parseResponse(response);
  }

  Future<Uint8List> _post(String path, protobuf.GeneratedMessage? request) async {
    final contentTypeHeader = request != null ? {'content-type': 'application/x-protobuf'} : {};

    final response = await client.post(
      uri.replace(path: '${uri.path}/$path'),
      headers: {
        ...contentTypeHeader,
        ..._headers(),
      },
      body: request?.writeToBuffer(),
    );

    return _parseResponse(response);
  }

  Uri _assetUri(String sceneId, Hash hash) => uri.replace(path: '${uri.path}/scene/$sceneId/asset/$hash');

  Map<String, String> _headers() => {
    if (token != null) 'authorization': 'Bearer $token',
  };

  Uint8List _parseResponse(http.Response response) {
    return switch (response.statusCode) {
      200 => response.bodyBytes,
      403 => throw sync.Forbidden(),
      404 => throw sync.NotFound(),
      _ => throw http.ClientException('${response.statusCode}: ${response.body}', response.request?.url),
    };
  }

  @override
  Future<void> close() async {
    client.close();
  }
}

final class WebSocketClientConnection extends sync.ClientConnection {
  WebSocketClientConnection(this._channel);
  final WebSocketChannel _channel;

  @override
  Stream<pb.ServerEvent> get events {
    return _channel.stream.where((m) => m is List<int>).map((m) => .fromBuffer(m as List<int>));
  }

  @override
  void send(pb.ClientEvent event) => _channel.sink.add(event.writeToBuffer());

  @override
  Object? get closeReason => switch (_channel.closeCode) {
    1000 => 'closed',
    4403 => sync.Forbidden(),
    4404 => sync.NotFound(),
    _ => 'unknown',
  };

  @override
  Future<void> close() => _channel.sink.close(1000);
}
