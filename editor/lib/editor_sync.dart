import 'dart:async';

import 'package:editor/imports.dart';
import 'package:skia/skia.dart' as skia;
import 'package:sync/client.dart' as sync;
import 'package:sync/schema.dart' as pb;

enum EditorSyncState {
  idle,
  connecting,
  connected,
  errored,
  closed,
}

final class EditorSync extends Controller {
  EditorSync({
    required this.client,
    required this.sceneId,
    String? clientId,
  }) : clientId = clientId ?? uuid.v4(),
       super(logger: Logger('editor/$sceneId')) {
    connect();
  }

  final sync.Client client;
  final String sceneId;
  final String clientId;

  sync.ClientConnection? _connection;

  Object? _error;
  Object? get error => _error;

  var _closed = false;

  late final _state = $signal<EditorSyncState>(.idle);
  EditorSyncState get state => _state.value;

  late final peers = $mapSignal<String, PeerPresence>({});

  late final _editor = $signal<Editor?>(null);
  Editor? get editor => _editor.value;

  pb.Client get self => .new(id: clientId);

  // -------------------------------------------------------------------------------------------------------------------
  // Initialization
  // -------------------------------------------------------------------------------------------------------------------

  Future<void> initialize() async {
    await skia.Skia.initialize();
    await EditorBuiltinFonts.initialize();
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Connection
  // -------------------------------------------------------------------------------------------------------------------

  Future<void> connect() async {
    if (_connection != null || _state.value == .connecting) return;
    await initialize();

    _state.value = .connecting;
    try {
      _connection = await client.connect(sceneId, .new(id: clientId));
      _connection!.events.listen(_handleEvent, onDone: _reconnect);
    } catch (e, st) {
      _error = e;
      logger.severe('failed to connect', e, st);
      _state.value = .errored;
    }
  }

  @override
  void dispose() {
    _closed = true;
    _connection?.close();
    _connection = null;
    _closed = true;
    _presenceUpdateTimer?.cancel();
    _historyListener?.cancel();
    _editor.value?.dispose();
    _editor.value = null;
    super.dispose();
  }

  var _backoff = const Duration(seconds: 1);
  void _reconnect() {
    if (_closed) return;
    _connection = null;

    Future.delayed(_backoff, () {
      if (_closed) return;
      connect();
    });

    _backoff = .new(seconds: (_backoff.inSeconds * 2).clamp(0, 20));
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Event handling
  // -------------------------------------------------------------------------------------------------------------------

  void _sendEvent(pb.ClientEvent event) => _connection!.send(event);

  void _handleEvent(pb.ServerEvent event) => switch (event.whichEvent()) {
    .snapshot => _handleSnapshotEvent(event.snapshot),
    .delta => _handleDeltaEvent(event.delta),
    .presence => _handlePresenceEvent(event.presence),
    .left => _handleLeftEvent(event.left),
    .notSet => null,
  };

  void _handleSnapshotEvent(pb.Snapshot snapshot) {
    _onSnapshot(snapshot);
    peers.clear();
    for (final presence in snapshot.clients) {
      peers[presence.client.id] = .decode(presence);
    }

    _state.value = .connected;
    _backoff = const Duration(seconds: 1);
  }

  void _handleDeltaEvent(pb.ClientDelta delta) {
    _onRemoteDelta(delta);
  }

  void _handlePresenceEvent(pb.ClientPresence presence) {
    peers[presence.client.id] = .decode(presence);
  }

  void _handleLeftEvent(pb.Client left) {
    peers.remove(left.id);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Scene setup
  // -------------------------------------------------------------------------------------------------------------------

  StreamSubscription<ProgramDelta>? _historyListener;
  final _pendingDeltas = <ProgramDelta>[];

  void _onSnapshot(pb.Snapshot snapshot) {
    _historyListener?.cancel();
    _pendingDeltas.clear();

    final previous = _editor.value;

    final next = Scene(id: sceneId, program: .decode(snapshot.program), assetResolver: loadAsset);
    _historyListener = next.history.stream.listen(_onLocalDelta);
    _editor.value = .new(sync: this, scene: next);

    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }
  }

  void _onLocalDelta(ProgramDelta delta) {
    if (state != .connected) return;
    _pendingDeltas.add(delta);

    final message = pb.ClientDelta(delta: delta.encode(), client: self);
    _sendEvent(.new(delta: message));
  }

  void _onRemoteDelta(pb.ClientDelta delta) {
    if (delta.client.id == self.id) {
      if (_pendingDeltas.isNotEmpty) _pendingDeltas.removeAt(0);
      return;
    }

    if (editor == null) return;

    final remote = ProgramDelta.decode(delta.delta);
    final evaluation = editor!.scene.evaluation;
    if (_pendingDeltas.isEmpty) return remote.reapply(evaluation);

    final mergedDelta = ProgramDelta([
      for (final p in _pendingDeltas.reversed) ...p.invert().changes,
      ...remote.changes,
      for (final p in _pendingDeltas) ...p.changes,
    ]);

    mergedDelta.reapply(evaluation);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Presence update
  // -------------------------------------------------------------------------------------------------------------------

  pb.ClientPresence? _selfPresence;
  Timer? _presenceUpdateTimer;

  void updatePresence({Vec2? pointerPosition, String? pointerType}) {
    _selfPresence = pb.ClientPresence(
      client: self,
      pointerPosition: pointerPosition != null ? .new(x: pointerPosition.x, y: pointerPosition.y) : null,
      pointerType: pointerType,
    );

    _presenceUpdateTimer ??= Timer(const Duration(milliseconds: 50), () {
      _presenceUpdateTimer = null;
      final presence = _selfPresence;
      if (presence == null || state != .connected) return;
      _sendEvent(.new(presence: presence));
    });
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Assets
  // -------------------------------------------------------------------------------------------------------------------

  Future<Hash> saveAsset(Uint8List data) async {
    final hash = Hash.compute(data);
    await client.saveAsset(sceneId, hash.encode(), data);
    return hash;
  }

  Future<Uint8List> loadAsset(AssetId id) async {
    final data = await client.loadAsset(sceneId, id.hash.encode());
    return data;
  }
}

final class const PeerPresence({
  required final String id,
  final Vec2? pointerPosition,
  final String? pointerType,
}) with Equatable {
  factory decode(pb.ClientPresence presence) => .new(
    id: presence.client.id,
    pointerPosition: presence.hasPointerPosition()
        ? .new(presence.pointerPosition.x, presence.pointerPosition.y)
        : null,
    pointerType: presence.pointerType,
  );

  @override
  List<Object?> get props => [id, pointerPosition, pointerType];
}
