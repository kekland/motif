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
    hash: v.hash.decode(),
    size: v.size,
    width: v.image.width,
    height: v.image.height,
    mimeType: v.image.mimeType,
  ),
  encoder: (v) => .new(
    hash: v.hash.encode(),
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
    hash: v.hash.decode(),
    size: v.size,
    licenseHash: v.font.licenseHash.decode(),
    family: v.font.family,
    files: $map(v.font.files, (e) => e.decode()),
    thumbnail: v.font.thumbnail.decode(),
  ),
  encoder: (v) => .new(
    hash: v.hash.encode(),
    size: v.size,
    font: .new(
      licenseHash: v.licenseHash.encode(),
      family: v.family,
      files: $map(v.files, (e) => e.encode()),
      thumbnail: v.thumbnail.encode(),
    ),
  ),
);


extension HashEncode on Hash { gen.Hash encode() => _hashCodec.encode(this); }
extension HashDecode on gen.Hash { Hash decode() => _hashCodec.decode(this); }

final _hashCodec = $codec<Hash, gen.Hash>(
  decoder: (v) => Hash.raw(v.value),
  encoder: (v) => gen.Hash(value: v.value),
);

extension _FontFileEncode on FontFile { gen.FontFile encode() => _fontFileCodec.encode(this); }
extension _FontFileDecode on gen.FontFile { FontFile decode() => _fontFileCodec.decode(this); }

final _fontFileCodec = $codec<FontFile, gen.FontFile>(
  decoder: (v) => .new(
    hash: v.hash.decode(),
    size: v.size,
    faces: $map(v.faces, (e) => e.decode()),
  ),
  encoder: (v) => .new(
    hash: v.hash.encode(),
    size: v.size,
    faces: $map(v.faces, (e) => e.encode()),
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
  ),
  encoder: (v) => .new(
    index: v.index,
    family: v.family,
    weight: v.weight.value,
    width: v.width.value,
    slant: v.slant.index,
  ),
);

extension FontFamilyThumbnailEncode on FontFamilyThumbnail { gen.FontFamilyThumbnail encode() => _fontFamilyThumbnailCodec.encode(this); }
extension FontFamilyThumbnailDecode on gen.FontFamilyThumbnail { FontFamilyThumbnail decode() => _fontFamilyThumbnailCodec.decode(this); }

final _fontFamilyThumbnailCodec = $codec<FontFamilyThumbnail, gen.FontFamilyThumbnail>(
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

extension FontCatalogEncode on FontCatalog { gen.FontCatalog encode() => _fontCatalogCodec.encode(this); }
extension FontCatalogDecode on gen.FontCatalog { FontCatalog decode() => _fontCatalogCodec.decode(this); }

final _fontCatalogCodec = $codec<FontCatalog, gen.FontCatalog>(
  decoder: (v) => .new(
    assets: $mapFrom(v.entries, (e) => e.hash.decode(), (e) => _fontAssetCodec.decode(e.asset)),
  ),
  encoder: (v) => .new(
    entries: $map(v.assets.entries, (e) => .new(hash: e.key.encode(), asset: e.value.encode())),
  ),
);

extension AssetLicenseEncode on AssetLicense { gen.AssetLicense encode() => _assetLicenseCodec.encode(this); }
extension AssetLicenseDecode on gen.AssetLicense { AssetLicense decode() => _assetLicenseCodec.decode(this); }

final _assetLicenseCodec = $codec<AssetLicense, gen.AssetLicense>(
  decoder: (v) => .new(
    hash: v.hash.decode(),
    descriptor: v.descriptor,
    kind: v.kind,
    body: v.body,
  ),
  encoder: (v) => .new(
    hash: v.hash.encode(),
    descriptor: v.descriptor,
    kind: v.kind,
    body: v.body,
  ),
);

extension LicenseBundleEncode on LicenseBundle { gen.LicenseBundle encode() => _licenseBundleCodec.encode(this); }
extension LicenseBundleDecode on gen.LicenseBundle { LicenseBundle decode() => _licenseBundleCodec.decode(this); }

final _licenseBundleCodec = $codec<LicenseBundle, gen.LicenseBundle>(
  decoder: (v) => .new(
    licenses: $mapFrom(v.entries, (e) => e.hash.decode(), (e) => e.license.decode()),
  ),
  encoder: (v) => .new(
    entries: $map(v.licenses.entries, (e) => .new(hash: e.key.encode(), license: e.value.encode())),
  ),
);