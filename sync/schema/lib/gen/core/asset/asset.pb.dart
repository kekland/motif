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

import '../../packages/skia_common/skia_common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AssetManifest extends $pb.GeneratedMessage {
  factory AssetManifest({
    $core.Iterable<$core.MapEntry<$core.String, Asset>>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addEntries(entries);
    return result;
  }

  AssetManifest._();

  factory AssetManifest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssetManifest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssetManifest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..m<$core.String, Asset>(1, _omitFieldNames ? '' : 'entries',
        entryClassName: 'AssetManifest.EntriesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Asset.create,
        valueDefaultOrMaker: Asset.getDefault,
        packageName: const $pb.PackageName('motif'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetManifest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetManifest copyWith(void Function(AssetManifest) updates) =>
      super.copyWith((message) => updates(message as AssetManifest))
          as AssetManifest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssetManifest create() => AssetManifest._();
  @$core.override
  AssetManifest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssetManifest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssetManifest>(create);
  static AssetManifest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, Asset> get entries => $_getMap(0);
}

class Asset_Font extends $pb.GeneratedMessage {
  factory Asset_Font({
    $core.String? family,
    $core.String? license,
    $core.Iterable<FontFace>? faces,
  }) {
    final result = create();
    if (family != null) result.family = family;
    if (license != null) result.license = license;
    if (faces != null) result.faces.addAll(faces);
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
    ..aOS(1, _omitFieldNames ? '' : 'family')
    ..aOS(2, _omitFieldNames ? '' : 'license')
    ..pPM<FontFace>(3, _omitFieldNames ? '' : 'faces',
        subBuilder: FontFace.create)
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

  @$pb.TagNumber(1)
  $core.String get family => $_getSZ(0);
  @$pb.TagNumber(1)
  set family($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFamily() => $_has(0);
  @$pb.TagNumber(1)
  void clearFamily() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get license => $_getSZ(1);
  @$pb.TagNumber(2)
  set license($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLicense() => $_has(1);
  @$pb.TagNumber(2)
  void clearLicense() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FontFace> get faces => $_getList(2);
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
    ..aOS(3, _omitFieldNames ? '' : 'mimeType')
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
    $core.String? hash,
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
    ..aOS(1, _omitFieldNames ? '' : 'hash')
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
  $core.String get hash => $_getSZ(0);
  @$pb.TagNumber(1)
  set hash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => $_clearField(1);

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

class FontFace_Thumbnail extends $pb.GeneratedMessage {
  factory FontFace_Thumbnail({
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

  FontFace_Thumbnail._();

  factory FontFace_Thumbnail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FontFace_Thumbnail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FontFace.Thumbnail',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<$0.Path>(1, _omitFieldNames ? '' : 'path', subBuilder: $0.Path.create)
    ..aD(2, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontFace_Thumbnail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FontFace_Thumbnail copyWith(void Function(FontFace_Thumbnail) updates) =>
      super.copyWith((message) => updates(message as FontFace_Thumbnail))
          as FontFace_Thumbnail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FontFace_Thumbnail create() => FontFace_Thumbnail._();
  @$core.override
  FontFace_Thumbnail createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FontFace_Thumbnail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FontFace_Thumbnail>(create);
  static FontFace_Thumbnail? _defaultInstance;

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

class FontFace extends $pb.GeneratedMessage {
  factory FontFace({
    $core.String? family,
    $core.int? index,
    $core.int? weight,
    $core.int? width,
    $core.int? slant,
    FontFace_Thumbnail? thumbnail,
  }) {
    final result = create();
    if (family != null) result.family = family;
    if (index != null) result.index = index;
    if (weight != null) result.weight = weight;
    if (width != null) result.width = width;
    if (slant != null) result.slant = slant;
    if (thumbnail != null) result.thumbnail = thumbnail;
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
    ..aOS(1, _omitFieldNames ? '' : 'family')
    ..aI(2, _omitFieldNames ? '' : 'index')
    ..aI(3, _omitFieldNames ? '' : 'weight')
    ..aI(4, _omitFieldNames ? '' : 'width')
    ..aI(5, _omitFieldNames ? '' : 'slant')
    ..aOM<FontFace_Thumbnail>(6, _omitFieldNames ? '' : 'thumbnail',
        subBuilder: FontFace_Thumbnail.create)
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
  $core.String get family => $_getSZ(0);
  @$pb.TagNumber(1)
  set family($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFamily() => $_has(0);
  @$pb.TagNumber(1)
  void clearFamily() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get index => $_getIZ(1);
  @$pb.TagNumber(2)
  set index($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndex() => $_clearField(2);

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

  @$pb.TagNumber(6)
  FontFace_Thumbnail get thumbnail => $_getN(5);
  @$pb.TagNumber(6)
  set thumbnail(FontFace_Thumbnail value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasThumbnail() => $_has(5);
  @$pb.TagNumber(6)
  void clearThumbnail() => $_clearField(6);
  @$pb.TagNumber(6)
  FontFace_Thumbnail ensureThumbnail() => $_ensure(5);
}

class AssetLicense extends $pb.GeneratedMessage {
  factory AssetLicense({
    $core.String? hash,
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
    ..aOS(1, _omitFieldNames ? '' : 'hash')
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
  $core.String get hash => $_getSZ(0);
  @$pb.TagNumber(1)
  set hash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => $_clearField(1);

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

class LicenseBundle extends $pb.GeneratedMessage {
  factory LicenseBundle({
    $core.Iterable<$core.MapEntry<$core.String, AssetLicense>>? licenses,
  }) {
    final result = create();
    if (licenses != null) result.licenses.addEntries(licenses);
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
    ..m<$core.String, AssetLicense>(1, _omitFieldNames ? '' : 'licenses',
        entryClassName: 'LicenseBundle.LicensesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: AssetLicense.create,
        valueDefaultOrMaker: AssetLicense.getDefault,
        packageName: const $pb.PackageName('motif'))
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
  $pb.PbMap<$core.String, AssetLicense> get licenses => $_getMap(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
