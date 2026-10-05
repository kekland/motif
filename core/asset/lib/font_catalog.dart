part of 'asset.dart';

final class FontCatalog({
  required final Map<String, FontFamily> families,
}) {
  factory FontCatalog.fromAssets(Iterable<FontAsset> assets) {
    final familyNames = <String>{};
    final familyAssets = <String, List<FontAsset>>{};
    final familyFaces = <String, List<FontFace>>{};
    final familyThumbnail = <String, FontFaceThumbnail?>{};

    for (final asset in assets) {
      final name = asset.family;

      familyNames.add(name);
      familyAssets.putIfAbsent(name, () => []);
      familyFaces.putIfAbsent(name, () => []);
      familyThumbnail.putIfAbsent(name, () => null);

      familyAssets[name]!.add(asset);
      for (final face in asset.faces) {
        familyFaces[name]!.add(face);
        if (face.thumbnail != null) {
          familyThumbnail[name] = face.thumbnail;
        }
      }
    }

    final families = familyNames.map(
      (n) => FontFamily(
        name: n,
        assets: familyAssets[n]!,
        faces: familyFaces[n]!,
        thumbnail: familyThumbnail[n],
      ),
    );

    return .new(families: {for (final f in families) f.name: f});
  }

  late final List<FontAsset> assets = families.values.expand((f) => f.assets).toList();
  late final List<FontFace> faces = families.values.expand((f) => f.faces).toList();

  bool contains(Hash hash) => assets.any((a) => a.hash == hash);

  FontFamily operator [](String name) => families[name]!;
}

final class FontFamily({
  required final String name,
  required final List<FontAsset> assets,
  required final List<FontFace> faces,
  final FontFaceThumbnail? thumbnail,
}) {
  FontFace? resolveFace({
    required skia.FontWeight weight,
    required skia.FontWidth width,
    required skia.FontSlant slant,
  }) => faces.resolveExact(weight: weight, width: width, slant: slant);

  FontFace resolveClosest({
    required skia.FontWeight weight,
    required skia.FontWidth width,
    required skia.FontSlant slant,
  }) => faces.resolveClosest(weight: weight, width: width, slant: slant);

  FontAsset assetFor(FontFace face) => assets.firstWhere((a) => a.faces.contains(face));
}
