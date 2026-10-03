part of 'asset.dart';

final class FontCatalog({
  required final Map<Hash, FontAsset> assets,
}) {
  factory decode(gen.FontCatalog catalog) => catalog.decode();
  static FontCatalog? decodeRaw(Uint8List data) => codec.decodeRaw(() => .decode(.fromBuffer(data)));

  FontAsset? operator [](FontFamilyId id) => assets[id.hash];
}
