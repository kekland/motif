// This is a generated file - do not edit.
//
// Generated from packages/blueprint/blueprint.proto.

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

@$core.Deprecated('Use nodeIdDescriptor instead')
const NodeId$json = {
  '1': 'NodeId',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 13, '10': 'value'},
  ],
};

/// Descriptor for `NodeId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodeIdDescriptor =
    $convert.base64Decode('CgZOb2RlSWQSFAoFdmFsdWUYASABKA1SBXZhbHVl');

@$core.Deprecated('Use socketRefDescriptor instead')
const SocketRef$json = {
  '1': 'SocketRef',
  '2': [
    {'1': 'node', '3': 1, '4': 1, '5': 11, '6': '.motif.NodeId', '10': 'node'},
    {'1': 'index', '3': 2, '4': 1, '5': 13, '10': 'index'},
  ],
};

/// Descriptor for `SocketRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List socketRefDescriptor = $convert.base64Decode(
    'CglTb2NrZXRSZWYSIQoEbm9kZRgBIAEoCzINLm1vdGlmLk5vZGVJZFIEbm9kZRIUCgVpbmRleB'
    'gCIAEoDVIFaW5kZXg=');

@$core.Deprecated('Use connectionDescriptor instead')
const Connection$json = {
  '1': 'Connection',
  '2': [
    {
      '1': 'output',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.SocketRef',
      '10': 'output'
    },
    {
      '1': 'input',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.SocketRef',
      '10': 'input'
    },
  ],
};

/// Descriptor for `Connection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionDescriptor = $convert.base64Decode(
    'CgpDb25uZWN0aW9uEigKBm91dHB1dBgBIAEoCzIQLm1vdGlmLlNvY2tldFJlZlIGb3V0cHV0Ei'
    'YKBWlucHV0GAIgASgLMhAubW90aWYuU29ja2V0UmVmUgVpbnB1dA==');
