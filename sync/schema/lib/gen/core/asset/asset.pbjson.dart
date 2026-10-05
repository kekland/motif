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

@$core.Deprecated('Use assetManifestDescriptor instead')
const AssetManifest$json = {
  '1': 'AssetManifest',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.AssetManifest.EntriesEntry',
      '10': 'entries'
    },
  ],
  '3': [AssetManifest_EntriesEntry$json],
};

@$core.Deprecated('Use assetManifestDescriptor instead')
const AssetManifest_EntriesEntry$json = {
  '1': 'EntriesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.motif.Asset', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AssetManifest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetManifestDescriptor = $convert.base64Decode(
    'Cg1Bc3NldE1hbmlmZXN0EjsKB2VudHJpZXMYASADKAsyIS5tb3RpZi5Bc3NldE1hbmlmZXN0Lk'
    'VudHJpZXNFbnRyeVIHZW50cmllcxpICgxFbnRyaWVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkS'
    'IgoFdmFsdWUYAiABKAsyDC5tb3RpZi5Bc3NldFIFdmFsdWU6AjgB');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
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
    {'1': 'family', '3': 1, '4': 1, '5': 9, '10': 'family'},
    {'1': 'license', '3': 2, '4': 1, '5': 9, '10': 'license'},
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

@$core.Deprecated('Use assetDescriptor instead')
const Asset_Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 5, '10': 'height'},
    {'1': 'mime_type', '3': 3, '4': 1, '5': 9, '10': 'mimeType'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBISCgRoYXNoGAEgASgJUgRoYXNoEhIKBHNpemUYAiABKAVSBHNpemUSJwoEZm9udB'
    'gKIAEoCzIRLm1vdGlmLkFzc2V0LkZvbnRIAFIEZm9udBIqCgVpbWFnZRgLIAEoCzISLm1vdGlm'
    'LkFzc2V0LkltYWdlSABSBWltYWdlGl8KBEZvbnQSFgoGZmFtaWx5GAEgASgJUgZmYW1pbHkSGA'
    'oHbGljZW5zZRgCIAEoCVIHbGljZW5zZRIlCgVmYWNlcxgDIAMoCzIPLm1vdGlmLkZvbnRGYWNl'
    'UgVmYWNlcxpSCgVJbWFnZRIUCgV3aWR0aBgBIAEoBVIFd2lkdGgSFgoGaGVpZ2h0GAIgASgFUg'
    'ZoZWlnaHQSGwoJbWltZV90eXBlGAMgASgJUghtaW1lVHlwZUIGCgRraW5k');

@$core.Deprecated('Use fontFaceDescriptor instead')
const FontFace$json = {
  '1': 'FontFace',
  '2': [
    {'1': 'family', '3': 1, '4': 1, '5': 9, '10': 'family'},
    {'1': 'index', '3': 2, '4': 1, '5': 5, '10': 'index'},
    {'1': 'weight', '3': 3, '4': 1, '5': 5, '10': 'weight'},
    {'1': 'width', '3': 4, '4': 1, '5': 5, '10': 'width'},
    {'1': 'slant', '3': 5, '4': 1, '5': 5, '10': 'slant'},
    {
      '1': 'thumbnail',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.FontFace.Thumbnail',
      '9': 0,
      '10': 'thumbnail',
      '17': true
    },
  ],
  '3': [FontFace_Thumbnail$json],
  '8': [
    {'1': '_thumbnail'},
  ],
};

@$core.Deprecated('Use fontFaceDescriptor instead')
const FontFace_Thumbnail$json = {
  '1': 'Thumbnail',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 11, '6': '.skia.Path', '10': 'path'},
    {'1': 'width', '3': 2, '4': 1, '5': 2, '10': 'width'},
    {'1': 'height', '3': 3, '4': 1, '5': 2, '10': 'height'},
  ],
};

/// Descriptor for `FontFace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fontFaceDescriptor = $convert.base64Decode(
    'CghGb250RmFjZRIWCgZmYW1pbHkYASABKAlSBmZhbWlseRIUCgVpbmRleBgCIAEoBVIFaW5kZX'
    'gSFgoGd2VpZ2h0GAMgASgFUgZ3ZWlnaHQSFAoFd2lkdGgYBCABKAVSBXdpZHRoEhQKBXNsYW50'
    'GAUgASgFUgVzbGFudBI8Cgl0aHVtYm5haWwYBiABKAsyGS5tb3RpZi5Gb250RmFjZS5UaHVtYm'
    '5haWxIAFIJdGh1bWJuYWlsiAEBGlkKCVRodW1ibmFpbBIeCgRwYXRoGAEgASgLMgouc2tpYS5Q'
    'YXRoUgRwYXRoEhQKBXdpZHRoGAIgASgCUgV3aWR0aBIWCgZoZWlnaHQYAyABKAJSBmhlaWdodE'
    'IMCgpfdGh1bWJuYWls');

@$core.Deprecated('Use assetLicenseDescriptor instead')
const AssetLicense$json = {
  '1': 'AssetLicense',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
    {'1': 'descriptor', '3': 2, '4': 1, '5': 9, '10': 'descriptor'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'body', '3': 4, '4': 1, '5': 9, '10': 'body'},
  ],
};

/// Descriptor for `AssetLicense`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetLicenseDescriptor = $convert.base64Decode(
    'CgxBc3NldExpY2Vuc2USEgoEaGFzaBgBIAEoCVIEaGFzaBIeCgpkZXNjcmlwdG9yGAIgASgJUg'
    'pkZXNjcmlwdG9yEhIKBGtpbmQYAyABKAlSBGtpbmQSEgoEYm9keRgEIAEoCVIEYm9keQ==');

@$core.Deprecated('Use licenseBundleDescriptor instead')
const LicenseBundle$json = {
  '1': 'LicenseBundle',
  '2': [
    {
      '1': 'licenses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.LicenseBundle.LicensesEntry',
      '10': 'licenses'
    },
  ],
  '3': [LicenseBundle_LicensesEntry$json],
};

@$core.Deprecated('Use licenseBundleDescriptor instead')
const LicenseBundle_LicensesEntry$json = {
  '1': 'LicensesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.AssetLicense',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `LicenseBundle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List licenseBundleDescriptor = $convert.base64Decode(
    'Cg1MaWNlbnNlQnVuZGxlEj4KCGxpY2Vuc2VzGAEgAygLMiIubW90aWYuTGljZW5zZUJ1bmRsZS'
    '5MaWNlbnNlc0VudHJ5UghsaWNlbnNlcxpQCg1MaWNlbnNlc0VudHJ5EhAKA2tleRgBIAEoCVID'
    'a2V5EikKBXZhbHVlGAIgASgLMhMubW90aWYuQXNzZXRMaWNlbnNlUgV2YWx1ZToCOAE=');
