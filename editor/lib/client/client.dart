import 'dart:async';

import 'package:editor/imports.dart';
import 'package:schema/server.dart' as pb;
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

enum ConnectionStatus {
  connecting,
  connected,
  notFound,
  closed,
}

final _uuid = Uuid();
const _protoHeaders = {'content-type': 'application/x-protobuf'};

final class SceneConnection with Disposable {
  new({
    required this.server,
    required this.id,
  }) {
    _connect();
  }

  final Uri server;
  final String id;

  late String ownId;

  late final scene = $valueNotifier<Scene?>(null);
  late final peers = $valueNotifier<Map<String, pb.ClientPresence>>(const {});
  late final status = $valueNotifier(ConnectionStatus.connecting);

  late pb.Client _client;
  WebSocketChannel? _channel;
  StreamSubscription<ProgramDelta>? _history;
  final _pending = <ProgramDelta>[];

  var _backoff = const Duration(seconds: 1);
  var _closed = false;

  pb.ClientPresence? _presence;
  Timer? _presenceTimer;

  static Future<String> create(Uri server, Program program) async {
    final response = await http.post(
      server.resolve('/scenes/create'),
      headers: _protoHeaders,
      body: pb.CreateSceneRequest(program: program.encode()).writeToBuffer(),
    );
    if (response.statusCode != 200) throw StateError('create failed: ${response.statusCode}');
    return pb.CreateSceneResponse.fromBuffer(response.bodyBytes).id;
  }

  void _connect() {
    ownId = _uuid.v4();
    _client = pb.Client(id: ownId);
    status.value = .connecting;

    final uri = server.replace(
      scheme: server.scheme == 'https' ? 'wss' : 'ws',
      path: '/scenes/$id/ws',
      queryParameters: {'client': _client.id},
    );

    final channel = _channel = WebSocketChannel.connect(uri);
    channel.stream.listen(
      _receive,
      onDone: () => _disconnected(channel),
      onError: (_) {},
    );
  }

  void _disconnected(WebSocketChannel channel) {
    if (_closed || channel != _channel) return;
    _channel = null;

    if (channel.closeCode == 4404) {
      status.value = .notFound;
      return;
    }

    status.value = .connecting;
    Timer(_backoff, () {
      if (!_closed) _connect();
    });
    _backoff = Duration(seconds: (_backoff.inSeconds * 2).clamp(1, 10));
  }

  void _receive(Object? data) {
    if (data is! List<int>) return;
    final event = pb.ServerEvent.fromBuffer(data);

    switch (event.whichEvent()) {
      case .snapshot:
        _onSnapshot(event.snapshot);
      case .delta:
        _onDelta(event.delta);
      case .presence:
        peers.value = {...peers.value, event.presence.client.id: event.presence};
      case .left:
        peers.value = {...peers.value}..remove(event.left.id);
      case .notSet:
        break;
    }
  }

  void _onSnapshot(pb.Snapshot snapshot) {
    _history?.cancel();
    _pending.clear();

    final next = Scene(id: id, program: Program.decode(snapshot.program));
    _history = next.history.stream.listen(_send);

    final previous = scene.value;
    scene.value = next;
    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }

    peers.value = {
      for (final p in snapshot.clients)
        if (p.client.id != _client.id) p.client.id: p,
    };
    status.value = .connected;
    _backoff = const Duration(seconds: 1);
  }

  void _onDelta(pb.ClientDelta event) {
    if (event.client.id == _client.id) {
      if (_pending.isNotEmpty) _pending.removeAt(0);
      return;
    }

    final remote = ProgramDelta.decode(event.delta);
    final evaluation = scene.value!.evaluation;
    if (_pending.isEmpty) return remote.reapply(evaluation);

    ProgramDelta([
      for (final p in _pending.reversed) ...p.invert().changes,
      ...remote.changes,
      for (final p in _pending) ...p.changes,
    ]).reapply(evaluation);
  }

  void _send(ProgramDelta delta) {
    final channel = _channel;
    if (channel == null || status.value != .connected) return;

    _pending.add(delta);
    final message = pb.ClientDelta(delta: delta.encode(), client: _client);
    channel.sink.add(pb.ClientEvent(delta: message).writeToBuffer());
  }

  void updatePointer(Vec2? position, {String? type}) {
    _presence = pb.ClientPresence(
      client: _client,
      pointerPosition: position != null ? .new(x: position.x, y: position.y) : null,
      pointerType: type,
    );

    _presenceTimer ??= Timer(const Duration(milliseconds: 50), () {
      _presenceTimer = null;
      final presence = _presence;
      if (presence == null || status.value != .connected) return;
      _channel?.sink.add(pb.ClientEvent(presence: presence).writeToBuffer());
    });
  }

  @override
  void dispose() {
    _closed = true;
    _presenceTimer?.cancel();
    _history?.cancel();
    _channel?.sink.close();
    scene.value?.dispose();
    super.dispose();
  }
}

typedef PointerChangedCallback = void Function(Vec2? position, {String? type});