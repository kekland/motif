// This is a generated file - do not edit.
//
// Generated from schema.proto.

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

@$core.Deprecated('Use serverEventDescriptor instead')
const ServerEvent$json = {
  '1': 'ServerEvent',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.Scene',
      '9': 0,
      '10': 'snapshot'
    },
    {
      '1': 'delta',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.DeltaBatch',
      '9': 0,
      '10': 'delta'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ServerEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverEventDescriptor = $convert.base64Decode(
    'CgtTZXJ2ZXJFdmVudBIkCghzbmFwc2hvdBgBIAEoCzIGLlNjZW5lSABSCHNuYXBzaG90EiMKBW'
    'RlbHRhGAIgASgLMgsuRGVsdGFCYXRjaEgAUgVkZWx0YUIHCgVldmVudA==');

@$core.Deprecated('Use anchorDescriptor instead')
const Anchor$json = {
  '1': 'Anchor',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'start'},
    {
      '1': 'after',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.StatementId',
      '9': 0,
      '10': 'after'
    },
    {
      '1': 'at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.StatementId',
      '9': 0,
      '10': 'at'
    },
    {'1': 'end', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'end'},
  ],
  '8': [
    {'1': 'anchor'},
  ],
};

/// Descriptor for `Anchor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anchorDescriptor = $convert.base64Decode(
    'CgZBbmNob3ISFgoFc3RhcnQYASABKAhIAFIFc3RhcnQSJAoFYWZ0ZXIYAiABKAsyDC5TdGF0ZW'
    '1lbnRJZEgAUgVhZnRlchIeCgJhdBgDIAEoCzIMLlN0YXRlbWVudElkSABSAmF0EhIKA2VuZBgE'
    'IAEoCEgAUgNlbmRCCAoGYW5jaG9y');

@$core.Deprecated('Use programDeltaDescriptor instead')
const ProgramDelta$json = {
  '1': 'ProgramDelta',
  '2': [
    {'1': 'anchor', '3': 1, '4': 1, '5': 11, '6': '.Anchor', '10': 'anchor'},
    {
      '1': 'removed',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.StatementId',
      '10': 'removed'
    },
    {
      '1': 'inserted',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.Statement',
      '10': 'inserted'
    },
  ],
};

/// Descriptor for `ProgramDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programDeltaDescriptor = $convert.base64Decode(
    'CgxQcm9ncmFtRGVsdGESHwoGYW5jaG9yGAEgASgLMgcuQW5jaG9yUgZhbmNob3ISJgoHcmVtb3'
    'ZlZBgCIAMoCzIMLlN0YXRlbWVudElkUgdyZW1vdmVkEiYKCGluc2VydGVkGAMgAygLMgouU3Rh'
    'dGVtZW50UghpbnNlcnRlZA==');

@$core.Deprecated('Use deltaDescriptor instead')
const Delta$json = {
  '1': 'Delta',
  '2': [
    {
      '1': 'program',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ProgramDelta',
      '9': 0,
      '10': 'program'
    },
  ],
  '8': [
    {'1': 'delta'},
  ],
};

/// Descriptor for `Delta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deltaDescriptor = $convert.base64Decode(
    'CgVEZWx0YRIpCgdwcm9ncmFtGAEgASgLMg0uUHJvZ3JhbURlbHRhSABSB3Byb2dyYW1CBwoFZG'
    'VsdGE=');

@$core.Deprecated('Use deltaBatchDescriptor instead')
const DeltaBatch$json = {
  '1': 'DeltaBatch',
  '2': [
    {'1': 'deltas', '3': 1, '4': 3, '5': 11, '6': '.Delta', '10': 'deltas'},
  ],
};

/// Descriptor for `DeltaBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deltaBatchDescriptor = $convert.base64Decode(
    'CgpEZWx0YUJhdGNoEh4KBmRlbHRhcxgBIAMoCzIGLkRlbHRhUgZkZWx0YXM=');
