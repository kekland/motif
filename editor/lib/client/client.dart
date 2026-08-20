import 'dart:async';

import 'package:editor/imports.dart';
import 'package:schema/schema.dart' as pb;
import 'package:web_socket_channel/web_socket_channel.dart';

final _logger = Logger('SceneSync');

final class SceneSync {
  SceneSync(this.scene, {required this.uri});

  final Scene scene;
  final Uri uri;

  WebSocketChannel? _channel;
  StreamSubscription? _incoming;
  StreamSubscription? _historySubscription;
  var _disposed = false;

  void connect() {
    if (_disposed) return;

    final channel = _channel = WebSocketChannel.connect(uri);
    _historySubscription = scene.history.stream.listen(_publish);

    _incoming = channel.stream.listen(
      _onFrame,
      onError: (Object e) {
        _logger.warning('sync error: $e');
        _scheduleReconnect();
      },
      onDone: _scheduleReconnect,
    );
  }

  void _publish(SceneDelta delta) {
    final batch = encodeDeltaBatch(delta);
    if (batch.deltas.isEmpty) return;
    _channel?.sink.add(batch.writeToBuffer());
  }

  void _onFrame(dynamic data) {
    if (data is! List<int>) return;
    final event = pb.ServerEvent.fromBuffer(data);

    if (event.hasSnapshot()) {
      scene.load(SceneCodec.decodeScene(event.snapshot).program);
    } else if (event.hasDelta()) {
      try {
        scene.applyRemote(decodeDeltaBatch(event.delta, scene));
      } catch (e) {
        _logger.warning('remote apply failed, resyncing: $e');
        _scheduleReconnect();
      }
    }
  }

  void _scheduleReconnect() {
    _teardown();
    if (_disposed) return;
    Timer(const Duration(seconds: 1), connect);
  }

  void _teardown() {
    _historySubscription?.cancel();
    _incoming?.cancel();
    _incoming = null;
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _disposed = true;
    _teardown();
  }
}
