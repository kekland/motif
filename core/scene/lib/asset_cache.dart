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
  FutureOr<void> add(Asset asset, Uint8List data) {
    final hash = asset.hash;

    if (_cached.contains(hash)) return null;
    _inProgress[hash] = _process(asset, data);
    return _inProgress[hash]!;
  }

  @override
  FutureOr<void> fetch(StatementId? statementId, Asset asset) {
    final hash = asset.hash;

    if (_cached.contains(hash)) return null;

    if (statementId != null) {
      _notifyOnUpdate.putIfAbsent(hash, HashSet.new).add(statementId);
    }

    if (_inProgress.containsKey(hash)) return _inProgress[hash]!;

    _inProgress[hash] = _performFetch(asset);
    return _inProgress[hash]!;
  }

  Future<Uint8List> _performFetch(Asset asset) async {
    final hash = asset.hash;
    final data = await scene.assetResolver!(hash);
    await _process(asset, data);

    _inProgress.remove(hash);
    _notifyUpdate(hash);
    return data;
  }

  void _notifyUpdate(Hash hash) {
    final statementIds = _notifyOnUpdate.remove(hash);
    if (statementIds != null) {
      for (final id in statementIds) {
        for (final listener in _listeners) listener(id);
      }
    }
  }

  Future<void> _process(Asset asset, Uint8List bytes) async {
    if (asset is FontAsset) {
      await font.add(asset, bytes);
    } else if (asset is ImageAsset) {
      await image.add(asset.hash, bytes);
    } else {
      throw UnsupportedError('Unsupported asset type: ${asset.runtimeType}');
    }

    _cached.add(asset.hash);
  }
}

final class SceneFontCache extends FontCache {
  SceneFontCache() : provider = .new();

  @override
  final skia.FontProvider provider;

  @override
  Future<void> add(FontAsset asset, Uint8List bytes) async {
    print('added font asset: ${asset.family}: ${asset.faces.length}');
    print(provider.add(bytes, family: asset.family));

    final loader = FontLoader(asset.family);
    loader.addFont(.value(bytes.buffer.asByteData()));
    await loader.load();
  }

  @override
  void dispose() {
    provider.dispose();
  }
}

final class SceneImageCache {
  final cache = <Hash, ui.Image>{};

  ui.Image? operator [](Hash hash) => cache[hash];

  Future<ui.Image> add(Hash hash, Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    cache[hash] = frame.image;
    codec.dispose();
    return frame.image;
  }

  Future<ImageAsset> addLocal(Uint8List bytes, {required String mimeType}) async {
    final hash = Hash.compute(bytes);
    final image = await add(hash, bytes);

    return ImageAsset(
      hash: hash,
      size: bytes.lengthInBytes,
      width: image.width,
      height: image.height,
      mimeType: mimeType,
    );
  }

  void dispose() {
    for (final i in cache.values) i.dispose();
    cache.clear();
  }
}
