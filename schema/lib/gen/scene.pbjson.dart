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

@$core.Deprecated('Use layoutDimensionTypeDescriptor instead')
const LayoutDimensionType$json = {
  '1': 'LayoutDimensionType',
  '2': [
    {'1': 'LAYOUT_DIMENSION_TYPE_FIXED', '2': 0},
    {'1': 'LAYOUT_DIMENSION_TYPE_EXPAND', '2': 1},
    {'1': 'LAYOUT_DIMENSION_TYPE_CONTAIN', '2': 2},
  ],
};

/// Descriptor for `LayoutDimensionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List layoutDimensionTypeDescriptor = $convert.base64Decode(
    'ChNMYXlvdXREaW1lbnNpb25UeXBlEh8KG0xBWU9VVF9ESU1FTlNJT05fVFlQRV9GSVhFRBAAEi'
    'AKHExBWU9VVF9ESU1FTlNJT05fVFlQRV9FWFBBTkQQARIhCh1MQVlPVVRfRElNRU5TSU9OX1RZ'
    'UEVfQ09OVEFJThAC');

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
    {'1': 'program', '3': 1, '4': 2, '5': 11, '6': '.Program', '10': 'program'},
  ],
};

/// Descriptor for `Scene`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sceneDescriptor = $convert.base64Decode(
    'CgVTY2VuZRIiCgdwcm9ncmFtGAEgAigLMgguUHJvZ3JhbVIHcHJvZ3JhbQ==');

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
      '1': 'rectangle',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.RectangleStatement',
      '9': 0,
      '10': 'rectangle'
    },
    {
      '1': 'container',
      '3': 8,
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
    'ljZXMSMwoJcmVjdGFuZ2xlGAcgASgLMhMuUmVjdGFuZ2xlU3RhdGVtZW50SABSCXJlY3Rhbmds'
    'ZRIzCgljb250YWluZXIYCCABKAsyEy5Db250YWluZXJTdGF0ZW1lbnRIAFIJY29udGFpbmVyQg'
    'sKCXN0YXRlbWVudA==');

@$core.Deprecated('Use statementIdDescriptor instead')
const StatementId$json = {
  '1': 'StatementId',
  '2': [
    {'1': 'value', '3': 1, '4': 2, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `StatementId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementIdDescriptor =
    $convert.base64Decode('CgtTdGF0ZW1lbnRJZBIUCgV2YWx1ZRgBIAIoCVIFdmFsdWU=');

@$core.Deprecated('Use vec2Descriptor instead')
const Vec2$json = {
  '1': 'Vec2',
  '2': [
    {'1': 'x', '3': 1, '4': 2, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 2, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `Vec2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vec2Descriptor =
    $convert.base64Decode('CgRWZWMyEgwKAXgYASACKAFSAXgSDAoBeRgCIAIoAVIBeQ==');

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
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'product', '3': 2, '4': 2, '5': 9, '10': 'product'},
  ],
};

/// Descriptor for `Ref`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refDescriptor = $convert.base64Decode(
    'CgNSZWYSHAoCaWQYASACKAsyDC5TdGF0ZW1lbnRJZFICaWQSGAoHcHJvZHVjdBgCIAIoCVIHcH'
    'JvZHVjdA==');

@$core.Deprecated('Use frameStatementDescriptor instead')
const FrameStatement$json = {
  '1': 'FrameStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'parent', '3': 2, '4': 1, '5': 11, '6': '.Ref', '10': 'parent'},
    {
      '1': 'transform',
      '3': 3,
      '4': 2,
      '5': 11,
      '6': '.Mat4',
      '10': 'transform'
    },
  ],
};

/// Descriptor for `FrameStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List frameStatementDescriptor = $convert.base64Decode(
    'Cg5GcmFtZVN0YXRlbWVudBIcCgJpZBgBIAIoCzIMLlN0YXRlbWVudElkUgJpZBIcCgZwYXJlbn'
    'QYAiABKAsyBC5SZWZSBnBhcmVudBIjCgl0cmFuc2Zvcm0YAyACKAsyBS5NYXQ0Ugl0cmFuc2Zv'
    'cm0=');

@$core.Deprecated('Use vertexStatementDescriptor instead')
const VertexStatement$json = {
  '1': 'VertexStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'parent', '3': 2, '4': 1, '5': 11, '6': '.Ref', '10': 'parent'},
    {'1': 'position', '3': 3, '4': 2, '5': 11, '6': '.Vec2', '10': 'position'},
  ],
};

/// Descriptor for `VertexStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vertexStatementDescriptor = $convert.base64Decode(
    'Cg9WZXJ0ZXhTdGF0ZW1lbnQSHAoCaWQYASACKAsyDC5TdGF0ZW1lbnRJZFICaWQSHAoGcGFyZW'
    '50GAIgASgLMgQuUmVmUgZwYXJlbnQSIQoIcG9zaXRpb24YAyACKAsyBS5WZWMyUghwb3NpdGlv'
    'bg==');

@$core.Deprecated('Use edgeStatementDescriptor instead')
const EdgeStatement$json = {
  '1': 'EdgeStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'parent', '3': 2, '4': 1, '5': 11, '6': '.Ref', '10': 'parent'},
    {'1': 'start', '3': 3, '4': 2, '5': 11, '6': '.Ref', '10': 'start'},
    {'1': 'end', '3': 4, '4': 2, '5': 11, '6': '.Ref', '10': 'end'},
  ],
};

/// Descriptor for `EdgeStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeStatementDescriptor = $convert.base64Decode(
    'Cg1FZGdlU3RhdGVtZW50EhwKAmlkGAEgAigLMgwuU3RhdGVtZW50SWRSAmlkEhwKBnBhcmVudB'
    'gCIAEoCzIELlJlZlIGcGFyZW50EhoKBXN0YXJ0GAMgAigLMgQuUmVmUgVzdGFydBIWCgNlbmQY'
    'BCACKAsyBC5SZWZSA2VuZA==');

@$core.Deprecated('Use faceStatementDescriptor instead')
const FaceStatement$json = {
  '1': 'FaceStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'parent', '3': 2, '4': 1, '5': 11, '6': '.Ref', '10': 'parent'},
    {
      '1': 'outer',
      '3': 3,
      '4': 2,
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
  ],
  '3': [FaceStatement_Cycle$json],
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
    'Cg1GYWNlU3RhdGVtZW50EhwKAmlkGAEgAigLMgwuU3RhdGVtZW50SWRSAmlkEhwKBnBhcmVudB'
    'gCIAEoCzIELlJlZlIGcGFyZW50EioKBW91dGVyGAMgAigLMhQuRmFjZVN0YXRlbWVudC5DeWNs'
    'ZVIFb3V0ZXISKgoFaG9sZXMYBCADKAsyFC5GYWNlU3RhdGVtZW50LkN5Y2xlUgVob2xlcxojCg'
    'VDeWNsZRIaCgVlZGdlcxgBIAMoCzIELlJlZlIFZWRnZXM=');

@$core.Deprecated('Use cutEdgeStatementDescriptor instead')
const CutEdgeStatement$json = {
  '1': 'CutEdgeStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'target', '3': 2, '4': 2, '5': 11, '6': '.Ref', '10': 'target'},
    {'1': 't', '3': 3, '4': 2, '5': 1, '10': 't'},
  ],
};

/// Descriptor for `CutEdgeStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cutEdgeStatementDescriptor = $convert.base64Decode(
    'ChBDdXRFZGdlU3RhdGVtZW50EhwKAmlkGAEgAigLMgwuU3RhdGVtZW50SWRSAmlkEhwKBnRhcm'
    'dldBgCIAIoCzIELlJlZlIGdGFyZ2V0EgwKAXQYAyACKAFSAXQ=');

@$core.Deprecated('Use glueVerticesStatementDescriptor instead')
const GlueVerticesStatement$json = {
  '1': 'GlueVerticesStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'targets', '3': 2, '4': 3, '5': 11, '6': '.Ref', '10': 'targets'},
    {
      '1': 'position',
      '3': 3,
      '4': 2,
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
    'ChVHbHVlVmVydGljZXNTdGF0ZW1lbnQSHAoCaWQYASACKAsyDC5TdGF0ZW1lbnRJZFICaWQSHg'
    'oHdGFyZ2V0cxgCIAMoCzIELlJlZlIHdGFyZ2V0cxI7Cghwb3NpdGlvbhgDIAIoDjIfLkdsdWVW'
    'ZXJ0aWNlc1N0YXRlbWVudC5Qb3NpdGlvblIIcG9zaXRpb24iZQoIUG9zaXRpb24SLQopR0xVRV'
    '9WRVJUSUNFU19TVEFURU1FTlRfUE9TSVRJT05fQ0VOVFJPSUQQABIqCiZHTFVFX1ZFUlRJQ0VT'
    'X1NUQVRFTUVOVF9QT1NJVElPTl9GSVJTVBAB');

@$core.Deprecated('Use layoutRangeDescriptor instead')
const LayoutRange$json = {
  '1': 'LayoutRange',
  '2': [
    {'1': 'min', '3': 1, '4': 2, '5': 1, '10': 'min'},
    {'1': 'max', '3': 2, '4': 2, '5': 1, '10': 'max'},
  ],
};

/// Descriptor for `LayoutRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutRangeDescriptor = $convert.base64Decode(
    'CgtMYXlvdXRSYW5nZRIQCgNtaW4YASACKAFSA21pbhIQCgNtYXgYAiACKAFSA21heA==');

@$core.Deprecated('Use layoutDimensionDescriptor instead')
const LayoutDimension$json = {
  '1': 'LayoutDimension',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 1, '10': 'value'},
    {
      '1': 'type',
      '3': 2,
      '4': 2,
      '5': 14,
      '6': '.LayoutDimensionType',
      '10': 'type'
    },
    {'1': 'range', '3': 3, '4': 2, '5': 11, '6': '.LayoutRange', '10': 'range'},
  ],
};

/// Descriptor for `LayoutDimension`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutDimensionDescriptor = $convert.base64Decode(
    'Cg9MYXlvdXREaW1lbnNpb24SFAoFdmFsdWUYASABKAFSBXZhbHVlEigKBHR5cGUYAiACKA4yFC'
    '5MYXlvdXREaW1lbnNpb25UeXBlUgR0eXBlEiIKBXJhbmdlGAMgAigLMgwuTGF5b3V0UmFuZ2VS'
    'BXJhbmdl');

@$core.Deprecated('Use layoutSizeDescriptor instead')
const LayoutSize$json = {
  '1': 'LayoutSize',
  '2': [
    {
      '1': 'width',
      '3': 1,
      '4': 2,
      '5': 11,
      '6': '.LayoutDimension',
      '10': 'width'
    },
    {
      '1': 'height',
      '3': 2,
      '4': 2,
      '5': 11,
      '6': '.LayoutDimension',
      '10': 'height'
    },
  ],
};

/// Descriptor for `LayoutSize`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutSizeDescriptor = $convert.base64Decode(
    'CgpMYXlvdXRTaXplEiYKBXdpZHRoGAEgAigLMhAuTGF5b3V0RGltZW5zaW9uUgV3aWR0aBIoCg'
    'ZoZWlnaHQYAiACKAsyEC5MYXlvdXREaW1lbnNpb25SBmhlaWdodA==');

@$core.Deprecated('Use cornerRadiusDescriptor instead')
const CornerRadius$json = {
  '1': 'CornerRadius',
  '2': [
    {'1': 'x', '3': 1, '4': 2, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 2, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `CornerRadius`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cornerRadiusDescriptor = $convert
    .base64Decode('CgxDb3JuZXJSYWRpdXMSDAoBeBgBIAIoAVIBeBIMCgF5GAIgAigBUgF5');

@$core.Deprecated('Use rectangleObjectShapeDescriptor instead')
const RectangleObjectShape$json = {
  '1': 'RectangleObjectShape',
  '2': [
    {
      '1': 'top_left_radius',
      '3': 1,
      '4': 2,
      '5': 11,
      '6': '.CornerRadius',
      '10': 'topLeftRadius'
    },
    {
      '1': 'top_right_radius',
      '3': 2,
      '4': 2,
      '5': 11,
      '6': '.CornerRadius',
      '10': 'topRightRadius'
    },
    {
      '1': 'bottom_right_radius',
      '3': 3,
      '4': 2,
      '5': 11,
      '6': '.CornerRadius',
      '10': 'bottomRightRadius'
    },
    {
      '1': 'bottom_left_radius',
      '3': 4,
      '4': 2,
      '5': 11,
      '6': '.CornerRadius',
      '10': 'bottomLeftRadius'
    },
  ],
};

/// Descriptor for `RectangleObjectShape`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rectangleObjectShapeDescriptor = $convert.base64Decode(
    'ChRSZWN0YW5nbGVPYmplY3RTaGFwZRI1Cg90b3BfbGVmdF9yYWRpdXMYASACKAsyDS5Db3JuZX'
    'JSYWRpdXNSDXRvcExlZnRSYWRpdXMSNwoQdG9wX3JpZ2h0X3JhZGl1cxgCIAIoCzINLkNvcm5l'
    'clJhZGl1c1IOdG9wUmlnaHRSYWRpdXMSPQoTYm90dG9tX3JpZ2h0X3JhZGl1cxgDIAIoCzINLk'
    'Nvcm5lclJhZGl1c1IRYm90dG9tUmlnaHRSYWRpdXMSOwoSYm90dG9tX2xlZnRfcmFkaXVzGAQg'
    'AigLMg0uQ29ybmVyUmFkaXVzUhBib3R0b21MZWZ0UmFkaXVz');

@$core.Deprecated('Use rectangleStatementDescriptor instead')
const RectangleStatement$json = {
  '1': 'RectangleStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'parent', '3': 2, '4': 1, '5': 11, '6': '.Ref', '10': 'parent'},
    {
      '1': 'transform',
      '3': 3,
      '4': 2,
      '5': 11,
      '6': '.Mat4',
      '10': 'transform'
    },
    {'1': 'size', '3': 4, '4': 2, '5': 11, '6': '.LayoutSize', '10': 'size'},
    {
      '1': 'shape',
      '3': 5,
      '4': 2,
      '5': 11,
      '6': '.RectangleObjectShape',
      '10': 'shape'
    },
  ],
};

/// Descriptor for `RectangleStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rectangleStatementDescriptor = $convert.base64Decode(
    'ChJSZWN0YW5nbGVTdGF0ZW1lbnQSHAoCaWQYASACKAsyDC5TdGF0ZW1lbnRJZFICaWQSHAoGcG'
    'FyZW50GAIgASgLMgQuUmVmUgZwYXJlbnQSIwoJdHJhbnNmb3JtGAMgAigLMgUuTWF0NFIJdHJh'
    'bnNmb3JtEh8KBHNpemUYBCACKAsyCy5MYXlvdXRTaXplUgRzaXplEisKBXNoYXBlGAUgAigLMh'
    'UuUmVjdGFuZ2xlT2JqZWN0U2hhcGVSBXNoYXBl');

@$core.Deprecated('Use layoutInsetsDescriptor instead')
const LayoutInsets$json = {
  '1': 'LayoutInsets',
  '2': [
    {'1': 'left', '3': 1, '4': 2, '5': 1, '10': 'left'},
    {'1': 'top', '3': 2, '4': 2, '5': 1, '10': 'top'},
    {'1': 'right', '3': 3, '4': 2, '5': 1, '10': 'right'},
    {'1': 'bottom', '3': 4, '4': 2, '5': 1, '10': 'bottom'},
  ],
};

/// Descriptor for `LayoutInsets`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutInsetsDescriptor = $convert.base64Decode(
    'CgxMYXlvdXRJbnNldHMSEgoEbGVmdBgBIAIoAVIEbGVmdBIQCgN0b3AYAiACKAFSA3RvcBIUCg'
    'VyaWdodBgDIAIoAVIFcmlnaHQSFgoGYm90dG9tGAQgAigBUgZib3R0b20=');

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
      '10': 'alignHorizontal'
    },
    {
      '1': 'alignVertical',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.LayoutAlign',
      '10': 'alignVertical'
    },
    {
      '1': 'padding',
      '3': 3,
      '4': 2,
      '5': 11,
      '6': '.LayoutInsets',
      '10': 'padding'
    },
  ],
};

/// Descriptor for `StackChildLayout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stackChildLayoutDescriptor = $convert.base64Decode(
    'ChBTdGFja0NoaWxkTGF5b3V0EjYKD2FsaWduSG9yaXpvbnRhbBgBIAEoDjIMLkxheW91dEFsaW'
    'duUg9hbGlnbkhvcml6b250YWwSMgoNYWxpZ25WZXJ0aWNhbBgCIAEoDjIMLkxheW91dEFsaWdu'
    'Ug1hbGlnblZlcnRpY2FsEicKB3BhZGRpbmcYAyACKAsyDS5MYXlvdXRJbnNldHNSB3BhZGRpbm'
    'c=');

@$core.Deprecated('Use flexChildLayoutDescriptor instead')
const FlexChildLayout$json = {
  '1': 'FlexChildLayout',
  '2': [
    {
      '1': 'direction',
      '3': 1,
      '4': 2,
      '5': 14,
      '6': '.FlexDirection',
      '10': 'direction'
    },
    {
      '1': 'justify',
      '3': 2,
      '4': 2,
      '5': 14,
      '6': '.LayoutJustify',
      '10': 'justify'
    },
    {
      '1': 'crossAlign',
      '3': 3,
      '4': 2,
      '5': 14,
      '6': '.LayoutAlign',
      '10': 'crossAlign'
    },
    {'1': 'gap', '3': 4, '4': 2, '5': 1, '10': 'gap'},
    {
      '1': 'padding',
      '3': 5,
      '4': 2,
      '5': 11,
      '6': '.LayoutInsets',
      '10': 'padding'
    },
  ],
};

/// Descriptor for `FlexChildLayout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List flexChildLayoutDescriptor = $convert.base64Decode(
    'Cg9GbGV4Q2hpbGRMYXlvdXQSLAoJZGlyZWN0aW9uGAEgAigOMg4uRmxleERpcmVjdGlvblIJZG'
    'lyZWN0aW9uEigKB2p1c3RpZnkYAiACKA4yDi5MYXlvdXRKdXN0aWZ5UgdqdXN0aWZ5EiwKCmNy'
    'b3NzQWxpZ24YAyACKA4yDC5MYXlvdXRBbGlnblIKY3Jvc3NBbGlnbhIQCgNnYXAYBCACKAFSA2'
    'dhcBInCgdwYWRkaW5nGAUgAigLMg0uTGF5b3V0SW5zZXRzUgdwYWRkaW5n');

@$core.Deprecated('Use containerStatementDescriptor instead')
const ContainerStatement$json = {
  '1': 'ContainerStatement',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 11, '6': '.StatementId', '10': 'id'},
    {'1': 'parent', '3': 2, '4': 1, '5': 11, '6': '.Ref', '10': 'parent'},
    {
      '1': 'transform',
      '3': 3,
      '4': 2,
      '5': 11,
      '6': '.Mat4',
      '10': 'transform'
    },
    {'1': 'size', '3': 4, '4': 2, '5': 11, '6': '.LayoutSize', '10': 'size'},
    {
      '1': 'shape',
      '3': 5,
      '4': 2,
      '5': 11,
      '6': '.RectangleObjectShape',
      '10': 'shape'
    },
    {
      '1': 'childLayout',
      '3': 6,
      '4': 2,
      '5': 11,
      '6': '.ChildLayout',
      '10': 'childLayout'
    },
  ],
};

/// Descriptor for `ContainerStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List containerStatementDescriptor = $convert.base64Decode(
    'ChJDb250YWluZXJTdGF0ZW1lbnQSHAoCaWQYASACKAsyDC5TdGF0ZW1lbnRJZFICaWQSHAoGcG'
    'FyZW50GAIgASgLMgQuUmVmUgZwYXJlbnQSIwoJdHJhbnNmb3JtGAMgAigLMgUuTWF0NFIJdHJh'
    'bnNmb3JtEh8KBHNpemUYBCACKAsyCy5MYXlvdXRTaXplUgRzaXplEisKBXNoYXBlGAUgAigLMh'
    'UuUmVjdGFuZ2xlT2JqZWN0U2hhcGVSBXNoYXBlEi4KC2NoaWxkTGF5b3V0GAYgAigLMgwuQ2hp'
    'bGRMYXlvdXRSC2NoaWxkTGF5b3V0');
