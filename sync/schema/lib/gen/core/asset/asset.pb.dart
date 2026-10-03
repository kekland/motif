// This is a generated file - do not edit.
//
// Generated from core/asset/asset.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../packages/skia/skia.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Hash extends $pb.GeneratedMessage {
  factory Hash({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  Hash._();

  factory Hash.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Hash.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Hash',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hash clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hash copyWith(void Function(Hash) updates) =>
      super.copyWith((message) => updates(message as Hash)) as Hash;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Hash create() => Hash._();
  @$core.override
  Hash createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Hash getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Hash>(create);
  static Hash? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class Asset_Font extends $pb.GeneratedMessage {
  factory Asset_Font({
    Hash? licenseHash,
    $core.String? family,
    $core.Iterable<FontFile>? files,
    FontFamilyThumbnail? thumbnail,
  }) {
    final result = create();
    if (licenseHash != null) result.licenseHash = licenseHash;
    if (family != null) result.family = family;
    if (files != null) result.files.addAll(files);
    if (thumbnail != null) result.thumbnail = thumbnail;
    return result;
  }

  Asset_Font._();

  factory Asset_Font.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Asset_Font.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset.Font',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Hash>(3, _omitFieldNames ? '' : 'licenseHash',
        protoName: 'licenseHash', subBuilder: Hash.create)
    ..aOS(4, _omitFieldNames ? '' : 'family')
    ..pPM<FontFile>(5, _omitFieldNames ? '' : 'files',
        subBuilder: FontFile.create)
    ..aOM<FontFamilyThumbnail>(6, _omitFieldNames ? '' : 'thumbnail',
        subBuilder: FontFamilyThumbnail.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset_Font clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset_Font copyWith(void Function(Asset_Font) updates) =>
      super.copyWith((message) => updates(message as Asset_Font)) as Asset_Font;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset_Font create() => Asset_Font._();
  @$core.override
  Asset_Font createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Asset_Font getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Asset_Font>(create);
  static Asset_Font? _defaultInstance;

  @$pb.TagNumber(3)
  Hash get licenseHash => $_getN(0);
  @$pb.TagNumber(3)
  set licenseHash(Hash value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLicenseHash() => $_has(0);
  @$pb.TagNumber(3)
  void clearLicenseHash() => $_clearField(3);
  @$pb.TagNumber(3)
  Hash ensureLicenseHash() => $_ensure(0);

  @$pb.TagNumber(4)
  $core.String get family => $_getSZ(1);
  @$pb.TagNumber(4)
  set family($core.String value) => $_setString(1, value);
  @$pb.TagNumber(4)
  $core.bool hasFamily() => $_has(1);
  @$pb.TagNumber(4)
  void clearFamily() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<FontFile> get files => $_getList(2);

  @$pb.TagNumber(6)
  FontFamilyThumbnail get thumbnail => $_getN(3);
  @$pb.TagNumber(6)
  set thumbnail(FontFamilyThumbnail value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasThumbnail() => $_has(3);
  @$pb.TagNumber(6)
  void clearThumbnail() => $_clearField(6);
  @$pb.TagNumber(6)
  FontFamilyThumbnail ensureThumbnail() => $_ensure(3);
}

class Asset_Image extends $pb.GeneratedMessage {
  factory Asset_Image({
    $core.int? width,
    $core.int? height,
    $core.String? mimeType,
  }) {
    final result = create();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (mimeType != null) result.mimeType = mimeType;
    return result;
  }

  Asset_Image._();

  factory Asset_Image.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Asset_Image.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset.Image',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'width')
    ..aI(2, _omitFieldNames ? '' : 'height')
    ..aOS(3, _omitFieldNames ? '' : 'mimeType', protoName: 'mimeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset_Image clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset_Image copyWith(void Function(Asset_Image) updates) =>
      super.copyWith((message) => updates(message as Asset_Image))
          as Asset_Image;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset_Image create() => Asset_Image._();
  @$core.override
  Asset_Image createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Asset_Image getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Asset_Image>(create);
  static Asset_Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get mimeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set mimeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMimeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearMimeType() => $_clearField(3);
}

enum Asset_Kind { font, image, notSet }

class Asset extends $pb.GeneratedMessage {
  factory Asset({
    Hash? hash,
    $core.int? size,
    Asset_Font? font,
    Asset_Image? image,
  }) {
    final result = create();
    if (hash != null) result.hash = hash;
    if (size != null) result.size = size;
    if (font != null) result.font = font;
    if (image != null) result.image = image;
    return result;
  }

  Asset._();

  factory Asset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Asset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Asset_Kind> _Asset_KindByTag = {
    10: Asset_Kind.font,
    11: Asset_Kind.image,
    0: Asset_Kind.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [10, 11])
    ..aOM<Hash>(1, _omitFieldNames ? '' : 'hash', subBuilder: Hash.create)
    ..aI(2, _omitFieldNames ? '' : 'size')
    ..aOM<Asset_Font>(10, _omitFieldNames ? '' : 'font',
        subBuilder: Asset_Font.create)
    ..aOM<Asset_Image>(11, _omitFieldNames ? '' : 'image',
        subBuilder: Asset_Image.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset copyWith(void Function(Asset) updates) =>
      super.copyWith((message) => updates(message as Asset)) as Asset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset create() => Asset._();
  @$core.override
  Asset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Asset>(create);
  static Asset? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  Asset_Kind whichKind() => _Asset_KindByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  void clearKind() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Hash get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash(Hash value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => $_clearField(1);
  @$pb.TagNumber(1)
  Hash ensureHash() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get size => $_getIZ(1);
  @$pb.TagNumber(2)
  set size($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(10)
  Asset_Font get font => $_getN(2);
  @$pb.TagNumber(10)
  set font(Asset_Font value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasFont() => $_has(2);
  @$pb.TagNumber(10)
  void clearFont() => $_clearField(10);
  @$pb.TagNumber(10)
  Asset_Font ensureFont() => $_ensure(2);

  @$pb.TagNumber(11)
  Asset_Image get image => $_getN(3);
  @$pb.TagNumber(11)
  set image(Asset_Image value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasImage() => $_has(3);
  @$pb.TagNumber(11)
  void clearImage() => $_clearField(11);
  @$pb.TagNumber(11)
  Asset_Image ensureImage() => $_ensure(3);
}

class AssetLicense extends $pb.GeneratedMessage {
  factory AssetLicense({
    Hash? hash,
    $core.String? descriptor,
    $core.String? kind,
    $core.String? body,
  }) {
    final result = create();
    if (hash != null) result.hash = hash;
    if (descriptor != null) result.descriptor = descriptor;
    if (kind != null) result.kind = kind;
    if (body != null) result.body = body;
    return result;
  }

  AssetLicense._();

  factory AssetLicense.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssetLicense.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssetLicense',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Hash>(1, _omitFieldNames ? '' : 'hash', subBuilder: Hash.create)
    ..aOS(2, _omitFieldNames ? '' : 'descriptor')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..aOS(4, _omitFieldNames ? '' : 'body')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetLicense clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetLicense copyWith(void Function(AssetLicense) updates) =>
      super.copyWith((message) => updates(message as AssetLicense))
          as AssetLicense;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssetLicense create() => AssetLicense._();
  @$core.override
  AssetLicense createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssetLicense getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssetLicense>(create);
  static AssetLicense? _defaultInstance;

  @$pb.TagNumber(1)
  Hash get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash(Hash value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => $_clearField(1);
  @$pb.TagNumber(1)
  Hash ensureHash() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get descriptor => $_getSZ(1);
  @$pb.TagNumber(2)
  set descriptor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescriptor() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescriptor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get body => $_getSZ(3);
  @$pb.TagNumber(4)
  set body($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBody() => $_has(3);
  @$pb.TagNumber(4)
  void clearBody() => $_clearField(4);
}

class FontFamilyThumbnail extends $pb.GeneratedMessage {
  factory FontFamilyThumbnail({
    $0.Path? path,
    $core.double? width,
    $core.double? height,
  }) {
    final result = create();
    if (path != null) result.path = path;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  FontFamilyThumbnail._();

  factory FontFamilyThumbnail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FontFamilyThumbnail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FontFamilyThumbnail',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<$0.Path>(1, _omitFieldNames ? '' : 'path', subBuilder: $0.Path.create)
    ..aD(2, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontFamilyThumbnail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontFamilyThumbnail copyWith(void Function(FontFamilyThumbnail) updates) =>
      super.copyWith((message) => updates(message as FontFamilyThumbnail))
          as FontFamilyThumbnail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FontFamilyThumbnail create() => FontFamilyThumbnail._();
  @$core.override
  FontFamilyThumbnail createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FontFamilyThumbnail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FontFamilyThumbnail>(create);
  static FontFamilyThumbnail? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Path get path => $_getN(0);
  @$pb.TagNumber(1)
  set path($0.Path value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Path ensurePath() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get width => $_getN(1);
  @$pb.TagNumber(2)
  set width($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get height => $_getN(2);
  @$pb.TagNumber(3)
  set height($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeight() => $_clearField(3);
}

class FontFile extends $pb.GeneratedMessage {
  factory FontFile({
    Hash? hash,
    $core.int? size,
    $core.Iterable<FontFace>? faces,
  }) {
    final result = create();
    if (hash != null) result.hash = hash;
    if (size != null) result.size = size;
    if (faces != null) result.faces.addAll(faces);
    return result;
  }

  FontFile._();

  factory FontFile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FontFile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FontFile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Hash>(1, _omitFieldNames ? '' : 'hash', subBuilder: Hash.create)
    ..aI(2, _omitFieldNames ? '' : 'size')
    ..pPM<FontFace>(3, _omitFieldNames ? '' : 'faces',
        subBuilder: FontFace.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontFile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontFile copyWith(void Function(FontFile) updates) =>
      super.copyWith((message) => updates(message as FontFile)) as FontFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FontFile create() => FontFile._();
  @$core.override
  FontFile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FontFile getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FontFile>(create);
  static FontFile? _defaultInstance;

  @$pb.TagNumber(1)
  Hash get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash(Hash value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => $_clearField(1);
  @$pb.TagNumber(1)
  Hash ensureHash() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get size => $_getIZ(1);
  @$pb.TagNumber(2)
  set size($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FontFace> get faces => $_getList(2);
}

class FontFace extends $pb.GeneratedMessage {
  factory FontFace({
    $core.int? index,
    $core.String? family,
    $core.int? weight,
    $core.int? width,
    $core.int? slant,
  }) {
    final result = create();
    if (index != null) result.index = index;
    if (family != null) result.family = family;
    if (weight != null) result.weight = weight;
    if (width != null) result.width = width;
    if (slant != null) result.slant = slant;
    return result;
  }

  FontFace._();

  factory FontFace.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FontFace.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FontFace',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'index')
    ..aOS(2, _omitFieldNames ? '' : 'family')
    ..aI(3, _omitFieldNames ? '' : 'weight')
    ..aI(4, _omitFieldNames ? '' : 'width')
    ..aI(5, _omitFieldNames ? '' : 'slant')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontFace clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontFace copyWith(void Function(FontFace) updates) =>
      super.copyWith((message) => updates(message as FontFace)) as FontFace;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FontFace create() => FontFace._();
  @$core.override
  FontFace createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FontFace getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FontFace>(create);
  static FontFace? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get family => $_getSZ(1);
  @$pb.TagNumber(2)
  set family($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFamily() => $_has(1);
  @$pb.TagNumber(2)
  void clearFamily() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get weight => $_getIZ(2);
  @$pb.TagNumber(3)
  set weight($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get width => $_getIZ(3);
  @$pb.TagNumber(4)
  set width($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWidth() => $_has(3);
  @$pb.TagNumber(4)
  void clearWidth() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get slant => $_getIZ(4);
  @$pb.TagNumber(5)
  set slant($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSlant() => $_has(4);
  @$pb.TagNumber(5)
  void clearSlant() => $_clearField(5);
}

class FontCatalog_Entry extends $pb.GeneratedMessage {
  factory FontCatalog_Entry({
    Hash? hash,
    Asset? asset,
  }) {
    final result = create();
    if (hash != null) result.hash = hash;
    if (asset != null) result.asset = asset;
    return result;
  }

  FontCatalog_Entry._();

  factory FontCatalog_Entry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FontCatalog_Entry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FontCatalog.Entry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Hash>(1, _omitFieldNames ? '' : 'hash', subBuilder: Hash.create)
    ..aOM<Asset>(2, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontCatalog_Entry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontCatalog_Entry copyWith(void Function(FontCatalog_Entry) updates) =>
      super.copyWith((message) => updates(message as FontCatalog_Entry))
          as FontCatalog_Entry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FontCatalog_Entry create() => FontCatalog_Entry._();
  @$core.override
  FontCatalog_Entry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FontCatalog_Entry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FontCatalog_Entry>(create);
  static FontCatalog_Entry? _defaultInstance;

  @$pb.TagNumber(1)
  Hash get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash(Hash value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => $_clearField(1);
  @$pb.TagNumber(1)
  Hash ensureHash() => $_ensure(0);

  @$pb.TagNumber(2)
  Asset get asset => $_getN(1);
  @$pb.TagNumber(2)
  set asset(Asset value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsset() => $_clearField(2);
  @$pb.TagNumber(2)
  Asset ensureAsset() => $_ensure(1);
}

class FontCatalog extends $pb.GeneratedMessage {
  factory FontCatalog({
    $core.Iterable<FontCatalog_Entry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  FontCatalog._();

  factory FontCatalog.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FontCatalog.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FontCatalog',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<FontCatalog_Entry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: FontCatalog_Entry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontCatalog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontCatalog copyWith(void Function(FontCatalog) updates) =>
      super.copyWith((message) => updates(message as FontCatalog))
          as FontCatalog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FontCatalog create() => FontCatalog._();
  @$core.override
  FontCatalog createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FontCatalog getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FontCatalog>(create);
  static FontCatalog? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FontCatalog_Entry> get entries => $_getList(0);
}

class LicenseBundle_Entry extends $pb.GeneratedMessage {
  factory LicenseBundle_Entry({
    Hash? hash,
    AssetLicense? license,
  }) {
    final result = create();
    if (hash != null) result.hash = hash;
    if (license != null) result.license = license;
    return result;
  }

  LicenseBundle_Entry._();

  factory LicenseBundle_Entry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LicenseBundle_Entry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LicenseBundle.Entry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Hash>(1, _omitFieldNames ? '' : 'hash', subBuilder: Hash.create)
    ..aOM<AssetLicense>(2, _omitFieldNames ? '' : 'license',
        subBuilder: AssetLicense.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LicenseBundle_Entry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LicenseBundle_Entry copyWith(void Function(LicenseBundle_Entry) updates) =>
      super.copyWith((message) => updates(message as LicenseBundle_Entry))
          as LicenseBundle_Entry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LicenseBundle_Entry create() => LicenseBundle_Entry._();
  @$core.override
  LicenseBundle_Entry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LicenseBundle_Entry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LicenseBundle_Entry>(create);
  static LicenseBundle_Entry? _defaultInstance;

  @$pb.TagNumber(1)
  Hash get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash(Hash value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => $_clearField(1);
  @$pb.TagNumber(1)
  Hash ensureHash() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetLicense get license => $_getN(1);
  @$pb.TagNumber(2)
  set license(AssetLicense value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLicense() => $_has(1);
  @$pb.TagNumber(2)
  void clearLicense() => $_clearField(2);
  @$pb.TagNumber(2)
  AssetLicense ensureLicense() => $_ensure(1);
}

class LicenseBundle extends $pb.GeneratedMessage {
  factory LicenseBundle({
    $core.Iterable<LicenseBundle_Entry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  LicenseBundle._();

  factory LicenseBundle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LicenseBundle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LicenseBundle',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<LicenseBundle_Entry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: LicenseBundle_Entry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LicenseBundle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LicenseBundle copyWith(void Function(LicenseBundle) updates) =>
      super.copyWith((message) => updates(message as LicenseBundle))
          as LicenseBundle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LicenseBundle create() => LicenseBundle._();
  @$core.override
  LicenseBundle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LicenseBundle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LicenseBundle>(create);
  static LicenseBundle? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LicenseBundle_Entry> get entries => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
