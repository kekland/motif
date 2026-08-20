// This is a generated file - do not edit.
//
// Generated from scene.proto.

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

@$core.Deprecated('Use layoutAlignDescriptor instead')
const LayoutAlign$json = {
  '1': 'LayoutAlign',
  '2': [
    {'1': 'LAYOUT_ALIGN_START', '2': 0},
    {'1': 'LAYOUT_ALIGN_CENTER', '2': 1},
    {'1': 'LAYOUT_ALIGN_END', '2': 2},
  ],
};

/// Descriptor for `LayoutAlign`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List layoutAlignDescriptor = $convert.base64Decode(
    'CgtMYXlvdXRBbGlnbhIWChJMQVlPVVRfQUxJR05fU1RBUlQQABIXChNMQVlPVVRfQUxJR05fQ0'
    'VOVEVSEAESFAoQTEFZT1VUX0FMSUdOX0VORBAC');

@$core.Deprecated('Use layoutJustifyDescriptor instead')
const LayoutJustify$json = {
  '1': 'LayoutJustify',
  '2': [
    {'1': 'LAYOUT_JUSTIFY_START', '2': 0},
    {'1': 'LAYOUT_JUSTIFY_CENTER', '2': 1},
    {'1': 'LAYOUT_JUSTIFY_END', '2': 2},
    {'1': 'LAYOUT_JUSTIFY_SPACE_BETWEEN', '2': 3},
  ],
};

/// Descriptor for `LayoutJustify`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List layoutJustifyDescriptor = $convert.base64Decode(
    'Cg1MYXlvdXRKdXN0aWZ5EhgKFExBWU9VVF9KVVNUSUZZX1NUQVJUEAASGQoVTEFZT1VUX0pVU1'
    'RJRllfQ0VOVEVSEAESFgoSTEFZT1VUX0pVU1RJRllfRU5EEAISIAocTEFZT1VUX0pVU1RJRllf'
    'U1BBQ0VfQkVUV0VFThAD');

@$core.Deprecated('Use flexDirectionDescriptor instead')
const FlexDirection$json = {
  '1': 'FlexDirection',
  '2': [
    {'1': 'FLEX_DIRECTION_ROW', '2': 0},
    {'1': 'FLEX_DIRECTION_COLUMN', '2': 1},
  ],
};

/// Descriptor for `FlexDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List flexDirectionDescriptor = $convert.base64Decode(
    'Cg1GbGV4RGlyZWN0aW9uEhYKEkZMRVhfRElSRUNUSU9OX1JPVxAAEhkKFUZMRVhfRElSRUNUSU'
    '9OX0NPTFVNThAB');

@$core.Deprecated('Use sceneDescriptor instead')
const Scene$json = {
  '1': 'Scene',
  '2': [
    {'1': 'program', '3': 1, '4': 1, '5': 11, '6': '.Program', '10': 'program'},
  ],
};

/// Descriptor for `Scene`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sceneDescriptor = $convert.base64Decode(
    'CgVTY2VuZRIiCgdwcm9ncmFtGAEgASgLMgguUHJvZ3JhbVIHcHJvZ3JhbQ==');

@$core.Deprecated('Use programDescriptor instead')
const Program$json = {
  '1': 'Program',
  '2': [
    {
      '1': 'statements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.Statement',
      '10': 'statements'
    },
  ],
};

/// Descriptor for `Program`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programDescriptor = $convert.base64Decode(
    'CgdQcm9ncmFtEioKCnN0YXRlbWVudHMYASADKAsyCi5TdGF0ZW1lbnRSCnN0YXRlbWVudHM=');

@$core.Deprecated('Use statementDescriptor instead')
const Statement$json = {
  '1': 'Statement',
  '2': [
    {
      '1': 'frame',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.FrameStatement',
      '9': 0,
      '10': 'frame'
    },
    {
      '1': 'vertex',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.VertexStatement',
      '9': 0,
      '10': 'vertex'
    },
    {
      '1': 'edge',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.EdgeStatement',
      '9': 0,
      '10': 'edge'
    },
    {
      '1': 'face',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.FaceStatement',
      '9': 0,
      '10': 'face'
    },
    {
      '1': 'cutEdge',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.CutEdgeStatement',
      '9': 0,
      '10': 'cutEdge'
    },
    {
      '1': 'glueVertices',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.GlueVerticesStatement',
      '9': 0,
      '10': 'glueVertices'
    },
    {
      '1': 'circle',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.CircleStatement',
      '9': 0,
      '10': 'circle'
    },
    {
      '1': 'rectangle',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.RectangleStatement',
      '9': 0,
      '10': 'rectangle'
    },
    {
      '1': 'triangle',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.TriangleStatement',
      '9': 0,
      '10': 'triangle'
    },
    {
      '1': 'container',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.ContainerStatement',
      '9': 0,
      '10': 'container'
    },
  ],
  '8': [
    {'1': 'statement'},
  ],
};

/// Descriptor for `Statement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementDescriptor = $convert.base64Decode(
    'CglTdGF0ZW1lbnQSJwoFZnJhbWUYASABKAsyDy5GcmFtZVN0YXRlbWVudEgAUgVmcmFtZRIqCg'
    'Z2ZXJ0ZXgYAiABKAsyEC5WZXJ0ZXhTdGF0ZW1lbnRIAFIGdmVydGV4EiQKBGVkZ2UYAyABKAsy'
    'Di5FZGdlU3RhdGVtZW50SABSBGVkZ2USJAoEZmFjZRgEIAEoCzIOLkZhY2VTdGF0ZW1lbnRIAF'
    'IEZmFjZRItCgdjdXRFZGdlGAUgASgLMhEuQ3V0RWRnZVN0YXRlbWVudEgAUgdjdXRFZGdlEjwK'
    'DGdsdWVWZXJ0aWNlcxgGIAEoCzIWLkdsdWVWZXJ0aWNlc1N0YXRlbWVudEgAUgxnbHVlVmVydG'
    'ljZXMSKgoGY2lyY2xlGAcgASgLMhAuQ2lyY2xlU3RhdGVtZW50SABSBmNpcmNsZRIzCglyZWN0'
    'YW5nbGUYCCABKAsyEy5SZWN0YW5nbGVTdGF0ZW1lbnRIAFIJcmVjdGFuZ2xlEjAKCHRyaWFuZ2'
    'xlGAkgASgLMhIuVHJpYW5nbGVTdGF0ZW1lbnRIAFIIdHJpYW5nbGUSMwoJY29udGFpbmVyGAog'
    'ASgLMhMuQ29udGFpbmVyU3RhdGVtZW50SABSCWNvbnRhaW5lckILCglzdGF0ZW1lbnQ=');

@$core.Deprecated('Use frameStatementDescriptor instead')
const FrameStatement$json = {
  '1': 'FrameStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Ref',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {
      '1': 'transform',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.Mat4',
      '10': 'transform'
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `FrameStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List frameStatementDescriptor = $convert.base64Decode(
    'Cg5GcmFtZVN0YXRlbWVudBIcCgJpZBgBIAEoCzIMLlN0YXRlbWVudElkUgJpZBIhCgZwYXJlbn'
    'QYAiABKAsyBC5SZWZIAFIGcGFyZW50iAEBEiMKCXRyYW5zZm9ybRgDIAEoCzIFLk1hdDRSCXRy'
    'YW5zZm9ybUIJCgdfcGFyZW50');

@$core.Deprecated('Use vertexStatementDescriptor instead')
const VertexStatement$json = {
  '1': 'VertexStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Ref',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {'1': 'position', '3': 3, '4': 1, '5': 11, '6': '.Vec2', '10': 'position'},
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `VertexStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vertexStatementDescriptor = $convert.base64Decode(
    'Cg9WZXJ0ZXhTdGF0ZW1lbnQSHAoCaWQYASABKAsyDC5TdGF0ZW1lbnRJZFICaWQSIQoGcGFyZW'
    '50GAIgASgLMgQuUmVmSABSBnBhcmVudIgBARIhCghwb3NpdGlvbhgDIAEoCzIFLlZlYzJSCHBv'
    'c2l0aW9uQgkKB19wYXJlbnQ=');

@$core.Deprecated('Use edgeStatementDescriptor instead')
const EdgeStatement$json = {
  '1': 'EdgeStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Ref',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {'1': 'start', '3': 3, '4': 1, '5': 11, '6': '.Ref', '10': 'start'},
    {'1': 'end', '3': 4, '4': 1, '5': 11, '6': '.Ref', '10': 'end'},
    {
      '1': 'startTangent',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.Vec2',
      '9': 1,
      '10': 'startTangent',
      '17': true
    },
    {
      '1': 'endTangent',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.Vec2',
      '9': 2,
      '10': 'endTangent',
      '17': true
    },
    {'1': 'style', '3': 7, '4': 1, '5': 11, '6': '.EdgeStyle', '10': 'style'},
  ],
  '8': [
    {'1': '_parent'},
    {'1': '_startTangent'},
    {'1': '_endTangent'},
  ],
};

/// Descriptor for `EdgeStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeStatementDescriptor = $convert.base64Decode(
    'Cg1FZGdlU3RhdGVtZW50EhwKAmlkGAEgASgLMgwuU3RhdGVtZW50SWRSAmlkEiEKBnBhcmVudB'
    'gCIAEoCzIELlJlZkgAUgZwYXJlbnSIAQESGgoFc3RhcnQYAyABKAsyBC5SZWZSBXN0YXJ0EhYK'
    'A2VuZBgEIAEoCzIELlJlZlIDZW5kEi4KDHN0YXJ0VGFuZ2VudBgFIAEoCzIFLlZlYzJIAVIMc3'
    'RhcnRUYW5nZW50iAEBEioKCmVuZFRhbmdlbnQYBiABKAsyBS5WZWMySAJSCmVuZFRhbmdlbnSI'
    'AQESIAoFc3R5bGUYByABKAsyCi5FZGdlU3R5bGVSBXN0eWxlQgkKB19wYXJlbnRCDwoNX3N0YX'
    'J0VGFuZ2VudEINCgtfZW5kVGFuZ2VudA==');

@$core.Deprecated('Use faceStatementDescriptor instead')
const FaceStatement$json = {
  '1': 'FaceStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Ref',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {
      '1': 'outer',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.FaceStatement.Cycle',
      '10': 'outer'
    },
    {
      '1': 'holes',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.FaceStatement.Cycle',
      '10': 'holes'
    },
    {'1': 'style', '3': 5, '4': 1, '5': 11, '6': '.FaceStyle', '10': 'style'},
  ],
  '3': [FaceStatement_Cycle$json],
  '8': [
    {'1': '_parent'},
  ],
};

@$core.Deprecated('Use faceStatementDescriptor instead')
const FaceStatement_Cycle$json = {
  '1': 'Cycle',
  '2': [
    {'1': 'edges', '3': 1, '4': 3, '5': 11, '6': '.Ref', '10': 'edges'},
  ],
};

/// Descriptor for `FaceStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List faceStatementDescriptor = $convert.base64Decode(
    'Cg1GYWNlU3RhdGVtZW50EhwKAmlkGAEgASgLMgwuU3RhdGVtZW50SWRSAmlkEiEKBnBhcmVudB'
    'gCIAEoCzIELlJlZkgAUgZwYXJlbnSIAQESKgoFb3V0ZXIYAyABKAsyFC5GYWNlU3RhdGVtZW50'
    'LkN5Y2xlUgVvdXRlchIqCgVob2xlcxgEIAMoCzIULkZhY2VTdGF0ZW1lbnQuQ3ljbGVSBWhvbG'
    'VzEiAKBXN0eWxlGAUgASgLMgouRmFjZVN0eWxlUgVzdHlsZRojCgVDeWNsZRIaCgVlZGdlcxgB'
    'IAMoCzIELlJlZlIFZWRnZXNCCQoHX3BhcmVudA==');

@$core.Deprecated('Use cutEdgeStatementDescriptor instead')
const CutEdgeStatement$json = {
  '1': 'CutEdgeStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'target', '3': 2, '4': 1, '5': 11, '6': '.Ref', '10': 'target'},
    {'1': 't', '3': 3, '4': 1, '5': 1, '10': 't'},
  ],
};

/// Descriptor for `CutEdgeStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cutEdgeStatementDescriptor = $convert.base64Decode(
    'ChBDdXRFZGdlU3RhdGVtZW50EhwKAmlkGAEgASgLMgwuU3RhdGVtZW50SWRSAmlkEhwKBnRhcm'
    'dldBgCIAEoCzIELlJlZlIGdGFyZ2V0EgwKAXQYAyABKAFSAXQ=');

@$core.Deprecated('Use glueVerticesStatementDescriptor instead')
const GlueVerticesStatement$json = {
  '1': 'GlueVerticesStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'targets', '3': 2, '4': 3, '5': 11, '6': '.Ref', '10': 'targets'},
    {
      '1': 'position',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.GlueVerticesStatement.Position',
      '10': 'position'
    },
  ],
  '4': [GlueVerticesStatement_Position$json],
};

@$core.Deprecated('Use glueVerticesStatementDescriptor instead')
const GlueVerticesStatement_Position$json = {
  '1': 'Position',
  '2': [
    {'1': 'GLUE_VERTICES_STATEMENT_POSITION_CENTROID', '2': 0},
    {'1': 'GLUE_VERTICES_STATEMENT_POSITION_FIRST', '2': 1},
  ],
};

/// Descriptor for `GlueVerticesStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List glueVerticesStatementDescriptor = $convert.base64Decode(
    'ChVHbHVlVmVydGljZXNTdGF0ZW1lbnQSHAoCaWQYASABKAsyDC5TdGF0ZW1lbnRJZFICaWQSHg'
    'oHdGFyZ2V0cxgCIAMoCzIELlJlZlIHdGFyZ2V0cxI7Cghwb3NpdGlvbhgDIAEoDjIfLkdsdWVW'
    'ZXJ0aWNlc1N0YXRlbWVudC5Qb3NpdGlvblIIcG9zaXRpb24iZQoIUG9zaXRpb24SLQopR0xVRV'
    '9WRVJUSUNFU19TVEFURU1FTlRfUE9TSVRJT05fQ0VOVFJPSUQQABIqCiZHTFVFX1ZFUlRJQ0VT'
    'X1NUQVRFTUVOVF9QT1NJVElPTl9GSVJTVBAB');

@$core.Deprecated('Use circleStatementDescriptor instead')
const CircleStatement$json = {
  '1': 'CircleStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Ref',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {
      '1': 'transform',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.Mat4',
      '10': 'transform'
    },
    {'1': 'size', '3': 4, '4': 1, '5': 11, '6': '.LayoutSize', '10': 'size'},
    {
      '1': 'shape',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.CircleObjectShape',
      '10': 'shape'
    },
    {
      '1': 'edgeStyle',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'faceStyle',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.FaceStyle',
      '10': 'faceStyle'
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `CircleStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List circleStatementDescriptor = $convert.base64Decode(
    'Cg9DaXJjbGVTdGF0ZW1lbnQSHAoCaWQYASABKAsyDC5TdGF0ZW1lbnRJZFICaWQSIQoGcGFyZW'
    '50GAIgASgLMgQuUmVmSABSBnBhcmVudIgBARIjCgl0cmFuc2Zvcm0YAyABKAsyBS5NYXQ0Ugl0'
    'cmFuc2Zvcm0SHwoEc2l6ZRgEIAEoCzILLkxheW91dFNpemVSBHNpemUSKAoFc2hhcGUYBSABKA'
    'syEi5DaXJjbGVPYmplY3RTaGFwZVIFc2hhcGUSKAoJZWRnZVN0eWxlGAYgASgLMgouRWRnZVN0'
    'eWxlUgllZGdlU3R5bGUSKAoJZmFjZVN0eWxlGAcgASgLMgouRmFjZVN0eWxlUglmYWNlU3R5bG'
    'VCCQoHX3BhcmVudA==');

@$core.Deprecated('Use rectangleStatementDescriptor instead')
const RectangleStatement$json = {
  '1': 'RectangleStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Ref',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {
      '1': 'transform',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.Mat4',
      '10': 'transform'
    },
    {'1': 'size', '3': 4, '4': 1, '5': 11, '6': '.LayoutSize', '10': 'size'},
    {
      '1': 'shape',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.RectangleObjectShape',
      '10': 'shape'
    },
    {
      '1': 'edgeStyle',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'faceStyle',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.FaceStyle',
      '10': 'faceStyle'
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `RectangleStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rectangleStatementDescriptor = $convert.base64Decode(
    'ChJSZWN0YW5nbGVTdGF0ZW1lbnQSHAoCaWQYASABKAsyDC5TdGF0ZW1lbnRJZFICaWQSIQoGcG'
    'FyZW50GAIgASgLMgQuUmVmSABSBnBhcmVudIgBARIjCgl0cmFuc2Zvcm0YAyABKAsyBS5NYXQ0'
    'Ugl0cmFuc2Zvcm0SHwoEc2l6ZRgEIAEoCzILLkxheW91dFNpemVSBHNpemUSKwoFc2hhcGUYBS'
    'ABKAsyFS5SZWN0YW5nbGVPYmplY3RTaGFwZVIFc2hhcGUSKAoJZWRnZVN0eWxlGAYgASgLMgou'
    'RWRnZVN0eWxlUgllZGdlU3R5bGUSKAoJZmFjZVN0eWxlGAcgASgLMgouRmFjZVN0eWxlUglmYW'
    'NlU3R5bGVCCQoHX3BhcmVudA==');

@$core.Deprecated('Use triangleStatementDescriptor instead')
const TriangleStatement$json = {
  '1': 'TriangleStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Ref',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {
      '1': 'transform',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.Mat4',
      '10': 'transform'
    },
    {'1': 'size', '3': 4, '4': 1, '5': 11, '6': '.LayoutSize', '10': 'size'},
    {
      '1': 'shape',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.TriangleObjectShape',
      '10': 'shape'
    },
    {
      '1': 'edgeStyle',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'faceStyle',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.FaceStyle',
      '10': 'faceStyle'
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `TriangleStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triangleStatementDescriptor = $convert.base64Decode(
    'ChFUcmlhbmdsZVN0YXRlbWVudBIcCgJpZBgBIAEoCzIMLlN0YXRlbWVudElkUgJpZBIhCgZwYX'
    'JlbnQYAiABKAsyBC5SZWZIAFIGcGFyZW50iAEBEiMKCXRyYW5zZm9ybRgDIAEoCzIFLk1hdDRS'
    'CXRyYW5zZm9ybRIfCgRzaXplGAQgASgLMgsuTGF5b3V0U2l6ZVIEc2l6ZRIqCgVzaGFwZRgFIA'
    'EoCzIULlRyaWFuZ2xlT2JqZWN0U2hhcGVSBXNoYXBlEigKCWVkZ2VTdHlsZRgGIAEoCzIKLkVk'
    'Z2VTdHlsZVIJZWRnZVN0eWxlEigKCWZhY2VTdHlsZRgHIAEoCzIKLkZhY2VTdHlsZVIJZmFjZV'
    'N0eWxlQgkKB19wYXJlbnQ=');

@$core.Deprecated('Use containerStatementDescriptor instead')
const ContainerStatement$json = {
  '1': 'ContainerStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Ref',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {
      '1': 'transform',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.Mat4',
      '10': 'transform'
    },
    {'1': 'size', '3': 4, '4': 1, '5': 11, '6': '.LayoutSize', '10': 'size'},
    {'1': 'shape', '3': 5, '4': 1, '5': 11, '6': '.ObjectShape', '10': 'shape'},
    {
      '1': 'childLayout',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.ChildLayout',
      '10': 'childLayout'
    },
    {
      '1': 'edgeStyle',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'faceStyle',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.FaceStyle',
      '10': 'faceStyle'
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `ContainerStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List containerStatementDescriptor = $convert.base64Decode(
    'ChJDb250YWluZXJTdGF0ZW1lbnQSHAoCaWQYASABKAsyDC5TdGF0ZW1lbnRJZFICaWQSIQoGcG'
    'FyZW50GAIgASgLMgQuUmVmSABSBnBhcmVudIgBARIjCgl0cmFuc2Zvcm0YAyABKAsyBS5NYXQ0'
    'Ugl0cmFuc2Zvcm0SHwoEc2l6ZRgEIAEoCzILLkxheW91dFNpemVSBHNpemUSIgoFc2hhcGUYBS'
    'ABKAsyDC5PYmplY3RTaGFwZVIFc2hhcGUSLgoLY2hpbGRMYXlvdXQYBiABKAsyDC5DaGlsZExh'
    'eW91dFILY2hpbGRMYXlvdXQSKAoJZWRnZVN0eWxlGAcgASgLMgouRWRnZVN0eWxlUgllZGdlU3'
    'R5bGUSKAoJZmFjZVN0eWxlGAggASgLMgouRmFjZVN0eWxlUglmYWNlU3R5bGVCCQoHX3BhcmVu'
    'dA==');

@$core.Deprecated('Use statementIdDescriptor instead')
const StatementId$json = {
  '1': 'StatementId',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `StatementId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementIdDescriptor =
    $convert.base64Decode('CgtTdGF0ZW1lbnRJZBIUCgV2YWx1ZRgBIAEoCVIFdmFsdWU=');

@$core.Deprecated('Use vec2Descriptor instead')
const Vec2$json = {
  '1': 'Vec2',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `Vec2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vec2Descriptor =
    $convert.base64Decode('CgRWZWMyEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeQ==');

@$core.Deprecated('Use mat4Descriptor instead')
const Mat4$json = {
  '1': 'Mat4',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 1, '10': 'values'},
  ],
};

/// Descriptor for `Mat4`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mat4Descriptor =
    $convert.base64Decode('CgRNYXQ0EhYKBnZhbHVlcxgBIAMoAVIGdmFsdWVz');

@$core.Deprecated('Use refDescriptor instead')
const Ref$json = {
  '1': 'Ref',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'product', '3': 2, '4': 1, '5': 9, '10': 'product'},
    {'1': 'kind', '3': 3, '4': 1, '5': 14, '6': '.Ref.Kind', '10': 'kind'},
  ],
  '4': [Ref_Kind$json],
};

@$core.Deprecated('Use refDescriptor instead')
const Ref_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'REF_KIND_FRAME', '2': 0},
    {'1': 'REF_KIND_VERTEX', '2': 1},
    {'1': 'REF_KIND_EDGE', '2': 2},
    {'1': 'REF_KIND_FACE', '2': 3},
  ],
};

/// Descriptor for `Ref`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refDescriptor = $convert.base64Decode(
    'CgNSZWYSHAoCaWQYASABKAsyDC5TdGF0ZW1lbnRJZFICaWQSGAoHcHJvZHVjdBgCIAEoCVIHcH'
    'JvZHVjdBIdCgRraW5kGAMgASgOMgkuUmVmLktpbmRSBGtpbmQiVQoES2luZBISCg5SRUZfS0lO'
    'RF9GUkFNRRAAEhMKD1JFRl9LSU5EX1ZFUlRFWBABEhEKDVJFRl9LSU5EX0VER0UQAhIRCg1SRU'
    'ZfS0lORF9GQUNFEAM=');

@$core.Deprecated('Use layoutRangeDescriptor instead')
const LayoutRange$json = {
  '1': 'LayoutRange',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 1, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 1, '10': 'max'},
  ],
};

/// Descriptor for `LayoutRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutRangeDescriptor = $convert.base64Decode(
    'CgtMYXlvdXRSYW5nZRIQCgNtaW4YASABKAFSA21pbhIQCgNtYXgYAiABKAFSA21heA==');

@$core.Deprecated('Use layoutDimensionDescriptor instead')
const LayoutDimension$json = {
  '1': 'LayoutDimension',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'value', '17': true},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.LayoutDimension.Type',
      '10': 'type'
    },
    {'1': 'range', '3': 3, '4': 1, '5': 11, '6': '.LayoutRange', '10': 'range'},
  ],
  '4': [LayoutDimension_Type$json],
  '8': [
    {'1': '_value'},
  ],
};

@$core.Deprecated('Use layoutDimensionDescriptor instead')
const LayoutDimension_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'LAYOUT_DIMENSION_TYPE_FIXED', '2': 0},
    {'1': 'LAYOUT_DIMENSION_TYPE_EXPAND', '2': 1},
    {'1': 'LAYOUT_DIMENSION_TYPE_CONTAIN', '2': 2},
  ],
};

/// Descriptor for `LayoutDimension`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutDimensionDescriptor = $convert.base64Decode(
    'Cg9MYXlvdXREaW1lbnNpb24SGQoFdmFsdWUYASABKAFIAFIFdmFsdWWIAQESKQoEdHlwZRgCIA'
    'EoDjIVLkxheW91dERpbWVuc2lvbi5UeXBlUgR0eXBlEiIKBXJhbmdlGAMgASgLMgwuTGF5b3V0'
    'UmFuZ2VSBXJhbmdlImwKBFR5cGUSHwobTEFZT1VUX0RJTUVOU0lPTl9UWVBFX0ZJWEVEEAASIA'
    'ocTEFZT1VUX0RJTUVOU0lPTl9UWVBFX0VYUEFORBABEiEKHUxBWU9VVF9ESU1FTlNJT05fVFlQ'
    'RV9DT05UQUlOEAJCCAoGX3ZhbHVl');

@$core.Deprecated('Use layoutSizeDescriptor instead')
const LayoutSize$json = {
  '1': 'LayoutSize',
  '2': [
    {
      '1': 'width',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.LayoutDimension',
      '10': 'width'
    },
    {
      '1': 'height',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.LayoutDimension',
      '10': 'height'
    },
  ],
};

/// Descriptor for `LayoutSize`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutSizeDescriptor = $convert.base64Decode(
    'CgpMYXlvdXRTaXplEiYKBXdpZHRoGAEgASgLMhAuTGF5b3V0RGltZW5zaW9uUgV3aWR0aBIoCg'
    'ZoZWlnaHQYAiABKAsyEC5MYXlvdXREaW1lbnNpb25SBmhlaWdodA==');

@$core.Deprecated('Use cornerRadiusDescriptor instead')
const CornerRadius$json = {
  '1': 'CornerRadius',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `CornerRadius`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cornerRadiusDescriptor = $convert
    .base64Decode('CgxDb3JuZXJSYWRpdXMSDAoBeBgBIAEoAVIBeBIMCgF5GAIgASgBUgF5');

@$core.Deprecated('Use circleObjectShapeDescriptor instead')
const CircleObjectShape$json = {
  '1': 'CircleObjectShape',
};

/// Descriptor for `CircleObjectShape`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List circleObjectShapeDescriptor =
    $convert.base64Decode('ChFDaXJjbGVPYmplY3RTaGFwZQ==');

@$core.Deprecated('Use rectangleObjectShapeDescriptor instead')
const RectangleObjectShape$json = {
  '1': 'RectangleObjectShape',
  '2': [
    {
      '1': 'top_left_radius',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.CornerRadius',
      '10': 'topLeftRadius'
    },
    {
      '1': 'top_right_radius',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.CornerRadius',
      '10': 'topRightRadius'
    },
    {
      '1': 'bottom_right_radius',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.CornerRadius',
      '10': 'bottomRightRadius'
    },
    {
      '1': 'bottom_left_radius',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.CornerRadius',
      '10': 'bottomLeftRadius'
    },
  ],
};

/// Descriptor for `RectangleObjectShape`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rectangleObjectShapeDescriptor = $convert.base64Decode(
    'ChRSZWN0YW5nbGVPYmplY3RTaGFwZRI1Cg90b3BfbGVmdF9yYWRpdXMYASABKAsyDS5Db3JuZX'
    'JSYWRpdXNSDXRvcExlZnRSYWRpdXMSNwoQdG9wX3JpZ2h0X3JhZGl1cxgCIAEoCzINLkNvcm5l'
    'clJhZGl1c1IOdG9wUmlnaHRSYWRpdXMSPQoTYm90dG9tX3JpZ2h0X3JhZGl1cxgDIAEoCzINLk'
    'Nvcm5lclJhZGl1c1IRYm90dG9tUmlnaHRSYWRpdXMSOwoSYm90dG9tX2xlZnRfcmFkaXVzGAQg'
    'ASgLMg0uQ29ybmVyUmFkaXVzUhBib3R0b21MZWZ0UmFkaXVz');

@$core.Deprecated('Use triangleObjectShapeDescriptor instead')
const TriangleObjectShape$json = {
  '1': 'TriangleObjectShape',
};

/// Descriptor for `TriangleObjectShape`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triangleObjectShapeDescriptor =
    $convert.base64Decode('ChNUcmlhbmdsZU9iamVjdFNoYXBl');

@$core.Deprecated('Use objectShapeDescriptor instead')
const ObjectShape$json = {
  '1': 'ObjectShape',
  '2': [
    {
      '1': 'circle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.CircleObjectShape',
      '9': 0,
      '10': 'circle'
    },
    {
      '1': 'rectangle',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.RectangleObjectShape',
      '9': 0,
      '10': 'rectangle'
    },
    {
      '1': 'triangle',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.TriangleObjectShape',
      '9': 0,
      '10': 'triangle'
    },
  ],
  '8': [
    {'1': 'shape'},
  ],
};

/// Descriptor for `ObjectShape`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List objectShapeDescriptor = $convert.base64Decode(
    'CgtPYmplY3RTaGFwZRIsCgZjaXJjbGUYASABKAsyEi5DaXJjbGVPYmplY3RTaGFwZUgAUgZjaX'
    'JjbGUSNQoJcmVjdGFuZ2xlGAIgASgLMhUuUmVjdGFuZ2xlT2JqZWN0U2hhcGVIAFIJcmVjdGFu'
    'Z2xlEjIKCHRyaWFuZ2xlGAMgASgLMhQuVHJpYW5nbGVPYmplY3RTaGFwZUgAUgh0cmlhbmdsZU'
    'IHCgVzaGFwZQ==');

@$core.Deprecated('Use colorDataDescriptor instead')
const ColorData$json = {
  '1': 'ColorData',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.ColorData.Type',
      '10': 'type'
    },
    {'1': 'v1', '3': 2, '4': 1, '5': 1, '10': 'v1'},
    {'1': 'v2', '3': 3, '4': 1, '5': 1, '10': 'v2'},
    {'1': 'v3', '3': 4, '4': 1, '5': 1, '10': 'v3'},
    {'1': 'alpha', '3': 5, '4': 1, '5': 1, '10': 'alpha'},
  ],
  '4': [ColorData_Type$json],
};

@$core.Deprecated('Use colorDataDescriptor instead')
const ColorData_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'COLOR_DATA_TYPE_HSV', '2': 0},
  ],
};

/// Descriptor for `ColorData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List colorDataDescriptor = $convert.base64Decode(
    'CglDb2xvckRhdGESIwoEdHlwZRgBIAEoDjIPLkNvbG9yRGF0YS5UeXBlUgR0eXBlEg4KAnYxGA'
    'IgASgBUgJ2MRIOCgJ2MhgDIAEoAVICdjISDgoCdjMYBCABKAFSAnYzEhQKBWFscGhhGAUgASgB'
    'UgVhbHBoYSIfCgRUeXBlEhcKE0NPTE9SX0RBVEFfVFlQRV9IU1YQAA==');

@$core.Deprecated('Use edgeStyleDescriptor instead')
const EdgeStyle$json = {
  '1': 'EdgeStyle',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 1, '10': 'width'},
    {'1': 'color', '3': 2, '4': 1, '5': 11, '6': '.ColorData', '10': 'color'},
  ],
};

/// Descriptor for `EdgeStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeStyleDescriptor = $convert.base64Decode(
    'CglFZGdlU3R5bGUSFAoFd2lkdGgYASABKAFSBXdpZHRoEiAKBWNvbG9yGAIgASgLMgouQ29sb3'
    'JEYXRhUgVjb2xvcg==');

@$core.Deprecated('Use faceStyleDescriptor instead')
const FaceStyle$json = {
  '1': 'FaceStyle',
  '2': [
    {'1': 'color', '3': 1, '4': 1, '5': 11, '6': '.ColorData', '10': 'color'},
  ],
};

/// Descriptor for `FaceStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List faceStyleDescriptor = $convert.base64Decode(
    'CglGYWNlU3R5bGUSIAoFY29sb3IYASABKAsyCi5Db2xvckRhdGFSBWNvbG9y');

@$core.Deprecated('Use layoutInsetsDescriptor instead')
const LayoutInsets$json = {
  '1': 'LayoutInsets',
  '2': [
    {'1': 'left', '3': 1, '4': 1, '5': 1, '10': 'left'},
    {'1': 'top', '3': 2, '4': 1, '5': 1, '10': 'top'},
    {'1': 'right', '3': 3, '4': 1, '5': 1, '10': 'right'},
    {'1': 'bottom', '3': 4, '4': 1, '5': 1, '10': 'bottom'},
  ],
};

/// Descriptor for `LayoutInsets`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutInsetsDescriptor = $convert.base64Decode(
    'CgxMYXlvdXRJbnNldHMSEgoEbGVmdBgBIAEoAVIEbGVmdBIQCgN0b3AYAiABKAFSA3RvcBIUCg'
    'VyaWdodBgDIAEoAVIFcmlnaHQSFgoGYm90dG9tGAQgASgBUgZib3R0b20=');

@$core.Deprecated('Use childLayoutDescriptor instead')
const ChildLayout$json = {
  '1': 'ChildLayout',
  '2': [
    {
      '1': 'stack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.StackChildLayout',
      '9': 0,
      '10': 'stack'
    },
    {
      '1': 'flex',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.FlexChildLayout',
      '9': 0,
      '10': 'flex'
    },
  ],
  '8': [
    {'1': 'layout'},
  ],
};

/// Descriptor for `ChildLayout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List childLayoutDescriptor = $convert.base64Decode(
    'CgtDaGlsZExheW91dBIpCgVzdGFjaxgBIAEoCzIRLlN0YWNrQ2hpbGRMYXlvdXRIAFIFc3RhY2'
    'sSJgoEZmxleBgCIAEoCzIQLkZsZXhDaGlsZExheW91dEgAUgRmbGV4QggKBmxheW91dA==');

@$core.Deprecated('Use stackChildLayoutDescriptor instead')
const StackChildLayout$json = {
  '1': 'StackChildLayout',
  '2': [
    {
      '1': 'alignHorizontal',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.LayoutAlign',
      '9': 0,
      '10': 'alignHorizontal',
      '17': true
    },
    {
      '1': 'alignVertical',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.LayoutAlign',
      '9': 1,
      '10': 'alignVertical',
      '17': true
    },
    {
      '1': 'padding',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.LayoutInsets',
      '10': 'padding'
    },
  ],
  '8': [
    {'1': '_alignHorizontal'},
    {'1': '_alignVertical'},
  ],
};

/// Descriptor for `StackChildLayout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stackChildLayoutDescriptor = $convert.base64Decode(
    'ChBTdGFja0NoaWxkTGF5b3V0EjsKD2FsaWduSG9yaXpvbnRhbBgBIAEoDjIMLkxheW91dEFsaW'
    'duSABSD2FsaWduSG9yaXpvbnRhbIgBARI3Cg1hbGlnblZlcnRpY2FsGAIgASgOMgwuTGF5b3V0'
    'QWxpZ25IAVINYWxpZ25WZXJ0aWNhbIgBARInCgdwYWRkaW5nGAMgASgLMg0uTGF5b3V0SW5zZX'
    'RzUgdwYWRkaW5nQhIKEF9hbGlnbkhvcml6b250YWxCEAoOX2FsaWduVmVydGljYWw=');

@$core.Deprecated('Use flexChildLayoutDescriptor instead')
const FlexChildLayout$json = {
  '1': 'FlexChildLayout',
  '2': [
    {
      '1': 'direction',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.FlexDirection',
      '10': 'direction'
    },
    {
      '1': 'justify',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.LayoutJustify',
      '10': 'justify'
    },
    {
      '1': 'crossAlign',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.LayoutAlign',
      '10': 'crossAlign'
    },
    {'1': 'gap', '3': 4, '4': 1, '5': 1, '10': 'gap'},
    {
      '1': 'padding',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.LayoutInsets',
      '10': 'padding'
    },
  ],
};

/// Descriptor for `FlexChildLayout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List flexChildLayoutDescriptor = $convert.base64Decode(
    'Cg9GbGV4Q2hpbGRMYXlvdXQSLAoJZGlyZWN0aW9uGAEgASgOMg4uRmxleERpcmVjdGlvblIJZG'
    'lyZWN0aW9uEigKB2p1c3RpZnkYAiABKA4yDi5MYXlvdXRKdXN0aWZ5UgdqdXN0aWZ5EiwKCmNy'
    'b3NzQWxpZ24YAyABKA4yDC5MYXlvdXRBbGlnblIKY3Jvc3NBbGlnbhIQCgNnYXAYBCABKAFSA2'
    'dhcBInCgdwYWRkaW5nGAUgASgLMg0uTGF5b3V0SW5zZXRzUgdwYWRkaW5n');
