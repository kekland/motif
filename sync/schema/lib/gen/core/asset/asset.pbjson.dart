// This is a generated file - do not edit.
//
// Generated from core/asset/asset.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use hashDescriptor instead')
const Hash$json = {
  '1': 'Hash',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `Hash`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hashDescriptor =
    $convert.base64Decode('CgRIYXNoEhQKBXZhbHVlGAEgASgJUgV2YWx1ZQ==');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 11, '6': '.motif.Hash', '10': 'hash'},
    {'1': 'size', '3': 2, '4': 1, '5': 5, '10': 'size'},
    {
      '1': 'font',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.motif.Asset.Font',
      '9': 0,
      '10': 'font'
    },
    {
      '1': 'image',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.motif.Asset.Image',
      '9': 0,
      '10': 'image'
    },
  ],
  '3': [Asset_Font$json, Asset_Image$json],
  '8': [
    {'1': 'kind'},
  ],
};

@$core.Deprecated('Use assetDescriptor instead')
const Asset_Font$json = {
  '1': 'Font',
  '2': [
    {
      '1': 'licenseHash',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.Hash',
      '10': 'licenseHash'
    },
    {'1': 'family', '3': 4, '4': 1, '5': 9, '10': 'family'},
    {
      '1': 'files',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.motif.FontFile',
      '10': 'files'
    },
    {
      '1': 'thumbnail',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.FontFamilyThumbnail',
      '10': 'thumbnail'
    },
  ],
};

@$core.Deprecated('Use assetDescriptor instead')
const Asset_Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 5, '10': 'height'},
    {'1': 'mimeType', '3': 3, '4': 1, '5': 9, '10': 'mimeType'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIfCgRoYXNoGAEgASgLMgsubW90aWYuSGFzaFIEaGFzaBISCgRzaXplGAIgASgFUg'
    'RzaXplEicKBGZvbnQYCiABKAsyES5tb3RpZi5Bc3NldC5Gb250SABSBGZvbnQSKgoFaW1hZ2UY'
    'CyABKAsyEi5tb3RpZi5Bc3NldC5JbWFnZUgAUgVpbWFnZRquAQoERm9udBItCgtsaWNlbnNlSG'
    'FzaBgDIAEoCzILLm1vdGlmLkhhc2hSC2xpY2Vuc2VIYXNoEhYKBmZhbWlseRgEIAEoCVIGZmFt'
    'aWx5EiUKBWZpbGVzGAUgAygLMg8ubW90aWYuRm9udEZpbGVSBWZpbGVzEjgKCXRodW1ibmFpbB'
    'gGIAEoCzIaLm1vdGlmLkZvbnRGYW1pbHlUaHVtYm5haWxSCXRodW1ibmFpbBpRCgVJbWFnZRIU'
    'CgV3aWR0aBgBIAEoBVIFd2lkdGgSFgoGaGVpZ2h0GAIgASgFUgZoZWlnaHQSGgoIbWltZVR5cG'
    'UYAyABKAlSCG1pbWVUeXBlQgYKBGtpbmQ=');

@$core.Deprecated('Use assetLicenseDescriptor instead')
const AssetLicense$json = {
  '1': 'AssetLicense',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 11, '6': '.motif.Hash', '10': 'hash'},
    {'1': 'descriptor', '3': 2, '4': 1, '5': 9, '10': 'descriptor'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'body', '3': 4, '4': 1, '5': 9, '10': 'body'},
  ],
};

/// Descriptor for `AssetLicense`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetLicenseDescriptor = $convert.base64Decode(
    'CgxBc3NldExpY2Vuc2USHwoEaGFzaBgBIAEoCzILLm1vdGlmLkhhc2hSBGhhc2gSHgoKZGVzY3'
    'JpcHRvchgCIAEoCVIKZGVzY3JpcHRvchISCgRraW5kGAMgASgJUgRraW5kEhIKBGJvZHkYBCAB'
    'KAlSBGJvZHk=');

@$core.Deprecated('Use fontFamilyThumbnailDescriptor instead')
const FontFamilyThumbnail$json = {
  '1': 'FontFamilyThumbnail',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 11, '6': '.motif.Path', '10': 'path'},
    {'1': 'width', '3': 2, '4': 1, '5': 2, '10': 'width'},
    {'1': 'height', '3': 3, '4': 1, '5': 2, '10': 'height'},
  ],
};

/// Descriptor for `FontFamilyThumbnail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fontFamilyThumbnailDescriptor = $convert.base64Decode(
    'ChNGb250RmFtaWx5VGh1bWJuYWlsEh8KBHBhdGgYASABKAsyCy5tb3RpZi5QYXRoUgRwYXRoEh'
    'QKBXdpZHRoGAIgASgCUgV3aWR0aBIWCgZoZWlnaHQYAyABKAJSBmhlaWdodA==');

@$core.Deprecated('Use fontFileDescriptor instead')
const FontFile$json = {
  '1': 'FontFile',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 11, '6': '.motif.Hash', '10': 'hash'},
    {'1': 'size', '3': 2, '4': 1, '5': 5, '10': 'size'},
    {
      '1': 'faces',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.motif.FontFace',
      '10': 'faces'
    },
  ],
};

/// Descriptor for `FontFile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fontFileDescriptor = $convert.base64Decode(
    'CghGb250RmlsZRIfCgRoYXNoGAEgASgLMgsubW90aWYuSGFzaFIEaGFzaBISCgRzaXplGAIgAS'
    'gFUgRzaXplEiUKBWZhY2VzGAMgAygLMg8ubW90aWYuRm9udEZhY2VSBWZhY2Vz');

@$core.Deprecated('Use fontFaceDescriptor instead')
const FontFace$json = {
  '1': 'FontFace',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
    {'1': 'family', '3': 2, '4': 1, '5': 9, '10': 'family'},
    {'1': 'weight', '3': 3, '4': 1, '5': 5, '10': 'weight'},
    {'1': 'width', '3': 4, '4': 1, '5': 5, '10': 'width'},
    {'1': 'slant', '3': 5, '4': 1, '5': 5, '10': 'slant'},
  ],
};

/// Descriptor for `FontFace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fontFaceDescriptor = $convert.base64Decode(
    'CghGb250RmFjZRIUCgVpbmRleBgBIAEoBVIFaW5kZXgSFgoGZmFtaWx5GAIgASgJUgZmYW1pbH'
    'kSFgoGd2VpZ2h0GAMgASgFUgZ3ZWlnaHQSFAoFd2lkdGgYBCABKAVSBXdpZHRoEhQKBXNsYW50'
    'GAUgASgFUgVzbGFudA==');

@$core.Deprecated('Use fontCatalogDescriptor instead')
const FontCatalog$json = {
  '1': 'FontCatalog',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.FontCatalog.Entry',
      '10': 'entries'
    },
  ],
  '3': [FontCatalog_Entry$json],
};

@$core.Deprecated('Use fontCatalogDescriptor instead')
const FontCatalog_Entry$json = {
  '1': 'Entry',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 11, '6': '.motif.Hash', '10': 'hash'},
    {'1': 'asset', '3': 2, '4': 1, '5': 11, '6': '.motif.Asset', '10': 'asset'},
  ],
};

/// Descriptor for `FontCatalog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fontCatalogDescriptor = $convert.base64Decode(
    'CgtGb250Q2F0YWxvZxIyCgdlbnRyaWVzGAEgAygLMhgubW90aWYuRm9udENhdGFsb2cuRW50cn'
    'lSB2VudHJpZXMaTAoFRW50cnkSHwoEaGFzaBgBIAEoCzILLm1vdGlmLkhhc2hSBGhhc2gSIgoF'
    'YXNzZXQYAiABKAsyDC5tb3RpZi5Bc3NldFIFYXNzZXQ=');

@$core.Deprecated('Use licenseBundleDescriptor instead')
const LicenseBundle$json = {
  '1': 'LicenseBundle',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.LicenseBundle.Entry',
      '10': 'entries'
    },
  ],
  '3': [LicenseBundle_Entry$json],
};

@$core.Deprecated('Use licenseBundleDescriptor instead')
const LicenseBundle_Entry$json = {
  '1': 'Entry',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 11, '6': '.motif.Hash', '10': 'hash'},
    {
      '1': 'license',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.AssetLicense',
      '10': 'license'
    },
  ],
};

/// Descriptor for `LicenseBundle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List licenseBundleDescriptor = $convert.base64Decode(
    'Cg1MaWNlbnNlQnVuZGxlEjQKB2VudHJpZXMYASADKAsyGi5tb3RpZi5MaWNlbnNlQnVuZGxlLk'
    'VudHJ5UgdlbnRyaWVzGlcKBUVudHJ5Eh8KBGhhc2gYASABKAsyCy5tb3RpZi5IYXNoUgRoYXNo'
    'Ei0KB2xpY2Vuc2UYAiABKAsyEy5tb3RpZi5Bc3NldExpY2Vuc2VSB2xpY2Vuc2U=');
