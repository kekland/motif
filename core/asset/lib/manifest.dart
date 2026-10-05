part of 'asset.dart';

typedef AssetResolver = Future<Uint8List> Function(Hash);

final class AssetManifest({
  required final Map<Hash, Asset> entries,
}) {
  AssetManifest.empty() : this(entries: {});

  factory decode(gen.AssetManifest bundle) => bundle.decode();
  static AssetManifest? decodeRaw(Uint8List data) => codec.decodeRaw(() => .decode(.fromBuffer(data)));

  bool contains(Hash hash) => entries.containsKey(hash);

  void insertAll(Iterable<Asset> assets) {
    for (final asset in assets) entries[asset.hash] = asset;
    _invalidate();
  }

  void removeAll(Iterable<Asset> assets) {
    for (final asset in assets) entries.remove(asset.hash);
    _invalidate();
  }

  void _invalidate() {
    _fonts = null;
    _images = null;
    _fontCatalog = null;
  }

  List<FontAsset>? _fonts;
  List<ImageAsset>? _images;
  FontCatalog? _fontCatalog;

  FontAsset? font(Hash hash) => entries[hash] as FontAsset?;
  ImageAsset? image(Hash hash) => entries[hash] as ImageAsset?;

  Iterable<FontAsset> get fonts => _fonts ??= entries.values.whereType<FontAsset>().toList();
  Iterable<ImageAsset> get images => _images ??= entries.values.whereType<ImageAsset>().toList();
  FontCatalog get fontCatalog => _fontCatalog ??= .fromAssets(fonts);
}
