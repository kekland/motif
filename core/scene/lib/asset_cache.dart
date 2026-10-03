part of 'scene.dart';

final class SceneAssetCache extends AssetCache {
  SceneAssetCache(this.scene);
  final Scene scene;

  final _listeners = <AssetFetchListener>{};

  final _cached = <Hash>{};
  final _inProgress = <Hash, Future<void>>{};
  final _notifyOnUpdate = <Hash, HashSet<StatementId>>{};

  @override
  final font = SceneFontCache();
  final image = SceneImageCache();

  @override
  void addFetchListener(AssetFetchListener listener) => _listeners.add(listener);

  @override
  void removeFetchListener(AssetFetchListener listener) => _listeners.remove(listener);

  @override
  void dispose() {
    font.dispose();
    image.dispose();
    _cached.clear();
    _listeners.clear();
    _inProgress.clear();
    _notifyOnUpdate.clear();
  }

  @override
  FutureOr<void> add(AssetId id, Uint8List data) {
    if (_cached.contains(id.hash)) return null;
    _inProgress[id.hash] = _process(id, data);
    return _inProgress[id.hash]!;
  }

  @override
  FutureOr<void> fetch(StatementId? statementId, AssetId id) {
    final hash = id.hash;
    if (_cached.contains(hash)) return null;

    if (statementId != null) {
      _notifyOnUpdate.putIfAbsent(id.hash, HashSet.new).add(statementId);
    }

    if (_inProgress.containsKey(hash)) return _inProgress[hash]!;

    _inProgress[hash] = _performFetch(id);
    return _inProgress[hash];
  }

  Future<Uint8List> _performFetch(AssetId id) async {
    final data = await scene.assetResolver!(id);
    await _process(id, data);

    _inProgress.remove(id.hash);
    _notifyUpdate(id);
    return data;
  }

  void _notifyUpdate(AssetId id) {
    final statementIds = _notifyOnUpdate.remove(id.hash);
    if (statementIds != null) {
      for (final id in statementIds) {
        for (final listener in _listeners) listener(id);
      }
    }
  }

  Future<void> _process(AssetId id, Uint8List bytes) async {
    if (id is FontFileId) {
      font.provider.add(bytes);
    } else if (id is ImageId) {
      await image.add(id, bytes);
    }

    _cached.add(id.hash);
  }
}

final class SceneFontCache extends FontCache {
  SceneFontCache() : provider = .new();

  @override
  final skia.FontProvider provider;

  @override
  void dispose() {
    provider.dispose();
  }
}

final class SceneImageCache {
  final cache = <ImageId, ui.Image>{};

  ui.Image? operator [](ImageId id) => cache[id];

  Future<void> add(ImageId id, Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    cache[id] = frame.image;
    codec.dispose();
  }

  void dispose() {
    for (final i in cache.values) i.dispose();
    cache.clear();
  }
}
