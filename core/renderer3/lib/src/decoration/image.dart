part of '../../renderer.dart';

final class ImageDecorationManager with ChangeNotifier, ChangeNotifierDisposable {
  new(this.renderer);
  final Renderer renderer;

  late final _cache = $disposable(
    LruAsyncCache<int, Hash, webgpu.Texture>(
      _load,
      onDispose: (texture) => texture.destroy(),
      sizeOf: (texture) => texture.width * texture.height * 4,
      onResolve: (token) => renderer.updater._onStyleUpdate(token as CellRef),
      compare: (a, b) => a == b,
      maxSize: 256 * 1024 * 1024,
      label: 'image',
    ),
  );

  webgpu.Texture? resolve(Hash hash, {CellRef? ref}) => _cache.get(
    Mix64.hashObject(hash),
    hash,
    updateToken: ref,
  );

  Future<webgpu.Texture?> _load(int id, Hash hash) async {
    final asset = renderer.scene.assetManifest.image(hash);
    if (asset == null) return null;

    final data = await renderer.scene.assetCache.fetchImage(null, asset);
    if (data == null) return null;

    final texture = renderer.device!.createTexture(
      .new(
        size: .new(width: data.width, height: data.height),
        dimension: .twoD,
        format: .rgba8unorm,
        usage: .of([.copyDst, .textureBinding]),
      ),
    );

    renderer.queue.writeTexture(
      .new(texture: texture),
      data.bytes,
      .new(bytesPerRow: data.width * 4, rowsPerImage: data.height),
      .new(width: data.width, height: data.height),
    );

    return texture;
  }
}
