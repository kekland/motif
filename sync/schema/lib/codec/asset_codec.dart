import '_base.dart';

import 'package:asset/asset.dart';
import 'package:schema/asset.dart' as gen;

import 'skia_codec.dart';

// dart format off

extension AssetEncode on Asset { gen.Asset encode() => _assetCodec.encode(this); }
extension AssetDecode on gen.Asset { Asset decode() => _assetCodec.decode(this); }

final _assetCodec = $codec<Asset, gen.Asset>(
  decoder: (v) => switch(v.whichKind()) {
    .font => _fontAssetCodec.decode(v),
    .image => _imageAssetCodec.decode(v),
    .notSet => throw UnimplementedError(),
  },
  encoder: (v) => switch(v) {
    FontAsset a => _fontAssetCodec.encode(a),
    ImageAsset a => _imageAssetCodec.encode(a),
  },
);

final _imageAssetCodec = $codec<ImageAsset, gen.Asset>(
  decoder: (v) => .new(
    hash: .raw(v.hash),
    size: v.size,
    width: v.image.width,
    height: v.image.height,
    mimeType: v.image.mimeType,
  ),
  encoder: (v) => .new(
    hash: v.hash.value,
    size: v.size,
    image: .new(
      width: v.width,
      height: v.height,
      mimeType: v.mimeType,
    ),
  ),
);

final _fontAssetCodec = $codec<FontAsset, gen.Asset>(
  decoder: (v) => .new(
    hash: .raw(v.hash),
    size: v.size,
    license: .raw(v.font.license),
    family: v.font.family,
    faces: $map(v.font.faces, (e) => e.decode()),
  ),
  encoder: (v) => .new(
    hash: v.hash.value,
    size: v.size,
    font: .new(
      license: v.license.value,
      family: v.family,
      faces: $map(v.faces, (e) => e.encode()),
    ),
  ),
);


extension _FontFaceEncode on FontFace { gen.FontFace encode() => _fontFaceCodec.encode(this); }
extension _FontFaceDecode on gen.FontFace { FontFace decode() => _fontFaceCodec.decode(this); }

final _fontFaceCodec = $codec<FontFace, gen.FontFace>(
  decoder: (v) => .new(
    index: v.index,
    family: v.family,
    weight: .new(v.weight),
    width: .new(v.width),
    slant: .values[v.slant],
    thumbnail: $opt(v.hasThumbnail, () => v.thumbnail.decode()),
  ),
  encoder: (v) => .new(
    index: v.index,
    family: v.family,
    weight: v.weight.value,
    width: v.width.value,
    slant: v.slant.index,
    thumbnail: v.thumbnail?.encode(),
  ),
);

extension FontFaceThumbnailEncode on FontFaceThumbnail { gen.FontFace_Thumbnail encode() => _fontFamilyThumbnailCodec.encode(this); }
extension FontFaceThumbnailDecode on gen.FontFace_Thumbnail { FontFaceThumbnail decode() => _fontFamilyThumbnailCodec.decode(this); }

final _fontFamilyThumbnailCodec = $codec<FontFaceThumbnail, gen.FontFace_Thumbnail>(
  decoder: (v) => .new(
    path: v.path.decode(),
    width: v.width,
    height: v.height,
  ),
  encoder: (v) => .new(
    path: v.path.encode(),
    width: v.width,
    height: v.height,
  ),
);

extension AssetLicenseEncode on AssetLicense { gen.AssetLicense encode() => _assetLicenseCodec.encode(this); }
extension AssetLicenseDecode on gen.AssetLicense { AssetLicense decode() => _assetLicenseCodec.decode(this); }

final _assetLicenseCodec = $codec<AssetLicense, gen.AssetLicense>(
  decoder: (v) => .new(
    hash: .raw(v.hash),
    descriptor: v.descriptor,
    kind: v.kind,
    body: v.body,
  ),
  encoder: (v) => .new(
    hash: v.hash.value,
    descriptor: v.descriptor,
    kind: v.kind,
    body: v.body,
  ),
);

extension LicenseBundleEncode on LicenseBundle { gen.LicenseBundle encode() => _licenseBundleCodec.encode(this); }
extension LicenseBundleDecode on gen.LicenseBundle { LicenseBundle decode() => _licenseBundleCodec.decode(this); }

final _licenseBundleCodec = $codec<LicenseBundle, gen.LicenseBundle>(
  decoder: (v) => .new(
    licenses: $mmap(v.licenses, (k) => .raw(k), (v) => v.decode()),
  ),
  encoder: (v) => .new(
    licenses: $mmap(v.licenses, (k) => k.value, (v) => v.encode()).entries,
  ),
);

extension AssetManifestEncode on AssetManifest { gen.AssetManifest encode() => _assetManifestCodec.encode(this); }
extension AssetManifestDecode on gen.AssetManifest { AssetManifest decode() => _assetManifestCodec.decode(this); }

final _assetManifestCodec = $codec<AssetManifest, gen.AssetManifest>(
  decoder: (v) => .new(
    entries: $mmap(v.entries, (k) => .raw(k), (v) => v.decode()),
  ),
  encoder: (v) => .new(
    entries: $mmap(v.entries, (k) => k.value, (v) => v.encode()).entries,
  ),
);