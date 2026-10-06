// This is a generated file - do not edit.
//
// Generated from sync/sync/sync.proto.

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

@$core.Deprecated('Use sceneInfoDescriptor instead')
const SceneInfo$json = {
  '1': 'SceneInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'updated_at', '3': 3, '4': 1, '5': 3, '10': 'updatedAt'},
    {'1': 'managed', '3': 4, '4': 1, '5': 8, '10': 'managed'},
  ],
};

/// Descriptor for `SceneInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sceneInfoDescriptor = $convert.base64Decode(
    'CglTY2VuZUluZm8SDgoCaWQYASABKAlSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIdCgp1cG'
    'RhdGVkX2F0GAMgASgDUgl1cGRhdGVkQXQSGAoHbWFuYWdlZBgEIAEoCFIHbWFuYWdlZA==');

@$core.Deprecated('Use clientDescriptor instead')
const Client$json = {
  '1': 'Client',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `Client`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDescriptor =
    $convert.base64Decode('CgZDbGllbnQSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use listScenesResponseDescriptor instead')
const ListScenesResponse$json = {
  '1': 'ListScenesResponse',
  '2': [
    {
      '1': 'scenes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.SceneInfo',
      '10': 'scenes'
    },
  ],
};

/// Descriptor for `ListScenesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listScenesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0U2NlbmVzUmVzcG9uc2USKAoGc2NlbmVzGAEgAygLMhAubW90aWYuU2NlbmVJbmZvUg'
    'ZzY2VuZXM=');

@$core.Deprecated('Use createSceneRequestDescriptor instead')
const CreateSceneRequest$json = {
  '1': 'CreateSceneRequest',
  '2': [
    {
      '1': 'program',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Program',
      '9': 0,
      '10': 'program',
      '17': true
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'title', '17': true},
  ],
  '8': [
    {'1': '_program'},
    {'1': '_title'},
  ],
};

/// Descriptor for `CreateSceneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createSceneRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVTY2VuZVJlcXVlc3QSLQoHcHJvZ3JhbRgBIAEoCzIOLm1vdGlmLlByb2dyYW1IAF'
    'IHcHJvZ3JhbYgBARIZCgV0aXRsZRgCIAEoCUgBUgV0aXRsZYgBAUIKCghfcHJvZ3JhbUIICgZf'
    'dGl0bGU=');

@$core.Deprecated('Use createSceneResponseDescriptor instead')
const CreateSceneResponse$json = {
  '1': 'CreateSceneResponse',
  '2': [
    {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.SceneInfo',
      '10': 'info'
    },
    {
      '1': 'program',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Program',
      '10': 'program'
    },
  ],
};

/// Descriptor for `CreateSceneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createSceneResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVTY2VuZVJlc3BvbnNlEiQKBGluZm8YASABKAsyEC5tb3RpZi5TY2VuZUluZm9SBG'
    'luZm8SKAoHcHJvZ3JhbRgCIAEoCzIOLm1vdGlmLlByb2dyYW1SB3Byb2dyYW0=');

@$core.Deprecated('Use getSceneRequestDescriptor instead')
const GetSceneRequest$json = {
  '1': 'GetSceneRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetSceneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSceneRequestDescriptor =
    $convert.base64Decode('Cg9HZXRTY2VuZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use getSceneResponseDescriptor instead')
const GetSceneResponse$json = {
  '1': 'GetSceneResponse',
  '2': [
    {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.SceneInfo',
      '10': 'info'
    },
    {
      '1': 'program',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Program',
      '10': 'program'
    },
  ],
};

/// Descriptor for `GetSceneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSceneResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTY2VuZVJlc3BvbnNlEiQKBGluZm8YASABKAsyEC5tb3RpZi5TY2VuZUluZm9SBGluZm'
    '8SKAoHcHJvZ3JhbRgCIAEoCzIOLm1vdGlmLlByb2dyYW1SB3Byb2dyYW0=');

@$core.Deprecated('Use clientPresenceDescriptor instead')
const ClientPresence$json = {
  '1': 'ClientPresence',
  '2': [
    {
      '1': 'client',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Client',
      '10': 'client'
    },
    {
      '1': 'pointer_position',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'pointerPosition',
      '17': true
    },
    {
      '1': 'pointer_type',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'pointerType',
      '17': true
    },
  ],
  '8': [
    {'1': '_pointer_position'},
    {'1': '_pointer_type'},
  ],
};

/// Descriptor for `ClientPresence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientPresenceDescriptor = $convert.base64Decode(
    'Cg5DbGllbnRQcmVzZW5jZRIlCgZjbGllbnQYASABKAsyDS5tb3RpZi5DbGllbnRSBmNsaWVudB'
    'I7ChBwb2ludGVyX3Bvc2l0aW9uGAIgASgLMgsubW90aWYuVmVjMkgAUg9wb2ludGVyUG9zaXRp'
    'b26IAQESJgoMcG9pbnRlcl90eXBlGAMgASgJSAFSC3BvaW50ZXJUeXBliAEBQhMKEV9wb2ludG'
    'VyX3Bvc2l0aW9uQg8KDV9wb2ludGVyX3R5cGU=');

@$core.Deprecated('Use clientDeltaDescriptor instead')
const ClientDelta$json = {
  '1': 'ClientDelta',
  '2': [
    {
      '1': 'delta',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramDelta',
      '10': 'delta'
    },
    {
      '1': 'client',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Client',
      '10': 'client'
    },
  ],
};

/// Descriptor for `ClientDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDeltaDescriptor = $convert.base64Decode(
    'CgtDbGllbnREZWx0YRIpCgVkZWx0YRgBIAEoCzITLm1vdGlmLlByb2dyYW1EZWx0YVIFZGVsdG'
    'ESJQoGY2xpZW50GAIgASgLMg0ubW90aWYuQ2xpZW50UgZjbGllbnQ=');

@$core.Deprecated('Use sceneInfoUpdateDescriptor instead')
const SceneInfoUpdate$json = {
  '1': 'SceneInfoUpdate',
  '2': [
    {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.SceneInfo',
      '10': 'info'
    },
  ],
};

/// Descriptor for `SceneInfoUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sceneInfoUpdateDescriptor = $convert.base64Decode(
    'Cg9TY2VuZUluZm9VcGRhdGUSJAoEaW5mbxgBIAEoCzIQLm1vdGlmLlNjZW5lSW5mb1IEaW5mbw'
    '==');

@$core.Deprecated('Use snapshotDescriptor instead')
const Snapshot$json = {
  '1': 'Snapshot',
  '2': [
    {
      '1': 'program',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Program',
      '10': 'program'
    },
    {
      '1': 'clients',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.ClientPresence',
      '10': 'clients'
    },
  ],
};

/// Descriptor for `Snapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List snapshotDescriptor = $convert.base64Decode(
    'CghTbmFwc2hvdBIoCgdwcm9ncmFtGAEgASgLMg4ubW90aWYuUHJvZ3JhbVIHcHJvZ3JhbRIvCg'
    'djbGllbnRzGAIgAygLMhUubW90aWYuQ2xpZW50UHJlc2VuY2VSB2NsaWVudHM=');

@$core.Deprecated('Use clientEventDescriptor instead')
const ClientEvent$json = {
  '1': 'ClientEvent',
  '2': [
    {
      '1': 'presence',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ClientPresence',
      '9': 0,
      '10': 'presence'
    },
    {
      '1': 'delta',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ClientDelta',
      '9': 0,
      '10': 'delta'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ClientEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientEventDescriptor = $convert.base64Decode(
    'CgtDbGllbnRFdmVudBIzCghwcmVzZW5jZRgBIAEoCzIVLm1vdGlmLkNsaWVudFByZXNlbmNlSA'
    'BSCHByZXNlbmNlEioKBWRlbHRhGAIgASgLMhIubW90aWYuQ2xpZW50RGVsdGFIAFIFZGVsdGFC'
    'BwoFZXZlbnQ=');

@$core.Deprecated('Use serverEventDescriptor instead')
const ServerEvent$json = {
  '1': 'ServerEvent',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Snapshot',
      '9': 0,
      '10': 'snapshot'
    },
    {
      '1': 'presence',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ClientPresence',
      '9': 0,
      '10': 'presence'
    },
    {
      '1': 'delta',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ClientDelta',
      '9': 0,
      '10': 'delta'
    },
    {
      '1': 'left',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.Client',
      '9': 0,
      '10': 'left'
    },
    {
      '1': 'scene_info',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.SceneInfoUpdate',
      '9': 0,
      '10': 'sceneInfo'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `ServerEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverEventDescriptor = $convert.base64Decode(
    'CgtTZXJ2ZXJFdmVudBItCghzbmFwc2hvdBgBIAEoCzIPLm1vdGlmLlNuYXBzaG90SABSCHNuYX'
    'BzaG90EjMKCHByZXNlbmNlGAIgASgLMhUubW90aWYuQ2xpZW50UHJlc2VuY2VIAFIIcHJlc2Vu'
    'Y2USKgoFZGVsdGEYAyABKAsyEi5tb3RpZi5DbGllbnREZWx0YUgAUgVkZWx0YRIjCgRsZWZ0GA'
    'QgASgLMg0ubW90aWYuQ2xpZW50SABSBGxlZnQSNwoKc2NlbmVfaW5mbxgFIAEoCzIWLm1vdGlm'
    'LlNjZW5lSW5mb1VwZGF0ZUgAUglzY2VuZUluZm9CBwoFZXZlbnQ=');
