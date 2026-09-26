// This is a generated file - do not edit.
//
// Generated from program.proto.

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

@$core.Deprecated('Use cellKindDescriptor instead')
const CellKind$json = {
  '1': 'CellKind',
  '2': [
    {'1': 'CELL_KIND_FRAME', '2': 0},
    {'1': 'CELL_KIND_VERTEX', '2': 1},
    {'1': 'CELL_KIND_EDGE', '2': 2},
    {'1': 'CELL_KIND_FACE', '2': 3},
  ],
};

/// Descriptor for `CellKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cellKindDescriptor = $convert.base64Decode(
    'CghDZWxsS2luZBITCg9DRUxMX0tJTkRfRlJBTUUQABIUChBDRUxMX0tJTkRfVkVSVEVYEAESEg'
    'oOQ0VMTF9LSU5EX0VER0UQAhISCg5DRUxMX0tJTkRfRkFDRRAD');

@$core.Deprecated('Use programDescriptor instead')
const Program$json = {
  '1': 'Program',
  '2': [
    {
      '1': 'statements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.Statement',
      '10': 'statements'
    },
    {
      '1': 'style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.StyleTable',
      '10': 'style'
    },
    {
      '1': 'z_order',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ZOrderTable',
      '10': 'zOrder'
    },
  ],
};

/// Descriptor for `Program`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programDescriptor = $convert.base64Decode(
    'CgdQcm9ncmFtEjAKCnN0YXRlbWVudHMYASADKAsyEC5tb3RpZi5TdGF0ZW1lbnRSCnN0YXRlbW'
    'VudHMSJwoFc3R5bGUYAiABKAsyES5tb3RpZi5TdHlsZVRhYmxlUgVzdHlsZRIrCgd6X29yZGVy'
    'GAMgASgLMhIubW90aWYuWk9yZGVyVGFibGVSBnpPcmRlcg==');

@$core.Deprecated('Use programSliceDescriptor instead')
const ProgramSlice$json = {
  '1': 'ProgramSlice',
  '2': [
    {
      '1': 'statements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.Statement',
      '10': 'statements'
    },
    {
      '1': 'style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.StyleTable',
      '10': 'style'
    },
    {
      '1': 'z_order',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ZOrderTable',
      '10': 'zOrder'
    },
  ],
};

/// Descriptor for `ProgramSlice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programSliceDescriptor = $convert.base64Decode(
    'CgxQcm9ncmFtU2xpY2USMAoKc3RhdGVtZW50cxgBIAMoCzIQLm1vdGlmLlN0YXRlbWVudFIKc3'
    'RhdGVtZW50cxInCgVzdHlsZRgCIAEoCzIRLm1vdGlmLlN0eWxlVGFibGVSBXN0eWxlEisKB3pf'
    'b3JkZXIYAyABKAsyEi5tb3RpZi5aT3JkZXJUYWJsZVIGek9yZGVy');

@$core.Deprecated('Use statementDescriptor instead')
const Statement$json = {
  '1': 'Statement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.motif.StatementId', '10': 'id'},
    {
      '1': 'modifiers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.Modifier',
      '10': 'modifiers'
    },
    {
      '1': 'vertex',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStatement',
      '9': 0,
      '10': 'vertex'
    },
    {
      '1': 'edge',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStatement',
      '9': 0,
      '10': 'edge'
    },
    {
      '1': 'face',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStatement',
      '9': 0,
      '10': 'face'
    },
    {
      '1': 'cut_edge',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.motif.CutEdgeStatement',
      '9': 0,
      '10': 'cutEdge'
    },
    {
      '1': 'multi_cut_edge',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.motif.MultiCutEdgeStatement',
      '9': 0,
      '10': 'multiCutEdge'
    },
    {
      '1': 'fillet_face',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.motif.FilletFaceStatement',
      '9': 0,
      '10': 'filletFace'
    },
    {
      '1': 'glue_vertices',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.motif.GlueVerticesStatement',
      '9': 0,
      '10': 'glueVertices'
    },
    {
      '1': 'rectangle',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.motif.RectangleStatement',
      '9': 0,
      '10': 'rectangle'
    },
    {
      '1': 'polygon',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.motif.PolygonStatement',
      '9': 0,
      '10': 'polygon'
    },
    {
      '1': 'ellipse',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.motif.EllipseStatement',
      '9': 0,
      '10': 'ellipse'
    },
    {
      '1': 'container',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.motif.ContainerStatement',
      '9': 0,
      '10': 'container'
    },
    {
      '1': 'group',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.motif.GroupStatement',
      '9': 0,
      '10': 'group'
    },
    {
      '1': 'generator',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.motif.GeneratorStatement',
      '9': 0,
      '10': 'generator'
    },
    {
      '1': 'text',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.motif.TextStatement',
      '9': 0,
      '10': 'text'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `Statement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementDescriptor = $convert.base64Decode(
    'CglTdGF0ZW1lbnQSIgoCaWQYASABKAsyEi5tb3RpZi5TdGF0ZW1lbnRJZFICaWQSLQoJbW9kaW'
    'ZpZXJzGAIgAygLMg8ubW90aWYuTW9kaWZpZXJSCW1vZGlmaWVycxIwCgZ2ZXJ0ZXgYCiABKAsy'
    'Fi5tb3RpZi5WZXJ0ZXhTdGF0ZW1lbnRIAFIGdmVydGV4EioKBGVkZ2UYCyABKAsyFC5tb3RpZi'
    '5FZGdlU3RhdGVtZW50SABSBGVkZ2USKgoEZmFjZRgMIAEoCzIULm1vdGlmLkZhY2VTdGF0ZW1l'
    'bnRIAFIEZmFjZRI0CghjdXRfZWRnZRgNIAEoCzIXLm1vdGlmLkN1dEVkZ2VTdGF0ZW1lbnRIAF'
    'IHY3V0RWRnZRJECg5tdWx0aV9jdXRfZWRnZRgOIAEoCzIcLm1vdGlmLk11bHRpQ3V0RWRnZVN0'
    'YXRlbWVudEgAUgxtdWx0aUN1dEVkZ2USPQoLZmlsbGV0X2ZhY2UYDyABKAsyGi5tb3RpZi5GaW'
    'xsZXRGYWNlU3RhdGVtZW50SABSCmZpbGxldEZhY2USQwoNZ2x1ZV92ZXJ0aWNlcxgQIAEoCzIc'
    'Lm1vdGlmLkdsdWVWZXJ0aWNlc1N0YXRlbWVudEgAUgxnbHVlVmVydGljZXMSOQoJcmVjdGFuZ2'
    'xlGBEgASgLMhkubW90aWYuUmVjdGFuZ2xlU3RhdGVtZW50SABSCXJlY3RhbmdsZRIzCgdwb2x5'
    'Z29uGBIgASgLMhcubW90aWYuUG9seWdvblN0YXRlbWVudEgAUgdwb2x5Z29uEjMKB2VsbGlwc2'
    'UYEyABKAsyFy5tb3RpZi5FbGxpcHNlU3RhdGVtZW50SABSB2VsbGlwc2USOQoJY29udGFpbmVy'
    'GBQgASgLMhkubW90aWYuQ29udGFpbmVyU3RhdGVtZW50SABSCWNvbnRhaW5lchItCgVncm91cB'
    'gVIAEoCzIVLm1vdGlmLkdyb3VwU3RhdGVtZW50SABSBWdyb3VwEjkKCWdlbmVyYXRvchgWIAEo'
    'CzIZLm1vdGlmLkdlbmVyYXRvclN0YXRlbWVudEgAUglnZW5lcmF0b3ISKgoEdGV4dBgXIAEoCz'
    'IULm1vdGlmLlRleHRTdGF0ZW1lbnRIAFIEdGV4dEIHCgV2YWx1ZQ==');

@$core.Deprecated('Use u64Descriptor instead')
const U64$json = {
  '1': 'U64',
  '2': [
    {'1': 'hi', '3': 1, '4': 1, '5': 13, '10': 'hi'},
    {'1': 'lo', '3': 2, '4': 1, '5': 13, '10': 'lo'},
  ],
};

/// Descriptor for `U64`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List u64Descriptor = $convert
    .base64Decode('CgNVNjQSDgoCaGkYASABKA1SAmhpEg4KAmxvGAIgASgNUgJsbw==');

@$core.Deprecated('Use statementIdDescriptor instead')
const StatementId$json = {
  '1': 'StatementId',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 11, '6': '.motif.U64', '10': 'value'},
  ],
};

/// Descriptor for `StatementId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementIdDescriptor = $convert.base64Decode(
    'CgtTdGF0ZW1lbnRJZBIgCgV2YWx1ZRgBIAEoCzIKLm1vdGlmLlU2NFIFdmFsdWU=');

@$core.Deprecated('Use cellRefDescriptor instead')
const CellRef$json = {
  '1': 'CellRef',
  '2': [
    {
      '1': 'namespace',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.U64',
      '10': 'namespace'
    },
    {'1': 'tag', '3': 2, '4': 1, '5': 13, '10': 'tag'},
    {'1': 'sub', '3': 3, '4': 1, '5': 13, '10': 'sub'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.motif.CellKind',
      '10': 'kind'
    },
  ],
};

/// Descriptor for `CellRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cellRefDescriptor = $convert.base64Decode(
    'CgdDZWxsUmVmEigKCW5hbWVzcGFjZRgBIAEoCzIKLm1vdGlmLlU2NFIJbmFtZXNwYWNlEhAKA3'
    'RhZxgCIAEoDVIDdGFnEhAKA3N1YhgDIAEoDVIDc3ViEiMKBGtpbmQYBCABKA4yDy5tb3RpZi5D'
    'ZWxsS2luZFIEa2luZA==');

@$core.Deprecated('Use zAnchorDescriptor instead')
const ZAnchor$json = {
  '1': 'ZAnchor',
  '2': [
    {'1': 'top', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'top'},
    {'1': 'bottom', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'bottom'},
    {
      '1': 'above',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'above'
    },
    {
      '1': 'below',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'below'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `ZAnchor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List zAnchorDescriptor = $convert.base64Decode(
    'CgdaQW5jaG9yEhIKA3RvcBgBIAEoCEgAUgN0b3ASGAoGYm90dG9tGAIgASgISABSBmJvdHRvbR'
    'ImCgVhYm92ZRgDIAEoCzIOLm1vdGlmLkNlbGxSZWZIAFIFYWJvdmUSJgoFYmVsb3cYBCABKAsy'
    'Di5tb3RpZi5DZWxsUmVmSABSBWJlbG93QgcKBXZhbHVl');

@$core.Deprecated('Use zOrderEntryDescriptor instead')
const ZOrderEntry$json = {
  '1': 'ZOrderEntry',
  '2': [
    {'1': 'ref', '3': 1, '4': 1, '5': 11, '6': '.motif.CellRef', '10': 'ref'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ZAnchor',
      '10': 'value'
    },
  ],
};

/// Descriptor for `ZOrderEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List zOrderEntryDescriptor = $convert.base64Decode(
    'CgtaT3JkZXJFbnRyeRIgCgNyZWYYASABKAsyDi5tb3RpZi5DZWxsUmVmUgNyZWYSJAoFdmFsdW'
    'UYAiABKAsyDi5tb3RpZi5aQW5jaG9yUgV2YWx1ZQ==');

@$core.Deprecated('Use zOrderTableDescriptor instead')
const ZOrderTable$json = {
  '1': 'ZOrderTable',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.ZOrderEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ZOrderTable`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List zOrderTableDescriptor = $convert.base64Decode(
    'CgtaT3JkZXJUYWJsZRIsCgdlbnRyaWVzGAEgAygLMhIubW90aWYuWk9yZGVyRW50cnlSB2VudH'
    'JpZXM=');

@$core.Deprecated('Use styleEntryDescriptor instead')
const StyleEntry$json = {
  '1': 'StyleEntry',
  '2': [
    {'1': 'ref', '3': 1, '4': 1, '5': 11, '6': '.motif.CellRef', '10': 'ref'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.CellStyle.Partial',
      '10': 'value'
    },
  ],
};

/// Descriptor for `StyleEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List styleEntryDescriptor = $convert.base64Decode(
    'CgpTdHlsZUVudHJ5EiAKA3JlZhgBIAEoCzIOLm1vdGlmLkNlbGxSZWZSA3JlZhIuCgV2YWx1ZR'
    'gCIAEoCzIYLm1vdGlmLkNlbGxTdHlsZS5QYXJ0aWFsUgV2YWx1ZQ==');

@$core.Deprecated('Use styleTableDescriptor instead')
const StyleTable$json = {
  '1': 'StyleTable',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.StyleEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `StyleTable`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List styleTableDescriptor = $convert.base64Decode(
    'CgpTdHlsZVRhYmxlEisKB2VudHJpZXMYASADKAsyES5tb3RpZi5TdHlsZUVudHJ5UgdlbnRyaW'
    'Vz');

@$core.Deprecated('Use cellStyleDescriptor instead')
const CellStyle$json = {
  '1': 'CellStyle',
  '2': [
    {
      '1': 'vertex',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '9': 0,
      '10': 'vertex'
    },
    {
      '1': 'edge',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '9': 0,
      '10': 'edge'
    },
    {
      '1': 'face',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '9': 0,
      '10': 'face'
    },
  ],
  '3': [CellStyle_Partial$json],
  '8': [
    {'1': 'value'},
  ],
};

@$core.Deprecated('Use cellStyleDescriptor instead')
const CellStyle_Partial$json = {
  '1': 'Partial',
  '2': [
    {
      '1': 'vertex',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle.Partial',
      '9': 0,
      '10': 'vertex'
    },
    {
      '1': 'edge',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle.Partial',
      '9': 0,
      '10': 'edge'
    },
    {
      '1': 'face',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle.Partial',
      '9': 0,
      '10': 'face'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `CellStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cellStyleDescriptor = $convert.base64Decode(
    'CglDZWxsU3R5bGUSLAoGdmVydGV4GAEgASgLMhIubW90aWYuVmVydGV4U3R5bGVIAFIGdmVydG'
    'V4EiYKBGVkZ2UYAiABKAsyEC5tb3RpZi5FZGdlU3R5bGVIAFIEZWRnZRImCgRmYWNlGAMgASgL'
    'MhAubW90aWYuRmFjZVN0eWxlSABSBGZhY2UaqAEKB1BhcnRpYWwSNAoGdmVydGV4GAEgASgLMh'
    'oubW90aWYuVmVydGV4U3R5bGUuUGFydGlhbEgAUgZ2ZXJ0ZXgSLgoEZWRnZRgCIAEoCzIYLm1v'
    'dGlmLkVkZ2VTdHlsZS5QYXJ0aWFsSABSBGVkZ2USLgoEZmFjZRgDIAEoCzIYLm1vdGlmLkZhY2'
    'VTdHlsZS5QYXJ0aWFsSABSBGZhY2VCBwoFdmFsdWVCBwoFdmFsdWU=');

@$core.Deprecated('Use vertexStyleDescriptor instead')
const VertexStyle$json = {
  '1': 'VertexStyle',
  '2': [
    {'1': 'radius', '3': 1, '4': 1, '5': 1, '10': 'radius'},
    {
      '1': 'color',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData',
      '10': 'color'
    },
  ],
  '3': [VertexStyle_Partial$json],
};

@$core.Deprecated('Use vertexStyleDescriptor instead')
const VertexStyle_Partial$json = {
  '1': 'Partial',
  '2': [
    {'1': 'radius', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'radius', '17': true},
    {
      '1': 'color',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData',
      '9': 1,
      '10': 'color',
      '17': true
    },
  ],
  '8': [
    {'1': '_radius'},
    {'1': '_color'},
  ],
};

/// Descriptor for `VertexStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vertexStyleDescriptor = $convert.base64Decode(
    'CgtWZXJ0ZXhTdHlsZRIWCgZyYWRpdXMYASABKAFSBnJhZGl1cxImCgVjb2xvchgCIAEoCzIQLm'
    '1vdGlmLkNvbG9yRGF0YVIFY29sb3IaaAoHUGFydGlhbBIbCgZyYWRpdXMYASABKAFIAFIGcmFk'
    'aXVziAEBEisKBWNvbG9yGAIgASgLMhAubW90aWYuQ29sb3JEYXRhSAFSBWNvbG9yiAEBQgkKB1'
    '9yYWRpdXNCCAoGX2NvbG9y');

@$core.Deprecated('Use edgeStyleDescriptor instead')
const EdgeStyle$json = {
  '1': 'EdgeStyle',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 1, '10': 'width'},
    {
      '1': 'color',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData',
      '10': 'color'
    },
  ],
  '3': [EdgeStyle_Partial$json],
};

@$core.Deprecated('Use edgeStyleDescriptor instead')
const EdgeStyle_Partial$json = {
  '1': 'Partial',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'width', '17': true},
    {
      '1': 'color',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData',
      '9': 1,
      '10': 'color',
      '17': true
    },
  ],
  '8': [
    {'1': '_width'},
    {'1': '_color'},
  ],
};

/// Descriptor for `EdgeStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeStyleDescriptor = $convert.base64Decode(
    'CglFZGdlU3R5bGUSFAoFd2lkdGgYASABKAFSBXdpZHRoEiYKBWNvbG9yGAIgASgLMhAubW90aW'
    'YuQ29sb3JEYXRhUgVjb2xvchplCgdQYXJ0aWFsEhkKBXdpZHRoGAEgASgBSABSBXdpZHRoiAEB'
    'EisKBWNvbG9yGAIgASgLMhAubW90aWYuQ29sb3JEYXRhSAFSBWNvbG9yiAEBQggKBl93aWR0aE'
    'IICgZfY29sb3I=');

@$core.Deprecated('Use faceStyleDescriptor instead')
const FaceStyle$json = {
  '1': 'FaceStyle',
  '2': [
    {
      '1': 'color',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData',
      '10': 'color'
    },
  ],
  '3': [FaceStyle_Partial$json],
};

@$core.Deprecated('Use faceStyleDescriptor instead')
const FaceStyle_Partial$json = {
  '1': 'Partial',
  '2': [
    {
      '1': 'color',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData',
      '9': 0,
      '10': 'color',
      '17': true
    },
  ],
  '8': [
    {'1': '_color'},
  ],
};

/// Descriptor for `FaceStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List faceStyleDescriptor = $convert.base64Decode(
    'CglGYWNlU3R5bGUSJgoFY29sb3IYASABKAsyEC5tb3RpZi5Db2xvckRhdGFSBWNvbG9yGkAKB1'
    'BhcnRpYWwSKwoFY29sb3IYASABKAsyEC5tb3RpZi5Db2xvckRhdGFIAFIFY29sb3KIAQFCCAoG'
    'X2NvbG9y');

@$core.Deprecated('Use cellSelectorDescriptor instead')
const CellSelector$json = {
  '1': 'CellSelector',
  '2': [
    {'1': 'ref', '3': 1, '4': 1, '5': 11, '6': '.motif.CellRef', '10': 'ref'},
  ],
};

/// Descriptor for `CellSelector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cellSelectorDescriptor = $convert.base64Decode(
    'CgxDZWxsU2VsZWN0b3ISIAoDcmVmGAEgASgLMg4ubW90aWYuQ2VsbFJlZlIDcmVm');

@$core.Deprecated('Use chainSelectorDescriptor instead')
const ChainSelector$json = {
  '1': 'ChainSelector',
  '2': [
    {
      '1': 'edges',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.CellRef',
      '10': 'edges'
    },
  ],
};

/// Descriptor for `ChainSelector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chainSelectorDescriptor = $convert.base64Decode(
    'Cg1DaGFpblNlbGVjdG9yEiQKBWVkZ2VzGAEgAygLMg4ubW90aWYuQ2VsbFJlZlIFZWRnZXM=');

@$core.Deprecated('Use fragmentSelectorDescriptor instead')
const FragmentSelector$json = {
  '1': 'FragmentSelector',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.motif.StatementId', '10': 'id'},
    {
      '1': 'modifierIndex',
      '3': 2,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'modifierIndex',
      '17': true
    },
  ],
  '8': [
    {'1': '_modifierIndex'},
  ],
};

/// Descriptor for `FragmentSelector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fragmentSelectorDescriptor = $convert.base64Decode(
    'ChBGcmFnbWVudFNlbGVjdG9yEiIKAmlkGAEgASgLMhIubW90aWYuU3RhdGVtZW50SWRSAmlkEi'
    'kKDW1vZGlmaWVySW5kZXgYAiABKAVIAFINbW9kaWZpZXJJbmRleIgBAUIQCg5fbW9kaWZpZXJJ'
    'bmRleA==');

@$core.Deprecated('Use parentSelectorDescriptor instead')
const ParentSelector$json = {
  '1': 'ParentSelector',
  '2': [
    {'1': 'ref', '3': 1, '4': 1, '5': 11, '6': '.motif.CellRef', '10': 'ref'},
  ],
};

/// Descriptor for `ParentSelector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parentSelectorDescriptor = $convert.base64Decode(
    'Cg5QYXJlbnRTZWxlY3RvchIgCgNyZWYYASABKAsyDi5tb3RpZi5DZWxsUmVmUgNyZWY=');

@$core.Deprecated('Use selectorDescriptor instead')
const Selector$json = {
  '1': 'Selector',
  '2': [
    {
      '1': 'cell',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.CellSelector',
      '9': 0,
      '10': 'cell'
    },
    {
      '1': 'parent',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ParentSelector',
      '9': 0,
      '10': 'parent'
    },
    {
      '1': 'chain',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ChainSelector',
      '9': 0,
      '10': 'chain'
    },
    {
      '1': 'fragment',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.FragmentSelector',
      '9': 0,
      '10': 'fragment'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `Selector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectorDescriptor = $convert.base64Decode(
    'CghTZWxlY3RvchIpCgRjZWxsGAEgASgLMhMubW90aWYuQ2VsbFNlbGVjdG9ySABSBGNlbGwSLw'
    'oGcGFyZW50GAIgASgLMhUubW90aWYuUGFyZW50U2VsZWN0b3JIAFIGcGFyZW50EiwKBWNoYWlu'
    'GAMgASgLMhQubW90aWYuQ2hhaW5TZWxlY3RvckgAUgVjaGFpbhI1CghmcmFnbWVudBgEIAEoCz'
    'IXLm1vdGlmLkZyYWdtZW50U2VsZWN0b3JIAFIIZnJhZ21lbnRCBwoFdmFsdWU=');

@$core.Deprecated('Use singleSelectorDescriptor instead')
const SingleSelector$json = {
  '1': 'SingleSelector',
  '2': [
    {
      '1': 'cell',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.CellSelector',
      '9': 0,
      '10': 'cell'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `SingleSelector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List singleSelectorDescriptor = $convert.base64Decode(
    'Cg5TaW5nbGVTZWxlY3RvchIpCgRjZWxsGAEgASgLMhMubW90aWYuQ2VsbFNlbGVjdG9ySABSBG'
    'NlbGxCBwoFdmFsdWU=');

@$core.Deprecated('Use frameStatementDescriptor instead')
const FrameStatement$json = {
  '1': 'FrameStatement',
  '2': [
    {
      '1': 'transform',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Mat4',
      '10': 'transform'
    },
    {
      '1': 'size',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Size2',
      '9': 0,
      '10': 'size',
      '17': true
    },
    {
      '1': 'parent',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 1,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_size'},
    {'1': '_parent'},
  ],
};

/// Descriptor for `FrameStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List frameStatementDescriptor = $convert.base64Decode(
    'Cg5GcmFtZVN0YXRlbWVudBIpCgl0cmFuc2Zvcm0YASABKAsyCy5tb3RpZi5NYXQ0Ugl0cmFuc2'
    'Zvcm0SJQoEc2l6ZRgCIAEoCzIMLm1vdGlmLlNpemUySABSBHNpemWIAQESKwoGcGFyZW50GAMg'
    'ASgLMg4ubW90aWYuQ2VsbFJlZkgBUgZwYXJlbnSIAQFCBwoFX3NpemVCCQoHX3BhcmVudA==');

@$core.Deprecated('Use vertexStatementDescriptor instead')
const VertexStatement$json = {
  '1': 'VertexStatement',
  '2': [
    {
      '1': 'position',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '10': 'position'
    },
    {
      '1': 'style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '10': 'style'
    },
    {
      '1': 'parent',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `VertexStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vertexStatementDescriptor = $convert.base64Decode(
    'Cg9WZXJ0ZXhTdGF0ZW1lbnQSJwoIcG9zaXRpb24YASABKAsyCy5tb3RpZi5WZWMyUghwb3NpdG'
    'lvbhIoCgVzdHlsZRgCIAEoCzISLm1vdGlmLlZlcnRleFN0eWxlUgVzdHlsZRIrCgZwYXJlbnQY'
    'AyABKAsyDi5tb3RpZi5DZWxsUmVmSABSBnBhcmVudIgBAUIJCgdfcGFyZW50');

@$core.Deprecated('Use edgeStatementDescriptor instead')
const EdgeStatement$json = {
  '1': 'EdgeStatement',
  '2': [
    {
      '1': 'start',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.SingleSelector',
      '10': 'start'
    },
    {
      '1': 'end',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.SingleSelector',
      '10': 'end'
    },
    {
      '1': 'start_tangent',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'startTangent',
      '17': true
    },
    {
      '1': 'end_tangent',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 1,
      '10': 'endTangent',
      '17': true
    },
    {
      '1': 'style',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '10': 'style'
    },
    {
      '1': 'parent',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 2,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_start_tangent'},
    {'1': '_end_tangent'},
    {'1': '_parent'},
  ],
};

/// Descriptor for `EdgeStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeStatementDescriptor = $convert.base64Decode(
    'Cg1FZGdlU3RhdGVtZW50EisKBXN0YXJ0GAEgASgLMhUubW90aWYuU2luZ2xlU2VsZWN0b3JSBX'
    'N0YXJ0EicKA2VuZBgCIAEoCzIVLm1vdGlmLlNpbmdsZVNlbGVjdG9yUgNlbmQSNQoNc3RhcnRf'
    'dGFuZ2VudBgDIAEoCzILLm1vdGlmLlZlYzJIAFIMc3RhcnRUYW5nZW50iAEBEjEKC2VuZF90YW'
    '5nZW50GAQgASgLMgsubW90aWYuVmVjMkgBUgplbmRUYW5nZW50iAEBEiYKBXN0eWxlGAUgASgL'
    'MhAubW90aWYuRWRnZVN0eWxlUgVzdHlsZRIrCgZwYXJlbnQYBiABKAsyDi5tb3RpZi5DZWxsUm'
    'VmSAJSBnBhcmVudIgBAUIQCg5fc3RhcnRfdGFuZ2VudEIOCgxfZW5kX3RhbmdlbnRCCQoHX3Bh'
    'cmVudA==');

@$core.Deprecated('Use faceStatementDescriptor instead')
const FaceStatement$json = {
  '1': 'FaceStatement',
  '2': [
    {
      '1': 'outer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ChainSelector',
      '10': 'outer'
    },
    {
      '1': 'holes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.ChainSelector',
      '10': 'holes'
    },
    {
      '1': 'style',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '10': 'style'
    },
    {
      '1': 'parent',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `FaceStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List faceStatementDescriptor = $convert.base64Decode(
    'Cg1GYWNlU3RhdGVtZW50EioKBW91dGVyGAEgASgLMhQubW90aWYuQ2hhaW5TZWxlY3RvclIFb3'
    'V0ZXISKgoFaG9sZXMYAiADKAsyFC5tb3RpZi5DaGFpblNlbGVjdG9yUgVob2xlcxImCgVzdHls'
    'ZRgDIAEoCzIQLm1vdGlmLkZhY2VTdHlsZVIFc3R5bGUSKwoGcGFyZW50GAQgASgLMg4ubW90aW'
    'YuQ2VsbFJlZkgAUgZwYXJlbnSIAQFCCQoHX3BhcmVudA==');

@$core.Deprecated('Use cutEdgeStatementDescriptor instead')
const CutEdgeStatement$json = {
  '1': 'CutEdgeStatement',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.SingleSelector',
      '10': 'target'
    },
    {'1': 't', '3': 2, '4': 1, '5': 1, '10': 't'},
  ],
};

/// Descriptor for `CutEdgeStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cutEdgeStatementDescriptor = $convert.base64Decode(
    'ChBDdXRFZGdlU3RhdGVtZW50Ei0KBnRhcmdldBgBIAEoCzIVLm1vdGlmLlNpbmdsZVNlbGVjdG'
    '9yUgZ0YXJnZXQSDAoBdBgCIAEoAVIBdA==');

@$core.Deprecated('Use multiCutEdgeStatementDescriptor instead')
const MultiCutEdgeStatement$json = {
  '1': 'MultiCutEdgeStatement',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.SingleSelector',
      '10': 'target'
    },
    {'1': 'ts', '3': 2, '4': 3, '5': 1, '10': 'ts'},
  ],
};

/// Descriptor for `MultiCutEdgeStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiCutEdgeStatementDescriptor = $convert.base64Decode(
    'ChVNdWx0aUN1dEVkZ2VTdGF0ZW1lbnQSLQoGdGFyZ2V0GAEgASgLMhUubW90aWYuU2luZ2xlU2'
    'VsZWN0b3JSBnRhcmdldBIOCgJ0cxgCIAMoAVICdHM=');

@$core.Deprecated('Use filletFaceStatementDescriptor instead')
const FilletFaceStatement$json = {
  '1': 'FilletFaceStatement',
  '2': [
    {
      '1': 'face',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.SingleSelector',
      '10': 'face'
    },
    {
      '1': 'corners',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.FilletFaceStatement.CornerEntry',
      '10': 'corners'
    },
    {
      '1': 'radius',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.CornerRadius',
      '9': 0,
      '10': 'radius',
      '17': true
    },
  ],
  '3': [FilletFaceStatement_CornerEntry$json],
  '8': [
    {'1': '_radius'},
  ],
};

@$core.Deprecated('Use filletFaceStatementDescriptor instead')
const FilletFaceStatement_CornerEntry$json = {
  '1': 'CornerEntry',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
    {
      '1': 'radius',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.CornerRadius',
      '10': 'radius'
    },
  ],
};

/// Descriptor for `FilletFaceStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List filletFaceStatementDescriptor = $convert.base64Decode(
    'ChNGaWxsZXRGYWNlU3RhdGVtZW50EikKBGZhY2UYASABKAsyFS5tb3RpZi5TaW5nbGVTZWxlY3'
    'RvclIEZmFjZRJACgdjb3JuZXJzGAIgAygLMiYubW90aWYuRmlsbGV0RmFjZVN0YXRlbWVudC5D'
    'b3JuZXJFbnRyeVIHY29ybmVycxIwCgZyYWRpdXMYAyABKAsyEy5tb3RpZi5Db3JuZXJSYWRpdX'
    'NIAFIGcmFkaXVziAEBGlAKC0Nvcm5lckVudHJ5EhQKBWluZGV4GAEgASgFUgVpbmRleBIrCgZy'
    'YWRpdXMYAiABKAsyEy5tb3RpZi5Db3JuZXJSYWRpdXNSBnJhZGl1c0IJCgdfcmFkaXVz');

@$core.Deprecated('Use glueVerticesStatementDescriptor instead')
const GlueVerticesStatement$json = {
  '1': 'GlueVerticesStatement',
  '2': [
    {
      '1': 'vertices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.SingleSelector',
      '10': 'vertices'
    },
    {
      '1': 'position',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.motif.GlueVerticesStatement.Position',
      '10': 'position'
    },
  ],
  '4': [GlueVerticesStatement_Position$json],
};

@$core.Deprecated('Use glueVerticesStatementDescriptor instead')
const GlueVerticesStatement_Position$json = {
  '1': 'Position',
  '2': [
    {'1': 'GLUE_VERTICES_STATEMENT_POSITION_FIRST', '2': 0},
    {'1': 'GLUE_VERTICES_STATEMENT_POSITION_CENTROID', '2': 1},
  ],
};

/// Descriptor for `GlueVerticesStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List glueVerticesStatementDescriptor = $convert.base64Decode(
    'ChVHbHVlVmVydGljZXNTdGF0ZW1lbnQSMQoIdmVydGljZXMYASADKAsyFS5tb3RpZi5TaW5nbG'
    'VTZWxlY3RvclIIdmVydGljZXMSQQoIcG9zaXRpb24YAiABKA4yJS5tb3RpZi5HbHVlVmVydGlj'
    'ZXNTdGF0ZW1lbnQuUG9zaXRpb25SCHBvc2l0aW9uImUKCFBvc2l0aW9uEioKJkdMVUVfVkVSVE'
    'lDRVNfU1RBVEVNRU5UX1BPU0lUSU9OX0ZJUlNUEAASLQopR0xVRV9WRVJUSUNFU19TVEFURU1F'
    'TlRfUE9TSVRJT05fQ0VOVFJPSUQQAQ==');

@$core.Deprecated('Use rectangleStatementDescriptor instead')
const RectangleStatement$json = {
  '1': 'RectangleStatement',
  '2': [
    {
      '1': 'size',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutSize',
      '10': 'size'
    },
    {
      '1': 'transform',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Mat4',
      '10': 'transform'
    },
    {
      '1': 'shape',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape.Rectangle',
      '10': 'shape'
    },
    {
      '1': 'vertex_style',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '10': 'vertexStyle'
    },
    {
      '1': 'edge_style',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'face_style',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '10': 'faceStyle'
    },
    {
      '1': 'parent',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `RectangleStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rectangleStatementDescriptor = $convert.base64Decode(
    'ChJSZWN0YW5nbGVTdGF0ZW1lbnQSJQoEc2l6ZRgBIAEoCzIRLm1vdGlmLkxheW91dFNpemVSBH'
    'NpemUSKQoJdHJhbnNmb3JtGAIgASgLMgsubW90aWYuTWF0NFIJdHJhbnNmb3JtEjIKBXNoYXBl'
    'GAMgASgLMhwubW90aWYuT2JqZWN0U2hhcGUuUmVjdGFuZ2xlUgVzaGFwZRI1Cgx2ZXJ0ZXhfc3'
    'R5bGUYBCABKAsyEi5tb3RpZi5WZXJ0ZXhTdHlsZVILdmVydGV4U3R5bGUSLwoKZWRnZV9zdHls'
    'ZRgFIAEoCzIQLm1vdGlmLkVkZ2VTdHlsZVIJZWRnZVN0eWxlEi8KCmZhY2Vfc3R5bGUYBiABKA'
    'syEC5tb3RpZi5GYWNlU3R5bGVSCWZhY2VTdHlsZRIrCgZwYXJlbnQYByABKAsyDi5tb3RpZi5D'
    'ZWxsUmVmSABSBnBhcmVudIgBAUIJCgdfcGFyZW50');

@$core.Deprecated('Use polygonStatementDescriptor instead')
const PolygonStatement$json = {
  '1': 'PolygonStatement',
  '2': [
    {
      '1': 'size',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutSize',
      '10': 'size'
    },
    {
      '1': 'transform',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Mat4',
      '10': 'transform'
    },
    {
      '1': 'shape',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape.Polygon',
      '10': 'shape'
    },
    {
      '1': 'vertex_style',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '10': 'vertexStyle'
    },
    {
      '1': 'edge_style',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'face_style',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '10': 'faceStyle'
    },
    {
      '1': 'parent',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `PolygonStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List polygonStatementDescriptor = $convert.base64Decode(
    'ChBQb2x5Z29uU3RhdGVtZW50EiUKBHNpemUYASABKAsyES5tb3RpZi5MYXlvdXRTaXplUgRzaX'
    'plEikKCXRyYW5zZm9ybRgCIAEoCzILLm1vdGlmLk1hdDRSCXRyYW5zZm9ybRIwCgVzaGFwZRgD'
    'IAEoCzIaLm1vdGlmLk9iamVjdFNoYXBlLlBvbHlnb25SBXNoYXBlEjUKDHZlcnRleF9zdHlsZR'
    'gEIAEoCzISLm1vdGlmLlZlcnRleFN0eWxlUgt2ZXJ0ZXhTdHlsZRIvCgplZGdlX3N0eWxlGAUg'
    'ASgLMhAubW90aWYuRWRnZVN0eWxlUgllZGdlU3R5bGUSLwoKZmFjZV9zdHlsZRgGIAEoCzIQLm'
    '1vdGlmLkZhY2VTdHlsZVIJZmFjZVN0eWxlEisKBnBhcmVudBgHIAEoCzIOLm1vdGlmLkNlbGxS'
    'ZWZIAFIGcGFyZW50iAEBQgkKB19wYXJlbnQ=');

@$core.Deprecated('Use ellipseStatementDescriptor instead')
const EllipseStatement$json = {
  '1': 'EllipseStatement',
  '2': [
    {
      '1': 'size',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutSize',
      '10': 'size'
    },
    {
      '1': 'transform',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Mat4',
      '10': 'transform'
    },
    {
      '1': 'shape',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape.Ellipse',
      '10': 'shape'
    },
    {
      '1': 'vertex_style',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '10': 'vertexStyle'
    },
    {
      '1': 'edge_style',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'face_style',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '10': 'faceStyle'
    },
    {
      '1': 'parent',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `EllipseStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ellipseStatementDescriptor = $convert.base64Decode(
    'ChBFbGxpcHNlU3RhdGVtZW50EiUKBHNpemUYASABKAsyES5tb3RpZi5MYXlvdXRTaXplUgRzaX'
    'plEikKCXRyYW5zZm9ybRgCIAEoCzILLm1vdGlmLk1hdDRSCXRyYW5zZm9ybRIwCgVzaGFwZRgD'
    'IAEoCzIaLm1vdGlmLk9iamVjdFNoYXBlLkVsbGlwc2VSBXNoYXBlEjUKDHZlcnRleF9zdHlsZR'
    'gEIAEoCzISLm1vdGlmLlZlcnRleFN0eWxlUgt2ZXJ0ZXhTdHlsZRIvCgplZGdlX3N0eWxlGAUg'
    'ASgLMhAubW90aWYuRWRnZVN0eWxlUgllZGdlU3R5bGUSLwoKZmFjZV9zdHlsZRgGIAEoCzIQLm'
    '1vdGlmLkZhY2VTdHlsZVIJZmFjZVN0eWxlEisKBnBhcmVudBgHIAEoCzIOLm1vdGlmLkNlbGxS'
    'ZWZIAFIGcGFyZW50iAEBQgkKB19wYXJlbnQ=');

@$core.Deprecated('Use containerStatementDescriptor instead')
const ContainerStatement$json = {
  '1': 'ContainerStatement',
  '2': [
    {
      '1': 'layout',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Layout',
      '10': 'layout'
    },
    {
      '1': 'size',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutSize',
      '10': 'size'
    },
    {
      '1': 'transform',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.Mat4',
      '10': 'transform'
    },
    {
      '1': 'shape',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape',
      '10': 'shape'
    },
    {
      '1': 'vertex_style',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '10': 'vertexStyle'
    },
    {
      '1': 'edge_style',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'face_style',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '10': 'faceStyle'
    },
    {
      '1': 'parent',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `ContainerStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List containerStatementDescriptor = $convert.base64Decode(
    'ChJDb250YWluZXJTdGF0ZW1lbnQSJQoGbGF5b3V0GAEgASgLMg0ubW90aWYuTGF5b3V0UgZsYX'
    'lvdXQSJQoEc2l6ZRgCIAEoCzIRLm1vdGlmLkxheW91dFNpemVSBHNpemUSKQoJdHJhbnNmb3Jt'
    'GAMgASgLMgsubW90aWYuTWF0NFIJdHJhbnNmb3JtEigKBXNoYXBlGAQgASgLMhIubW90aWYuT2'
    'JqZWN0U2hhcGVSBXNoYXBlEjUKDHZlcnRleF9zdHlsZRgFIAEoCzISLm1vdGlmLlZlcnRleFN0'
    'eWxlUgt2ZXJ0ZXhTdHlsZRIvCgplZGdlX3N0eWxlGAYgASgLMhAubW90aWYuRWRnZVN0eWxlUg'
    'llZGdlU3R5bGUSLwoKZmFjZV9zdHlsZRgHIAEoCzIQLm1vdGlmLkZhY2VTdHlsZVIJZmFjZVN0'
    'eWxlEisKBnBhcmVudBgIIAEoCzIOLm1vdGlmLkNlbGxSZWZIAFIGcGFyZW50iAEBQgkKB19wYX'
    'JlbnQ=');

@$core.Deprecated('Use groupStatementDescriptor instead')
const GroupStatement$json = {
  '1': 'GroupStatement',
  '2': [
    {
      '1': 'parent',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `GroupStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupStatementDescriptor = $convert.base64Decode(
    'Cg5Hcm91cFN0YXRlbWVudBIrCgZwYXJlbnQYASABKAsyDi5tb3RpZi5DZWxsUmVmSABSBnBhcm'
    'VudIgBAUIJCgdfcGFyZW50');

@$core.Deprecated('Use generatorStatementDescriptor instead')
const GeneratorStatement$json = {
  '1': 'GeneratorStatement',
  '2': [
    {
      '1': 'generator',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Generator',
      '10': 'generator'
    },
    {
      '1': 'inputs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.FragmentSelector',
      '10': 'inputs'
    },
    {
      '1': 'parent',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
    {
      '1': 'transform',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.Mat4',
      '10': 'transform'
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `GeneratorStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatorStatementDescriptor = $convert.base64Decode(
    'ChJHZW5lcmF0b3JTdGF0ZW1lbnQSLgoJZ2VuZXJhdG9yGAEgASgLMhAubW90aWYuR2VuZXJhdG'
    '9yUglnZW5lcmF0b3ISLwoGaW5wdXRzGAIgAygLMhcubW90aWYuRnJhZ21lbnRTZWxlY3RvclIG'
    'aW5wdXRzEisKBnBhcmVudBgDIAEoCzIOLm1vdGlmLkNlbGxSZWZIAFIGcGFyZW50iAEBEikKCX'
    'RyYW5zZm9ybRgEIAEoCzILLm1vdGlmLk1hdDRSCXRyYW5zZm9ybUIJCgdfcGFyZW50');

@$core.Deprecated('Use textStatementDescriptor instead')
const TextStatement$json = {
  '1': 'TextStatement',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {
      '1': 'size',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutSize',
      '10': 'size'
    },
    {
      '1': 'transform',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.Mat4',
      '10': 'transform'
    },
    {
      '1': 'parent',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 0,
      '10': 'parent',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent'},
  ],
};

/// Descriptor for `TextStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textStatementDescriptor = $convert.base64Decode(
    'Cg1UZXh0U3RhdGVtZW50EhIKBHRleHQYASABKAlSBHRleHQSJQoEc2l6ZRgCIAEoCzIRLm1vdG'
    'lmLkxheW91dFNpemVSBHNpemUSKQoJdHJhbnNmb3JtGAMgASgLMgsubW90aWYuTWF0NFIJdHJh'
    'bnNmb3JtEisKBnBhcmVudBgEIAEoCzIOLm1vdGlmLkNlbGxSZWZIAFIGcGFyZW50iAEBQgkKB1'
    '9wYXJlbnQ=');

@$core.Deprecated('Use objectShapeDescriptor instead')
const ObjectShape$json = {
  '1': 'ObjectShape',
  '2': [
    {
      '1': 'rectangle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape.Rectangle',
      '9': 0,
      '10': 'rectangle'
    },
    {
      '1': 'polygon',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape.Polygon',
      '9': 0,
      '10': 'polygon'
    },
    {
      '1': 'ellipse',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape.Ellipse',
      '9': 0,
      '10': 'ellipse'
    },
  ],
  '3': [
    ObjectShape_Rectangle$json,
    ObjectShape_Polygon$json,
    ObjectShape_Ellipse$json
  ],
  '8': [
    {'1': 'value'},
  ],
};

@$core.Deprecated('Use objectShapeDescriptor instead')
const ObjectShape_Rectangle$json = {
  '1': 'Rectangle',
};

@$core.Deprecated('Use objectShapeDescriptor instead')
const ObjectShape_Polygon$json = {
  '1': 'Polygon',
  '2': [
    {'1': 'sides', '3': 1, '4': 1, '5': 5, '10': 'sides'},
  ],
};

@$core.Deprecated('Use objectShapeDescriptor instead')
const ObjectShape_Ellipse$json = {
  '1': 'Ellipse',
};

/// Descriptor for `ObjectShape`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List objectShapeDescriptor = $convert.base64Decode(
    'CgtPYmplY3RTaGFwZRI8CglyZWN0YW5nbGUYASABKAsyHC5tb3RpZi5PYmplY3RTaGFwZS5SZW'
    'N0YW5nbGVIAFIJcmVjdGFuZ2xlEjYKB3BvbHlnb24YAiABKAsyGi5tb3RpZi5PYmplY3RTaGFw'
    'ZS5Qb2x5Z29uSABSB3BvbHlnb24SNgoHZWxsaXBzZRgDIAEoCzIaLm1vdGlmLk9iamVjdFNoYX'
    'BlLkVsbGlwc2VIAFIHZWxsaXBzZRoLCglSZWN0YW5nbGUaHwoHUG9seWdvbhIUCgVzaWRlcxgB'
    'IAEoBVIFc2lkZXMaCQoHRWxsaXBzZUIHCgV2YWx1ZQ==');

@$core.Deprecated('Use layoutSizeDescriptor instead')
const LayoutSize$json = {
  '1': 'LayoutSize',
  '2': [
    {
      '1': 'width',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutDimension',
      '10': 'width'
    },
    {
      '1': 'height',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutDimension',
      '10': 'height'
    },
  ],
};

/// Descriptor for `LayoutSize`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutSizeDescriptor = $convert.base64Decode(
    'CgpMYXlvdXRTaXplEiwKBXdpZHRoGAEgASgLMhYubW90aWYuTGF5b3V0RGltZW5zaW9uUgV3aW'
    'R0aBIuCgZoZWlnaHQYAiABKAsyFi5tb3RpZi5MYXlvdXREaW1lbnNpb25SBmhlaWdodA==');

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
      '6': '.motif.LayoutDimension.Type',
      '10': 'type'
    },
    {
      '1': 'range',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutDimension.Range',
      '10': 'range'
    },
  ],
  '3': [LayoutDimension_Range$json],
  '4': [LayoutDimension_Type$json],
  '8': [
    {'1': '_value'},
  ],
};

@$core.Deprecated('Use layoutDimensionDescriptor instead')
const LayoutDimension_Range$json = {
  '1': 'Range',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 1, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 1, '10': 'max'},
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
    'Cg9MYXlvdXREaW1lbnNpb24SGQoFdmFsdWUYASABKAFIAFIFdmFsdWWIAQESLwoEdHlwZRgCIA'
    'EoDjIbLm1vdGlmLkxheW91dERpbWVuc2lvbi5UeXBlUgR0eXBlEjIKBXJhbmdlGAMgASgLMhwu'
    'bW90aWYuTGF5b3V0RGltZW5zaW9uLlJhbmdlUgVyYW5nZRorCgVSYW5nZRIQCgNtaW4YASABKA'
    'FSA21pbhIQCgNtYXgYAiABKAFSA21heCJsCgRUeXBlEh8KG0xBWU9VVF9ESU1FTlNJT05fVFlQ'
    'RV9GSVhFRBAAEiAKHExBWU9VVF9ESU1FTlNJT05fVFlQRV9FWFBBTkQQARIhCh1MQVlPVVRfRE'
    'lNRU5TSU9OX1RZUEVfQ09OVEFJThACQggKBl92YWx1ZQ==');

@$core.Deprecated('Use layoutDescriptor instead')
const Layout$json = {
  '1': 'Layout',
  '2': [
    {
      '1': 'stack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Layout.Stack',
      '9': 0,
      '10': 'stack'
    },
    {
      '1': 'flex',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Layout.Flex',
      '9': 0,
      '10': 'flex'
    },
  ],
  '3': [Layout_Insets$json, Layout_Stack$json, Layout_Flex$json],
  '4': [Layout_Align$json, Layout_Justify$json],
  '8': [
    {'1': 'value'},
  ],
};

@$core.Deprecated('Use layoutDescriptor instead')
const Layout_Insets$json = {
  '1': 'Insets',
  '2': [
    {'1': 'top', '3': 1, '4': 1, '5': 1, '10': 'top'},
    {'1': 'right', '3': 2, '4': 1, '5': 1, '10': 'right'},
    {'1': 'bottom', '3': 3, '4': 1, '5': 1, '10': 'bottom'},
    {'1': 'left', '3': 4, '4': 1, '5': 1, '10': 'left'},
  ],
};

@$core.Deprecated('Use layoutDescriptor instead')
const Layout_Stack$json = {
  '1': 'Stack',
  '2': [
    {
      '1': 'align_horizontal',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.motif.Layout.Align',
      '9': 0,
      '10': 'alignHorizontal',
      '17': true
    },
    {
      '1': 'align_vertical',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.motif.Layout.Align',
      '9': 1,
      '10': 'alignVertical',
      '17': true
    },
    {
      '1': 'padding',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.Layout.Insets',
      '10': 'padding'
    },
  ],
  '8': [
    {'1': '_align_horizontal'},
    {'1': '_align_vertical'},
  ],
};

@$core.Deprecated('Use layoutDescriptor instead')
const Layout_Flex$json = {
  '1': 'Flex',
  '2': [
    {
      '1': 'direction',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.motif.Layout.Flex.Direction',
      '10': 'direction'
    },
    {
      '1': 'justify',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.motif.Layout.Justify',
      '10': 'justify'
    },
    {
      '1': 'cross_align',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.motif.Layout.Align',
      '10': 'crossAlign'
    },
    {'1': 'gap', '3': 4, '4': 1, '5': 1, '10': 'gap'},
    {
      '1': 'padding',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.Layout.Insets',
      '10': 'padding'
    },
  ],
  '4': [Layout_Flex_Direction$json],
};

@$core.Deprecated('Use layoutDescriptor instead')
const Layout_Flex_Direction$json = {
  '1': 'Direction',
  '2': [
    {'1': 'LAYOUT_FLEX_DIRECTION_ROW', '2': 0},
    {'1': 'LAYOUT_FLEX_DIRECTION_COLUMN', '2': 1},
  ],
};

@$core.Deprecated('Use layoutDescriptor instead')
const Layout_Align$json = {
  '1': 'Align',
  '2': [
    {'1': 'LAYOUT_ALIGN_START', '2': 0},
    {'1': 'LAYOUT_ALIGN_CENTER', '2': 1},
    {'1': 'LAYOUT_ALIGN_END', '2': 2},
  ],
};

@$core.Deprecated('Use layoutDescriptor instead')
const Layout_Justify$json = {
  '1': 'Justify',
  '2': [
    {'1': 'LAYOUT_JUSTIFY_START', '2': 0},
    {'1': 'LAYOUT_JUSTIFY_CENTER', '2': 1},
    {'1': 'LAYOUT_JUSTIFY_END', '2': 2},
    {'1': 'LAYOUT_JUSTIFY_SPACE_BETWEEN', '2': 3},
  ],
};

/// Descriptor for `Layout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutDescriptor = $convert.base64Decode(
    'CgZMYXlvdXQSKwoFc3RhY2sYASABKAsyEy5tb3RpZi5MYXlvdXQuU3RhY2tIAFIFc3RhY2sSKA'
    'oEZmxleBgCIAEoCzISLm1vdGlmLkxheW91dC5GbGV4SABSBGZsZXgaXAoGSW5zZXRzEhAKA3Rv'
    'cBgBIAEoAVIDdG9wEhQKBXJpZ2h0GAIgASgBUgVyaWdodBIWCgZib3R0b20YAyABKAFSBmJvdH'
    'RvbRISCgRsZWZ0GAQgASgBUgRsZWZ0GuUBCgVTdGFjaxJDChBhbGlnbl9ob3Jpem9udGFsGAEg'
    'ASgOMhMubW90aWYuTGF5b3V0LkFsaWduSABSD2FsaWduSG9yaXpvbnRhbIgBARI/Cg5hbGlnbl'
    '92ZXJ0aWNhbBgCIAEoDjITLm1vdGlmLkxheW91dC5BbGlnbkgBUg1hbGlnblZlcnRpY2FsiAEB'
    'Ei4KB3BhZGRpbmcYBSABKAsyFC5tb3RpZi5MYXlvdXQuSW5zZXRzUgdwYWRkaW5nQhMKEV9hbG'
    'lnbl9ob3Jpem9udGFsQhEKD19hbGlnbl92ZXJ0aWNhbBq5AgoERmxleBI6CglkaXJlY3Rpb24Y'
    'ASABKA4yHC5tb3RpZi5MYXlvdXQuRmxleC5EaXJlY3Rpb25SCWRpcmVjdGlvbhIvCgdqdXN0aW'
    'Z5GAIgASgOMhUubW90aWYuTGF5b3V0Lkp1c3RpZnlSB2p1c3RpZnkSNAoLY3Jvc3NfYWxpZ24Y'
    'AyABKA4yEy5tb3RpZi5MYXlvdXQuQWxpZ25SCmNyb3NzQWxpZ24SEAoDZ2FwGAQgASgBUgNnYX'
    'ASLgoHcGFkZGluZxgFIAEoCzIULm1vdGlmLkxheW91dC5JbnNldHNSB3BhZGRpbmciTAoJRGly'
    'ZWN0aW9uEh0KGUxBWU9VVF9GTEVYX0RJUkVDVElPTl9ST1cQABIgChxMQVlPVVRfRkxFWF9ESV'
    'JFQ1RJT05fQ09MVU1OEAEiTgoFQWxpZ24SFgoSTEFZT1VUX0FMSUdOX1NUQVJUEAASFwoTTEFZ'
    'T1VUX0FMSUdOX0NFTlRFUhABEhQKEExBWU9VVF9BTElHTl9FTkQQAiJ4CgdKdXN0aWZ5EhgKFE'
    'xBWU9VVF9KVVNUSUZZX1NUQVJUEAASGQoVTEFZT1VUX0pVU1RJRllfQ0VOVEVSEAESFgoSTEFZ'
    'T1VUX0pVU1RJRllfRU5EEAISIAocTEFZT1VUX0pVU1RJRllfU1BBQ0VfQkVUV0VFThADQgcKBX'
    'ZhbHVl');

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

@$core.Deprecated('Use nodeDescriptor instead')
const Node$json = {
  '1': 'Node',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.motif.NodeId', '10': 'id'},
    {
      '1': 'array',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Array',
      '9': 0,
      '10': 'array'
    },
    {
      '1': 'random_vector',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.RandomVector',
      '9': 0,
      '10': 'randomVector'
    },
    {
      '1': 'fillet',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Fillet',
      '9': 0,
      '10': 'fillet'
    },
    {
      '1': 'generator_input',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.GeneratorInput',
      '9': 0,
      '10': 'generatorInput'
    },
    {
      '1': 'generator_output',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.GeneratorOutput',
      '9': 0,
      '10': 'generatorOutput'
    },
    {
      '1': 'polar',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Polar',
      '9': 0,
      '10': 'polar'
    },
    {
      '1': 'pi',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Pi',
      '9': 0,
      '10': 'pi'
    },
    {
      '1': 'divide',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Divide',
      '9': 0,
      '10': 'divide'
    },
    {
      '1': 'vertices',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Vertices',
      '9': 0,
      '10': 'vertices'
    },
    {
      '1': 'connect_vertices',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.ConnectVertices',
      '9': 0,
      '10': 'connectVertices'
    },
    {
      '1': 'face',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Face',
      '9': 0,
      '10': 'face'
    },
    {
      '1': 'number',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Number',
      '9': 0,
      '10': 'number'
    },
    {
      '1': 'vector',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Vector',
      '9': 0,
      '10': 'vector'
    },
    {
      '1': 'index',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Index',
      '9': 0,
      '10': 'index'
    },
    {
      '1': 'scale_vector',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.ScaleVector',
      '9': 0,
      '10': 'scaleVector'
    },
  ],
  '3': [
    Node_Array$json,
    Node_RandomVector$json,
    Node_Fillet$json,
    Node_GeneratorInput$json,
    Node_GeneratorOutput$json,
    Node_Polar$json,
    Node_Pi$json,
    Node_Divide$json,
    Node_Vertices$json,
    Node_ConnectVertices$json,
    Node_Face$json,
    Node_Number$json,
    Node_Vector$json,
    Node_Index$json,
    Node_ScaleVector$json
  ],
  '8': [
    {'1': 'kind'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Array$json = {
  '1': 'Array',
  '2': [
    {
      '1': 'count',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'count',
      '17': true
    },
    {
      '1': 'offset',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 1,
      '10': 'offset',
      '17': true
    },
    {
      '1': 'slice',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramSlice',
      '9': 2,
      '10': 'slice',
      '17': true
    },
  ],
  '8': [
    {'1': '_count'},
    {'1': '_offset'},
    {'1': '_slice'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_RandomVector$json = {
  '1': 'RandomVector',
  '2': [
    {'1': 'seed', '3': 1, '4': 1, '5': 5, '9': 0, '10': 'seed', '17': true},
    {
      '1': 'min',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 1,
      '10': 'min',
      '17': true
    },
    {
      '1': 'max',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 2,
      '10': 'max',
      '17': true
    },
  ],
  '8': [
    {'1': '_seed'},
    {'1': '_min'},
    {'1': '_max'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Fillet$json = {
  '1': 'Fillet',
  '2': [
    {
      '1': 'radius',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'radius',
      '17': true
    },
    {
      '1': 'slice',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramSlice',
      '9': 1,
      '10': 'slice',
      '17': true
    },
  ],
  '8': [
    {'1': '_radius'},
    {'1': '_slice'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_GeneratorInput$json = {
  '1': 'GeneratorInput',
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_GeneratorOutput$json = {
  '1': 'GeneratorOutput',
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Polar$json = {
  '1': 'Polar',
  '2': [
    {'1': 'angle', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'angle', '17': true},
    {'1': 'radius', '3': 2, '4': 1, '5': 1, '9': 1, '10': 'radius', '17': true},
  ],
  '8': [
    {'1': '_angle'},
    {'1': '_radius'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Pi$json = {
  '1': 'Pi',
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Divide$json = {
  '1': 'Divide',
  '2': [
    {
      '1': 'numerator',
      '3': 1,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'numerator',
      '17': true
    },
    {
      '1': 'denominator',
      '3': 2,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'denominator',
      '17': true
    },
  ],
  '8': [
    {'1': '_numerator'},
    {'1': '_denominator'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Vertices$json = {
  '1': 'Vertices',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 5, '9': 0, '10': 'count', '17': true},
    {
      '1': 'position',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 1,
      '10': 'position',
      '17': true
    },
  ],
  '8': [
    {'1': '_count'},
    {'1': '_position'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_ConnectVertices$json = {
  '1': 'ConnectVertices',
  '2': [
    {
      '1': 'slice',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramSlice',
      '9': 0,
      '10': 'slice',
      '17': true
    },
    {'1': 'closed', '3': 2, '4': 1, '5': 8, '9': 1, '10': 'closed', '17': true},
  ],
  '8': [
    {'1': '_slice'},
    {'1': '_closed'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Face$json = {
  '1': 'Face',
  '2': [
    {
      '1': 'slice',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramSlice',
      '9': 0,
      '10': 'slice',
      '17': true
    },
  ],
  '8': [
    {'1': '_slice'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Number$json = {
  '1': 'Number',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'value', '17': true},
  ],
  '8': [
    {'1': '_value'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Vector$json = {
  '1': 'Vector',
  '2': [
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'value',
      '17': true
    },
  ],
  '8': [
    {'1': '_value'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Index$json = {
  '1': 'Index',
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_ScaleVector$json = {
  '1': 'ScaleVector',
  '2': [
    {
      '1': 'vector',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'vector',
      '17': true
    },
    {'1': 'factor', '3': 2, '4': 1, '5': 1, '9': 1, '10': 'factor', '17': true},
  ],
  '8': [
    {'1': '_vector'},
    {'1': '_factor'},
  ],
};

/// Descriptor for `Node`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodeDescriptor = $convert.base64Decode(
    'CgROb2RlEh0KAmlkGAEgASgLMg0ubW90aWYuTm9kZUlkUgJpZBIpCgVhcnJheRgKIAEoCzIRLm'
    '1vdGlmLk5vZGUuQXJyYXlIAFIFYXJyYXkSPwoNcmFuZG9tX3ZlY3RvchgLIAEoCzIYLm1vdGlm'
    'Lk5vZGUuUmFuZG9tVmVjdG9ySABSDHJhbmRvbVZlY3RvchIsCgZmaWxsZXQYDCABKAsyEi5tb3'
    'RpZi5Ob2RlLkZpbGxldEgAUgZmaWxsZXQSRQoPZ2VuZXJhdG9yX2lucHV0GA0gASgLMhoubW90'
    'aWYuTm9kZS5HZW5lcmF0b3JJbnB1dEgAUg5nZW5lcmF0b3JJbnB1dBJIChBnZW5lcmF0b3Jfb3'
    'V0cHV0GA4gASgLMhsubW90aWYuTm9kZS5HZW5lcmF0b3JPdXRwdXRIAFIPZ2VuZXJhdG9yT3V0'
    'cHV0EikKBXBvbGFyGA8gASgLMhEubW90aWYuTm9kZS5Qb2xhckgAUgVwb2xhchIgCgJwaRgQIA'
    'EoCzIOLm1vdGlmLk5vZGUuUGlIAFICcGkSLAoGZGl2aWRlGBEgASgLMhIubW90aWYuTm9kZS5E'
    'aXZpZGVIAFIGZGl2aWRlEjIKCHZlcnRpY2VzGBIgASgLMhQubW90aWYuTm9kZS5WZXJ0aWNlc0'
    'gAUgh2ZXJ0aWNlcxJIChBjb25uZWN0X3ZlcnRpY2VzGBMgASgLMhsubW90aWYuTm9kZS5Db25u'
    'ZWN0VmVydGljZXNIAFIPY29ubmVjdFZlcnRpY2VzEiYKBGZhY2UYFCABKAsyEC5tb3RpZi5Ob2'
    'RlLkZhY2VIAFIEZmFjZRIsCgZudW1iZXIYFSABKAsyEi5tb3RpZi5Ob2RlLk51bWJlckgAUgZu'
    'dW1iZXISLAoGdmVjdG9yGBYgASgLMhIubW90aWYuTm9kZS5WZWN0b3JIAFIGdmVjdG9yEikKBW'
    'luZGV4GBcgASgLMhEubW90aWYuTm9kZS5JbmRleEgAUgVpbmRleBI8CgxzY2FsZV92ZWN0b3IY'
    'GCABKAsyFy5tb3RpZi5Ob2RlLlNjYWxlVmVjdG9ySABSC3NjYWxlVmVjdG9yGqgBCgVBcnJheR'
    'ImCgVjb3VudBgBIAEoCzILLm1vdGlmLlZlYzJIAFIFY291bnSIAQESKAoGb2Zmc2V0GAIgASgL'
    'MgsubW90aWYuVmVjMkgBUgZvZmZzZXSIAQESLgoFc2xpY2UYAyABKAsyEy5tb3RpZi5Qcm9ncm'
    'FtU2xpY2VIAlIFc2xpY2WIAQFCCAoGX2NvdW50QgkKB19vZmZzZXRCCAoGX3NsaWNlGogBCgxS'
    'YW5kb21WZWN0b3ISFwoEc2VlZBgBIAEoBUgAUgRzZWVkiAEBEiIKA21pbhgCIAEoCzILLm1vdG'
    'lmLlZlYzJIAVIDbWluiAEBEiIKA21heBgDIAEoCzILLm1vdGlmLlZlYzJIAlIDbWF4iAEBQgcK'
    'BV9zZWVkQgYKBF9taW5CBgoEX21heBp3CgZGaWxsZXQSKAoGcmFkaXVzGAEgASgLMgsubW90aW'
    'YuVmVjMkgAUgZyYWRpdXOIAQESLgoFc2xpY2UYAiABKAsyEy5tb3RpZi5Qcm9ncmFtU2xpY2VI'
    'AVIFc2xpY2WIAQFCCQoHX3JhZGl1c0IICgZfc2xpY2UaEAoOR2VuZXJhdG9ySW5wdXQaEQoPR2'
    'VuZXJhdG9yT3V0cHV0GlQKBVBvbGFyEhkKBWFuZ2xlGAEgASgBSABSBWFuZ2xliAEBEhsKBnJh'
    'ZGl1cxgCIAEoAUgBUgZyYWRpdXOIAQFCCAoGX2FuZ2xlQgkKB19yYWRpdXMaBAoCUGkacAoGRG'
    'l2aWRlEiEKCW51bWVyYXRvchgBIAEoAUgAUgludW1lcmF0b3KIAQESJQoLZGVub21pbmF0b3IY'
    'AiABKAFIAVILZGVub21pbmF0b3KIAQFCDAoKX251bWVyYXRvckIOCgxfZGVub21pbmF0b3Iaag'
    'oIVmVydGljZXMSGQoFY291bnQYASABKAVIAFIFY291bnSIAQESLAoIcG9zaXRpb24YAiABKAsy'
    'Cy5tb3RpZi5WZWMySAFSCHBvc2l0aW9uiAEBQggKBl9jb3VudEILCglfcG9zaXRpb24acwoPQ2'
    '9ubmVjdFZlcnRpY2VzEi4KBXNsaWNlGAEgASgLMhMubW90aWYuUHJvZ3JhbVNsaWNlSABSBXNs'
    'aWNliAEBEhsKBmNsb3NlZBgCIAEoCEgBUgZjbG9zZWSIAQFCCAoGX3NsaWNlQgkKB19jbG9zZW'
    'QaQAoERmFjZRIuCgVzbGljZRgBIAEoCzITLm1vdGlmLlByb2dyYW1TbGljZUgAUgVzbGljZYgB'
    'AUIICgZfc2xpY2UaLQoGTnVtYmVyEhkKBXZhbHVlGAEgASgBSABSBXZhbHVliAEBQggKBl92YW'
    'x1ZRo6CgZWZWN0b3ISJgoFdmFsdWUYAiABKAsyCy5tb3RpZi5WZWMySABSBXZhbHVliAEBQggK'
    'Bl92YWx1ZRoHCgVJbmRleBpqCgtTY2FsZVZlY3RvchIoCgZ2ZWN0b3IYASABKAsyCy5tb3RpZi'
    '5WZWMySABSBnZlY3RvcogBARIbCgZmYWN0b3IYAiABKAFIAVIGZmFjdG9yiAEBQgkKB192ZWN0'
    'b3JCCQoHX2ZhY3RvckIGCgRraW5k');

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

@$core.Deprecated('Use generatorDescriptor instead')
const Generator$json = {
  '1': 'Generator',
  '2': [
    {'1': 'nodes', '3': 1, '4': 3, '5': 11, '6': '.motif.Node', '10': 'nodes'},
    {
      '1': 'connections',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.Connection',
      '10': 'connections'
    },
    {
      '1': 'positions',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.motif.Generator.PositionEntry',
      '10': 'positions'
    },
    {
      '1': 'fixed',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.motif.NodeId',
      '10': 'fixed'
    },
  ],
  '3': [Generator_PositionEntry$json],
};

@$core.Deprecated('Use generatorDescriptor instead')
const Generator_PositionEntry$json = {
  '1': 'PositionEntry',
  '2': [
    {'1': 'node', '3': 1, '4': 1, '5': 11, '6': '.motif.NodeId', '10': 'node'},
    {
      '1': 'position',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '10': 'position'
    },
  ],
};

/// Descriptor for `Generator`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatorDescriptor = $convert.base64Decode(
    'CglHZW5lcmF0b3ISIQoFbm9kZXMYASADKAsyCy5tb3RpZi5Ob2RlUgVub2RlcxIzCgtjb25uZW'
    'N0aW9ucxgCIAMoCzIRLm1vdGlmLkNvbm5lY3Rpb25SC2Nvbm5lY3Rpb25zEjwKCXBvc2l0aW9u'
    'cxgDIAMoCzIeLm1vdGlmLkdlbmVyYXRvci5Qb3NpdGlvbkVudHJ5Uglwb3NpdGlvbnMSIwoFZm'
    'l4ZWQYBCADKAsyDS5tb3RpZi5Ob2RlSWRSBWZpeGVkGlsKDVBvc2l0aW9uRW50cnkSIQoEbm9k'
    'ZRgBIAEoCzINLm1vdGlmLk5vZGVJZFIEbm9kZRInCghwb3NpdGlvbhgCIAEoCzILLm1vdGlmLl'
    'ZlYzJSCHBvc2l0aW9u');

@$core.Deprecated('Use modifierDescriptor instead')
const Modifier$json = {
  '1': 'Modifier',
  '2': [
    {
      '1': 'fillet',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.FilletModifier',
      '9': 0,
      '10': 'fillet'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `Modifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modifierDescriptor = $convert.base64Decode(
    'CghNb2RpZmllchIvCgZmaWxsZXQYASABKAsyFS5tb3RpZi5GaWxsZXRNb2RpZmllckgAUgZmaW'
    'xsZXRCBwoFdmFsdWU=');

@$core.Deprecated('Use filletModifierDescriptor instead')
const FilletModifier$json = {
  '1': 'FilletModifier',
  '2': [
    {
      '1': 'radius',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.CornerRadius',
      '9': 0,
      '10': 'radius',
      '17': true
    },
    {
      '1': 'corners',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.FilletModifier.Corner',
      '10': 'corners'
    },
  ],
  '3': [FilletModifier_Corner$json],
  '8': [
    {'1': '_radius'},
  ],
};

@$core.Deprecated('Use filletModifierDescriptor instead')
const FilletModifier_Corner$json = {
  '1': 'Corner',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
    {
      '1': 'radius',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.CornerRadius',
      '10': 'radius'
    },
  ],
};

/// Descriptor for `FilletModifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List filletModifierDescriptor = $convert.base64Decode(
    'Cg5GaWxsZXRNb2RpZmllchIwCgZyYWRpdXMYASABKAsyEy5tb3RpZi5Db3JuZXJSYWRpdXNIAF'
    'IGcmFkaXVziAEBEjYKB2Nvcm5lcnMYAiADKAsyHC5tb3RpZi5GaWxsZXRNb2RpZmllci5Db3Ju'
    'ZXJSB2Nvcm5lcnMaSwoGQ29ybmVyEhQKBWluZGV4GAEgASgFUgVpbmRleBIrCgZyYWRpdXMYAi'
    'ABKAsyEy5tb3RpZi5Db3JuZXJSYWRpdXNSBnJhZGl1c0IJCgdfcmFkaXVz');

@$core.Deprecated('Use programDeltaDescriptor instead')
const ProgramDelta$json = {
  '1': 'ProgramDelta',
  '2': [
    {
      '1': 'changes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.ProgramChange',
      '10': 'changes'
    },
  ],
};

/// Descriptor for `ProgramDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programDeltaDescriptor = $convert.base64Decode(
    'CgxQcm9ncmFtRGVsdGESLgoHY2hhbmdlcxgBIAMoCzIULm1vdGlmLlByb2dyYW1DaGFuZ2VSB2'
    'NoYW5nZXM=');

@$core.Deprecated('Use programAnchorDescriptor instead')
const ProgramAnchor$json = {
  '1': 'ProgramAnchor',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'end'},
    {
      '1': 'at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.StatementId',
      '9': 0,
      '10': 'at'
    },
    {
      '1': 'after',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.StatementId',
      '9': 0,
      '10': 'after'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `ProgramAnchor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programAnchorDescriptor = $convert.base64Decode(
    'Cg1Qcm9ncmFtQW5jaG9yEhYKBXN0YXJ0GAEgASgISABSBXN0YXJ0EhIKA2VuZBgCIAEoCEgAUg'
    'NlbmQSJAoCYXQYAyABKAsyEi5tb3RpZi5TdGF0ZW1lbnRJZEgAUgJhdBIqCgVhZnRlchgEIAEo'
    'CzISLm1vdGlmLlN0YXRlbWVudElkSABSBWFmdGVyQgcKBXZhbHVl');

@$core.Deprecated('Use statementChangeDescriptor instead')
const StatementChange$json = {
  '1': 'StatementChange',
  '2': [
    {
      '1': 'anchor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramAnchor',
      '10': 'anchor'
    },
    {
      '1': 'removed',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.Statement',
      '10': 'removed'
    },
    {
      '1': 'inserted',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.motif.Statement',
      '10': 'inserted'
    },
  ],
};

/// Descriptor for `StatementChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementChangeDescriptor = $convert.base64Decode(
    'Cg9TdGF0ZW1lbnRDaGFuZ2USLAoGYW5jaG9yGAEgASgLMhQubW90aWYuUHJvZ3JhbUFuY2hvcl'
    'IGYW5jaG9yEioKB3JlbW92ZWQYAiADKAsyEC5tb3RpZi5TdGF0ZW1lbnRSB3JlbW92ZWQSLAoI'
    'aW5zZXJ0ZWQYAyADKAsyEC5tb3RpZi5TdGF0ZW1lbnRSCGluc2VydGVk');

@$core.Deprecated('Use styleChangeDescriptor instead')
const StyleChange$json = {
  '1': 'StyleChange',
  '2': [
    {'1': 'ref', '3': 1, '4': 1, '5': 11, '6': '.motif.CellRef', '10': 'ref'},
    {
      '1': 'before',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.CellStyle.Partial',
      '9': 0,
      '10': 'before',
      '17': true
    },
    {
      '1': 'after',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.CellStyle.Partial',
      '9': 1,
      '10': 'after',
      '17': true
    },
  ],
  '8': [
    {'1': '_before'},
    {'1': '_after'},
  ],
};

/// Descriptor for `StyleChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List styleChangeDescriptor = $convert.base64Decode(
    'CgtTdHlsZUNoYW5nZRIgCgNyZWYYASABKAsyDi5tb3RpZi5DZWxsUmVmUgNyZWYSNQoGYmVmb3'
    'JlGAIgASgLMhgubW90aWYuQ2VsbFN0eWxlLlBhcnRpYWxIAFIGYmVmb3JliAEBEjMKBWFmdGVy'
    'GAMgASgLMhgubW90aWYuQ2VsbFN0eWxlLlBhcnRpYWxIAVIFYWZ0ZXKIAQFCCQoHX2JlZm9yZU'
    'IICgZfYWZ0ZXI=');

@$core.Deprecated('Use zOrderChangeDescriptor instead')
const ZOrderChange$json = {
  '1': 'ZOrderChange',
  '2': [
    {'1': 'ref', '3': 1, '4': 1, '5': 11, '6': '.motif.CellRef', '10': 'ref'},
    {
      '1': 'before',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ZAnchor',
      '9': 0,
      '10': 'before',
      '17': true
    },
    {
      '1': 'after',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ZAnchor',
      '9': 1,
      '10': 'after',
      '17': true
    },
  ],
  '8': [
    {'1': '_before'},
    {'1': '_after'},
  ],
};

/// Descriptor for `ZOrderChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List zOrderChangeDescriptor = $convert.base64Decode(
    'CgxaT3JkZXJDaGFuZ2USIAoDcmVmGAEgASgLMg4ubW90aWYuQ2VsbFJlZlIDcmVmEisKBmJlZm'
    '9yZRgCIAEoCzIOLm1vdGlmLlpBbmNob3JIAFIGYmVmb3JliAEBEikKBWFmdGVyGAMgASgLMg4u'
    'bW90aWYuWkFuY2hvckgBUgVhZnRlcogBAUIJCgdfYmVmb3JlQggKBl9hZnRlcg==');

@$core.Deprecated('Use programChangeDescriptor instead')
const ProgramChange$json = {
  '1': 'ProgramChange',
  '2': [
    {
      '1': 'statement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.StatementChange',
      '9': 0,
      '10': 'statement'
    },
    {
      '1': 'style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.StyleChange',
      '9': 0,
      '10': 'style'
    },
    {
      '1': 'z_order',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.ZOrderChange',
      '9': 0,
      '10': 'zOrder'
    },
    {'1': 'empty', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'empty'},
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `ProgramChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programChangeDescriptor = $convert.base64Decode(
    'Cg1Qcm9ncmFtQ2hhbmdlEjYKCXN0YXRlbWVudBgBIAEoCzIWLm1vdGlmLlN0YXRlbWVudENoYW'
    '5nZUgAUglzdGF0ZW1lbnQSKgoFc3R5bGUYAiABKAsyEi5tb3RpZi5TdHlsZUNoYW5nZUgAUgVz'
    'dHlsZRIuCgd6X29yZGVyGAMgASgLMhMubW90aWYuWk9yZGVyQ2hhbmdlSABSBnpPcmRlchIWCg'
    'VlbXB0eRgEIAEoCEgAUgVlbXB0eUIHCgV2YWx1ZQ==');

@$core.Deprecated('Use mat4Descriptor instead')
const Mat4$json = {
  '1': 'Mat4',
  '2': [
    {'1': 'm00', '3': 1, '4': 1, '5': 1, '10': 'm00'},
    {'1': 'm01', '3': 2, '4': 1, '5': 1, '10': 'm01'},
    {'1': 'm02', '3': 3, '4': 1, '5': 1, '10': 'm02'},
    {'1': 'm03', '3': 4, '4': 1, '5': 1, '10': 'm03'},
    {'1': 'm10', '3': 5, '4': 1, '5': 1, '10': 'm10'},
    {'1': 'm11', '3': 6, '4': 1, '5': 1, '10': 'm11'},
    {'1': 'm12', '3': 7, '4': 1, '5': 1, '10': 'm12'},
    {'1': 'm13', '3': 8, '4': 1, '5': 1, '10': 'm13'},
    {'1': 'm20', '3': 9, '4': 1, '5': 1, '10': 'm20'},
    {'1': 'm21', '3': 10, '4': 1, '5': 1, '10': 'm21'},
    {'1': 'm22', '3': 11, '4': 1, '5': 1, '10': 'm22'},
    {'1': 'm23', '3': 12, '4': 1, '5': 1, '10': 'm23'},
    {'1': 'm30', '3': 13, '4': 1, '5': 1, '10': 'm30'},
    {'1': 'm31', '3': 14, '4': 1, '5': 1, '10': 'm31'},
    {'1': 'm32', '3': 15, '4': 1, '5': 1, '10': 'm32'},
    {'1': 'm33', '3': 16, '4': 1, '5': 1, '10': 'm33'},
  ],
};

/// Descriptor for `Mat4`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mat4Descriptor = $convert.base64Decode(
    'CgRNYXQ0EhAKA20wMBgBIAEoAVIDbTAwEhAKA20wMRgCIAEoAVIDbTAxEhAKA20wMhgDIAEoAV'
    'IDbTAyEhAKA20wMxgEIAEoAVIDbTAzEhAKA20xMBgFIAEoAVIDbTEwEhAKA20xMRgGIAEoAVID'
    'bTExEhAKA20xMhgHIAEoAVIDbTEyEhAKA20xMxgIIAEoAVIDbTEzEhAKA20yMBgJIAEoAVIDbT'
    'IwEhAKA20yMRgKIAEoAVIDbTIxEhAKA20yMhgLIAEoAVIDbTIyEhAKA20yMxgMIAEoAVIDbTIz'
    'EhAKA20zMBgNIAEoAVIDbTMwEhAKA20zMRgOIAEoAVIDbTMxEhAKA20zMhgPIAEoAVIDbTMyEh'
    'AKA20zMxgQIAEoAVIDbTMz');

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

@$core.Deprecated('Use size2Descriptor instead')
const Size2$json = {
  '1': 'Size2',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 1, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 1, '10': 'height'},
  ],
};

/// Descriptor for `Size2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List size2Descriptor = $convert.base64Decode(
    'CgVTaXplMhIUCgV3aWR0aBgBIAEoAVIFd2lkdGgSFgoGaGVpZ2h0GAIgASgBUgZoZWlnaHQ=');

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

@$core.Deprecated('Use colorDataDescriptor instead')
const ColorData$json = {
  '1': 'ColorData',
  '2': [
    {
      '1': 'hsv',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData.Hsv',
      '9': 0,
      '10': 'hsv'
    },
    {'1': 'alpha', '3': 5, '4': 1, '5': 1, '10': 'alpha'},
  ],
  '3': [ColorData_Hsv$json],
  '8': [
    {'1': 'value'},
  ],
};

@$core.Deprecated('Use colorDataDescriptor instead')
const ColorData_Hsv$json = {
  '1': 'Hsv',
  '2': [
    {'1': 'h', '3': 1, '4': 1, '5': 1, '10': 'h'},
    {'1': 's', '3': 2, '4': 1, '5': 1, '10': 's'},
    {'1': 'v', '3': 3, '4': 1, '5': 1, '10': 'v'},
  ],
};

/// Descriptor for `ColorData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List colorDataDescriptor = $convert.base64Decode(
    'CglDb2xvckRhdGESKAoDaHN2GAEgASgLMhQubW90aWYuQ29sb3JEYXRhLkhzdkgAUgNoc3YSFA'
    'oFYWxwaGEYBSABKAFSBWFscGhhGi8KA0hzdhIMCgFoGAEgASgBUgFoEgwKAXMYAiABKAFSAXMS'
    'DAoBdhgDIAEoAVIBdkIHCgV2YWx1ZQ==');
