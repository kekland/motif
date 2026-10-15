// This is a generated file - do not edit.
//
// Generated from core/program/program.proto.

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

@$core.Deprecated('Use zPlacementDescriptor instead')
const ZPlacement$json = {
  '1': 'ZPlacement',
  '2': [
    {'1': 'Z_PLACEMENT_TOP', '2': 0},
    {'1': 'Z_PLACEMENT_BOTTOM', '2': 1},
    {'1': 'Z_PLACEMENT_ABOVE', '2': 2},
    {'1': 'Z_PLACEMENT_BELOW', '2': 3},
  ],
};

/// Descriptor for `ZPlacement`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List zPlacementDescriptor = $convert.base64Decode(
    'CgpaUGxhY2VtZW50EhMKD1pfUExBQ0VNRU5UX1RPUBAAEhYKElpfUExBQ0VNRU5UX0JPVFRPTR'
    'ABEhUKEVpfUExBQ0VNRU5UX0FCT1ZFEAISFQoRWl9QTEFDRU1FTlRfQkVMT1cQAw==');

@$core.Deprecated('Use textFontSlantDescriptor instead')
const TextFontSlant$json = {
  '1': 'TextFontSlant',
  '2': [
    {'1': 'TEXT_FONT_SLANT_UPRIGHT', '2': 0},
    {'1': 'TEXT_FONT_SLANT_ITALIC', '2': 1},
    {'1': 'TEXT_FONT_SLANT_OBLIQUE', '2': 2},
  ],
};

/// Descriptor for `TextFontSlant`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List textFontSlantDescriptor = $convert.base64Decode(
    'Cg1UZXh0Rm9udFNsYW50EhsKF1RFWFRfRk9OVF9TTEFOVF9VUFJJR0hUEAASGgoWVEVYVF9GT0'
    '5UX1NMQU5UX0lUQUxJQxABEhsKF1RFWFRfRk9OVF9TTEFOVF9PQkxJUVVFEAI=');

@$core.Deprecated('Use textFontWeightDescriptor instead')
const TextFontWeight$json = {
  '1': 'TextFontWeight',
  '2': [
    {'1': 'TEXT_FONT_WEIGHT_THIN', '2': 0},
    {'1': 'TEXT_FONT_WEIGHT_EXTRA_LIGHT', '2': 1},
    {'1': 'TEXT_FONT_WEIGHT_LIGHT', '2': 2},
    {'1': 'TEXT_FONT_WEIGHT_REGULAR', '2': 3},
    {'1': 'TEXT_FONT_WEIGHT_MEDIUM', '2': 4},
    {'1': 'TEXT_FONT_WEIGHT_SEMI_BOLD', '2': 5},
    {'1': 'TEXT_FONT_WEIGHT_BOLD', '2': 6},
    {'1': 'TEXT_FONT_WEIGHT_EXTRA_BOLD', '2': 7},
    {'1': 'TEXT_FONT_WEIGHT_BLACK', '2': 8},
  ],
};

/// Descriptor for `TextFontWeight`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List textFontWeightDescriptor = $convert.base64Decode(
    'Cg5UZXh0Rm9udFdlaWdodBIZChVURVhUX0ZPTlRfV0VJR0hUX1RISU4QABIgChxURVhUX0ZPTl'
    'RfV0VJR0hUX0VYVFJBX0xJR0hUEAESGgoWVEVYVF9GT05UX1dFSUdIVF9MSUdIVBACEhwKGFRF'
    'WFRfRk9OVF9XRUlHSFRfUkVHVUxBUhADEhsKF1RFWFRfRk9OVF9XRUlHSFRfTUVESVVNEAQSHg'
    'oaVEVYVF9GT05UX1dFSUdIVF9TRU1JX0JPTEQQBRIZChVURVhUX0ZPTlRfV0VJR0hUX0JPTEQQ'
    'BhIfChtURVhUX0ZPTlRfV0VJR0hUX0VYVFJBX0JPTEQQBxIaChZURVhUX0ZPTlRfV0VJR0hUX0'
    'JMQUNLEAg=');

@$core.Deprecated('Use textFontWidthDescriptor instead')
const TextFontWidth$json = {
  '1': 'TextFontWidth',
  '2': [
    {'1': 'TEXT_FONT_WIDTH_ULTRA_CONDENSED', '2': 0},
    {'1': 'TEXT_FONT_WIDTH_EXTRA_CONDENSED', '2': 1},
    {'1': 'TEXT_FONT_WIDTH_CONDENSED', '2': 2},
    {'1': 'TEXT_FONT_WIDTH_SEMI_CONDENSED', '2': 3},
    {'1': 'TEXT_FONT_WIDTH_NORMAL', '2': 4},
    {'1': 'TEXT_FONT_WIDTH_SEMI_EXPANDED', '2': 5},
    {'1': 'TEXT_FONT_WIDTH_EXPANDED', '2': 6},
    {'1': 'TEXT_FONT_WIDTH_EXTRA_EXPANDED', '2': 7},
    {'1': 'TEXT_FONT_WIDTH_ULTRA_EXPANDED', '2': 8},
  ],
};

/// Descriptor for `TextFontWidth`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List textFontWidthDescriptor = $convert.base64Decode(
    'Cg1UZXh0Rm9udFdpZHRoEiMKH1RFWFRfRk9OVF9XSURUSF9VTFRSQV9DT05ERU5TRUQQABIjCh'
    '9URVhUX0ZPTlRfV0lEVEhfRVhUUkFfQ09OREVOU0VEEAESHQoZVEVYVF9GT05UX1dJRFRIX0NP'
    'TkRFTlNFRBACEiIKHlRFWFRfRk9OVF9XSURUSF9TRU1JX0NPTkRFTlNFRBADEhoKFlRFWFRfRk'
    '9OVF9XSURUSF9OT1JNQUwQBBIhCh1URVhUX0ZPTlRfV0lEVEhfU0VNSV9FWFBBTkRFRBAFEhwK'
    'GFRFWFRfRk9OVF9XSURUSF9FWFBBTkRFRBAGEiIKHlRFWFRfRk9OVF9XSURUSF9FWFRSQV9FWF'
    'BBTkRFRBAHEiIKHlRFWFRfRk9OVF9XSURUSF9VTFRSQV9FWFBBTkRFRBAI');

@$core.Deprecated('Use textDecorationKindDescriptor instead')
const TextDecorationKind$json = {
  '1': 'TextDecorationKind',
  '2': [
    {'1': 'TEXT_DECORATION_KIND_UNDERLINE', '2': 0},
    {'1': 'TEXT_DECORATION_KIND_OVERLINE', '2': 1},
    {'1': 'TEXT_DECORATION_KIND_STRIKETHROUGH', '2': 2},
  ],
};

/// Descriptor for `TextDecorationKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List textDecorationKindDescriptor = $convert.base64Decode(
    'ChJUZXh0RGVjb3JhdGlvbktpbmQSIgoeVEVYVF9ERUNPUkFUSU9OX0tJTkRfVU5ERVJMSU5FEA'
    'ASIQodVEVYVF9ERUNPUkFUSU9OX0tJTkRfT1ZFUkxJTkUQARImCiJURVhUX0RFQ09SQVRJT05f'
    'S0lORF9TVFJJS0VUSFJPVUdIEAI=');

@$core.Deprecated('Use textAlignmentDescriptor instead')
const TextAlignment$json = {
  '1': 'TextAlignment',
  '2': [
    {'1': 'TEXT_ALIGNMENT_LEFT', '2': 0},
    {'1': 'TEXT_ALIGNMENT_RIGHT', '2': 1},
    {'1': 'TEXT_ALIGNMENT_CENTER', '2': 2},
    {'1': 'TEXT_ALIGNMENT_JUSTIFY', '2': 3},
  ],
};

/// Descriptor for `TextAlignment`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List textAlignmentDescriptor = $convert.base64Decode(
    'Cg1UZXh0QWxpZ25tZW50EhcKE1RFWFRfQUxJR05NRU5UX0xFRlQQABIYChRURVhUX0FMSUdOTU'
    'VOVF9SSUdIVBABEhkKFVRFWFRfQUxJR05NRU5UX0NFTlRFUhACEhoKFlRFWFRfQUxJR05NRU5U'
    'X0pVU1RJRlkQAw==');

@$core.Deprecated('Use textVerticalAlignmentDescriptor instead')
const TextVerticalAlignment$json = {
  '1': 'TextVerticalAlignment',
  '2': [
    {'1': 'TEXT_VERTICAL_ALIGNMENT_TOP', '2': 0},
    {'1': 'TEXT_VERTICAL_ALIGNMENT_MIDDLE', '2': 1},
    {'1': 'TEXT_VERTICAL_ALIGNMENT_BOTTOM', '2': 2},
  ],
};

/// Descriptor for `TextVerticalAlignment`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List textVerticalAlignmentDescriptor = $convert.base64Decode(
    'ChVUZXh0VmVydGljYWxBbGlnbm1lbnQSHwobVEVYVF9WRVJUSUNBTF9BTElHTk1FTlRfVE9QEA'
    'ASIgoeVEVYVF9WRVJUSUNBTF9BTElHTk1FTlRfTUlERExFEAESIgoeVEVYVF9WRVJUSUNBTF9B'
    'TElHTk1FTlRfQk9UVE9NEAI=');

@$core.Deprecated('Use mathOperatorTypeDescriptor instead')
const MathOperatorType$json = {
  '1': 'MathOperatorType',
  '2': [
    {'1': 'MATH_OPERATOR_TYPE_ADD', '2': 0},
    {'1': 'MATH_OPERATOR_TYPE_SUBTRACT', '2': 1},
    {'1': 'MATH_OPERATOR_TYPE_MULTIPLY', '2': 2},
    {'1': 'MATH_OPERATOR_TYPE_DIVIDE', '2': 3},
  ],
};

/// Descriptor for `MathOperatorType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mathOperatorTypeDescriptor = $convert.base64Decode(
    'ChBNYXRoT3BlcmF0b3JUeXBlEhoKFk1BVEhfT1BFUkFUT1JfVFlQRV9BREQQABIfChtNQVRIX0'
    '9QRVJBVE9SX1RZUEVfU1VCVFJBQ1QQARIfChtNQVRIX09QRVJBVE9SX1RZUEVfTVVMVElQTFkQ'
    'AhIdChlNQVRIX09QRVJBVE9SX1RZUEVfRElWSURFEAM=');

@$core.Deprecated('Use vectorMathOperatorTypeDescriptor instead')
const VectorMathOperatorType$json = {
  '1': 'VectorMathOperatorType',
  '2': [
    {'1': 'VECTOR_MATH_OPERATOR_TYPE_ADD', '2': 0},
    {'1': 'VECTOR_MATH_OPERATOR_TYPE_SUBTRACT', '2': 1},
  ],
};

/// Descriptor for `VectorMathOperatorType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List vectorMathOperatorTypeDescriptor =
    $convert.base64Decode(
        'ChZWZWN0b3JNYXRoT3BlcmF0b3JUeXBlEiEKHVZFQ1RPUl9NQVRIX09QRVJBVE9SX1RZUEVfQU'
        'REEAASJgoiVkVDVE9SX01BVEhfT1BFUkFUT1JfVFlQRV9TVUJUUkFDVBAB');

@$core.Deprecated('Use trigMathOperatorTypeDescriptor instead')
const TrigMathOperatorType$json = {
  '1': 'TrigMathOperatorType',
  '2': [
    {'1': 'TRIG_MATH_OPERATOR_TYPE_SIN', '2': 0},
    {'1': 'TRIG_MATH_OPERATOR_TYPE_COS', '2': 1},
    {'1': 'TRIG_MATH_OPERATOR_TYPE_TAN', '2': 2},
    {'1': 'TRIG_MATH_OPERATOR_TYPE_ARCSIN', '2': 3},
    {'1': 'TRIG_MATH_OPERATOR_TYPE_ARCCOS', '2': 4},
    {'1': 'TRIG_MATH_OPERATOR_TYPE_ARCTAN', '2': 5},
  ],
};

/// Descriptor for `TrigMathOperatorType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trigMathOperatorTypeDescriptor = $convert.base64Decode(
    'ChRUcmlnTWF0aE9wZXJhdG9yVHlwZRIfChtUUklHX01BVEhfT1BFUkFUT1JfVFlQRV9TSU4QAB'
    'IfChtUUklHX01BVEhfT1BFUkFUT1JfVFlQRV9DT1MQARIfChtUUklHX01BVEhfT1BFUkFUT1Jf'
    'VFlQRV9UQU4QAhIiCh5UUklHX01BVEhfT1BFUkFUT1JfVFlQRV9BUkNTSU4QAxIiCh5UUklHX0'
    '1BVEhfT1BFUkFUT1JfVFlQRV9BUkNDT1MQBBIiCh5UUklHX01BVEhfT1BFUkFUT1JfVFlQRV9B'
    'UkNUQU4QBQ==');

@$core.Deprecated('Use mathConstantTypeDescriptor instead')
const MathConstantType$json = {
  '1': 'MathConstantType',
  '2': [
    {'1': 'MATH_CONSTANT_TYPE_PI', '2': 0},
    {'1': 'MATH_CONSTANT_TYPE_E', '2': 1},
  ],
};

/// Descriptor for `MathConstantType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mathConstantTypeDescriptor = $convert.base64Decode(
    'ChBNYXRoQ29uc3RhbnRUeXBlEhkKFU1BVEhfQ09OU1RBTlRfVFlQRV9QSRAAEhgKFE1BVEhfQ0'
    '9OU1RBTlRfVFlQRV9FEAE=');

@$core.Deprecated('Use mathRoundTypeDescriptor instead')
const MathRoundType$json = {
  '1': 'MathRoundType',
  '2': [
    {'1': 'MATH_ROUND_TYPE_FLOOR', '2': 0},
    {'1': 'MATH_ROUND_TYPE_CEIL', '2': 1},
    {'1': 'MATH_ROUND_TYPE_ROUND', '2': 2},
  ],
};

/// Descriptor for `MathRoundType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mathRoundTypeDescriptor = $convert.base64Decode(
    'Cg1NYXRoUm91bmRUeXBlEhkKFU1BVEhfUk9VTkRfVFlQRV9GTE9PUhAAEhgKFE1BVEhfUk9VTk'
    'RfVFlQRV9DRUlMEAESGQoVTUFUSF9ST1VORF9UWVBFX1JPVU5EEAI=');

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
      '1': 'asset_manifest',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.AssetManifest',
      '10': 'assetManifest'
    },
    {
      '1': 'settings',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramSettings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `Program`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programDescriptor = $convert.base64Decode(
    'CgdQcm9ncmFtEjAKCnN0YXRlbWVudHMYASADKAsyEC5tb3RpZi5TdGF0ZW1lbnRSCnN0YXRlbW'
    'VudHMSJwoFc3R5bGUYAiABKAsyES5tb3RpZi5TdHlsZVRhYmxlUgVzdHlsZRI7Cg5hc3NldF9t'
    'YW5pZmVzdBgDIAEoCzIULm1vdGlmLkFzc2V0TWFuaWZlc3RSDWFzc2V0TWFuaWZlc3QSMgoIc2'
    'V0dGluZ3MYBCABKAsyFi5tb3RpZi5Qcm9ncmFtU2V0dGluZ3NSCHNldHRpbmdz');

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
  ],
};

/// Descriptor for `ProgramSlice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programSliceDescriptor = $convert.base64Decode(
    'CgxQcm9ncmFtU2xpY2USMAoKc3RhdGVtZW50cxgBIAMoCzIQLm1vdGlmLlN0YXRlbWVudFIKc3'
    'RhdGVtZW50cxInCgVzdHlsZRgCIAEoCzIRLm1vdGlmLlN0eWxlVGFibGVSBXN0eWxl');

@$core.Deprecated('Use statementDescriptor instead')
const Statement$json = {
  '1': 'Statement',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.motif.StatementId', '10': 'id'},
    {
      '1': 'modifiers',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ModifierStack',
      '10': 'modifiers'
    },
    {'1': 'name', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'name', '17': true},
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
    {
      '1': 'reorder',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.motif.ReorderStatement',
      '9': 0,
      '10': 'reorder'
    },
    {
      '1': 'prefab_origin',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.motif.PrefabOriginStatement',
      '9': 0,
      '10': 'prefabOrigin'
    },
    {
      '1': 'prefab_instance',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.motif.PrefabInstanceStatement',
      '9': 0,
      '10': 'prefabInstance'
    },
  ],
  '8': [
    {'1': 'value'},
    {'1': '_name'},
  ],
};

/// Descriptor for `Statement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementDescriptor = $convert.base64Decode(
    'CglTdGF0ZW1lbnQSIgoCaWQYASABKAsyEi5tb3RpZi5TdGF0ZW1lbnRJZFICaWQSMgoJbW9kaW'
    'ZpZXJzGAIgASgLMhQubW90aWYuTW9kaWZpZXJTdGFja1IJbW9kaWZpZXJzEhcKBG5hbWUYAyAB'
    'KAlIAVIEbmFtZYgBARIwCgZ2ZXJ0ZXgYCiABKAsyFi5tb3RpZi5WZXJ0ZXhTdGF0ZW1lbnRIAF'
    'IGdmVydGV4EioKBGVkZ2UYCyABKAsyFC5tb3RpZi5FZGdlU3RhdGVtZW50SABSBGVkZ2USKgoE'
    'ZmFjZRgMIAEoCzIULm1vdGlmLkZhY2VTdGF0ZW1lbnRIAFIEZmFjZRI0CghjdXRfZWRnZRgNIA'
    'EoCzIXLm1vdGlmLkN1dEVkZ2VTdGF0ZW1lbnRIAFIHY3V0RWRnZRJECg5tdWx0aV9jdXRfZWRn'
    'ZRgOIAEoCzIcLm1vdGlmLk11bHRpQ3V0RWRnZVN0YXRlbWVudEgAUgxtdWx0aUN1dEVkZ2USPQ'
    'oLZmlsbGV0X2ZhY2UYDyABKAsyGi5tb3RpZi5GaWxsZXRGYWNlU3RhdGVtZW50SABSCmZpbGxl'
    'dEZhY2USQwoNZ2x1ZV92ZXJ0aWNlcxgQIAEoCzIcLm1vdGlmLkdsdWVWZXJ0aWNlc1N0YXRlbW'
    'VudEgAUgxnbHVlVmVydGljZXMSOQoJcmVjdGFuZ2xlGBEgASgLMhkubW90aWYuUmVjdGFuZ2xl'
    'U3RhdGVtZW50SABSCXJlY3RhbmdsZRIzCgdwb2x5Z29uGBIgASgLMhcubW90aWYuUG9seWdvbl'
    'N0YXRlbWVudEgAUgdwb2x5Z29uEjMKB2VsbGlwc2UYEyABKAsyFy5tb3RpZi5FbGxpcHNlU3Rh'
    'dGVtZW50SABSB2VsbGlwc2USOQoJY29udGFpbmVyGBQgASgLMhkubW90aWYuQ29udGFpbmVyU3'
    'RhdGVtZW50SABSCWNvbnRhaW5lchItCgVncm91cBgVIAEoCzIVLm1vdGlmLkdyb3VwU3RhdGVt'
    'ZW50SABSBWdyb3VwEjkKCWdlbmVyYXRvchgWIAEoCzIZLm1vdGlmLkdlbmVyYXRvclN0YXRlbW'
    'VudEgAUglnZW5lcmF0b3ISKgoEdGV4dBgXIAEoCzIULm1vdGlmLlRleHRTdGF0ZW1lbnRIAFIE'
    'dGV4dBIzCgdyZW9yZGVyGBggASgLMhcubW90aWYuUmVvcmRlclN0YXRlbWVudEgAUgdyZW9yZG'
    'VyEkMKDXByZWZhYl9vcmlnaW4YGSABKAsyHC5tb3RpZi5QcmVmYWJPcmlnaW5TdGF0ZW1lbnRI'
    'AFIMcHJlZmFiT3JpZ2luEkkKD3ByZWZhYl9pbnN0YW5jZRgaIAEoCzIeLm1vdGlmLlByZWZhYk'
    'luc3RhbmNlU3RhdGVtZW50SABSDnByZWZhYkluc3RhbmNlQgcKBXZhbHVlQgcKBV9uYW1l');

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

@$core.Deprecated('Use programSettingsDescriptor instead')
const ProgramSettings$json = {
  '1': 'ProgramSettings',
  '2': [
    {
      '1': 'background_color',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData',
      '10': 'backgroundColor'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `ProgramSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programSettingsDescriptor = $convert.base64Decode(
    'Cg9Qcm9ncmFtU2V0dGluZ3MSOwoQYmFja2dyb3VuZF9jb2xvchgBIAEoCzIQLm1vdGlmLkNvbG'
    '9yRGF0YVIPYmFja2dyb3VuZENvbG9yEhQKBXRpdGxlGAIgASgJUgV0aXRsZQ==');

@$core.Deprecated('Use zAnchorDescriptor instead')
const ZAnchor$json = {
  '1': 'ZAnchor',
  '2': [
    {'1': 'top', '3': 1, '4': 1, '5': 5, '9': 0, '10': 'top'},
    {'1': 'bottom', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'bottom'},
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
    'CgdaQW5jaG9yEhIKA3RvcBgBIAEoBUgAUgN0b3ASGAoGYm90dG9tGAIgASgFSABSBmJvdHRvbR'
    'ImCgVhYm92ZRgDIAEoCzIOLm1vdGlmLkNlbGxSZWZIAFIFYWJvdmUSJgoFYmVsb3cYBCABKAsy'
    'Di5tb3RpZi5DZWxsUmVmSABSBWJlbG93QgcKBXZhbHVl');

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
      '1': 'decorations',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Decorations',
      '10': 'decorations'
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
      '1': 'decorations',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Decorations',
      '9': 1,
      '10': 'decorations',
      '17': true
    },
  ],
  '8': [
    {'1': '_radius'},
    {'1': '_decorations'},
  ],
};

/// Descriptor for `VertexStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vertexStyleDescriptor = $convert.base64Decode(
    'CgtWZXJ0ZXhTdHlsZRIWCgZyYWRpdXMYASABKAFSBnJhZGl1cxI0CgtkZWNvcmF0aW9ucxgCIA'
    'EoCzISLm1vdGlmLkRlY29yYXRpb25zUgtkZWNvcmF0aW9ucxp8CgdQYXJ0aWFsEhsKBnJhZGl1'
    'cxgBIAEoAUgAUgZyYWRpdXOIAQESOQoLZGVjb3JhdGlvbnMYAiABKAsyEi5tb3RpZi5EZWNvcm'
    'F0aW9uc0gBUgtkZWNvcmF0aW9uc4gBAUIJCgdfcmFkaXVzQg4KDF9kZWNvcmF0aW9ucw==');

@$core.Deprecated('Use edgeStyleDescriptor instead')
const EdgeStyle$json = {
  '1': 'EdgeStyle',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 1, '10': 'width'},
    {
      '1': 'decorations',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Decorations',
      '10': 'decorations'
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
      '1': 'decorations',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Decorations',
      '9': 1,
      '10': 'decorations',
      '17': true
    },
  ],
  '8': [
    {'1': '_width'},
    {'1': '_decorations'},
  ],
};

/// Descriptor for `EdgeStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeStyleDescriptor = $convert.base64Decode(
    'CglFZGdlU3R5bGUSFAoFd2lkdGgYASABKAFSBXdpZHRoEjQKC2RlY29yYXRpb25zGAIgASgLMh'
    'IubW90aWYuRGVjb3JhdGlvbnNSC2RlY29yYXRpb25zGnkKB1BhcnRpYWwSGQoFd2lkdGgYASAB'
    'KAFIAFIFd2lkdGiIAQESOQoLZGVjb3JhdGlvbnMYAiABKAsyEi5tb3RpZi5EZWNvcmF0aW9uc0'
    'gBUgtkZWNvcmF0aW9uc4gBAUIICgZfd2lkdGhCDgoMX2RlY29yYXRpb25z');

@$core.Deprecated('Use faceStyleDescriptor instead')
const FaceStyle$json = {
  '1': 'FaceStyle',
  '2': [
    {
      '1': 'decorations',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Decorations',
      '10': 'decorations'
    },
  ],
  '3': [FaceStyle_Partial$json],
};

@$core.Deprecated('Use faceStyleDescriptor instead')
const FaceStyle_Partial$json = {
  '1': 'Partial',
  '2': [
    {
      '1': 'decorations',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Decorations',
      '9': 0,
      '10': 'decorations',
      '17': true
    },
  ],
  '8': [
    {'1': '_decorations'},
  ],
};

/// Descriptor for `FaceStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List faceStyleDescriptor = $convert.base64Decode(
    'CglGYWNlU3R5bGUSNAoLZGVjb3JhdGlvbnMYASABKAsyEi5tb3RpZi5EZWNvcmF0aW9uc1ILZG'
    'Vjb3JhdGlvbnMaVAoHUGFydGlhbBI5CgtkZWNvcmF0aW9ucxgBIAEoCzISLm1vdGlmLkRlY29y'
    'YXRpb25zSABSC2RlY29yYXRpb25ziAEBQg4KDF9kZWNvcmF0aW9ucw==');

@$core.Deprecated('Use decorationDescriptor instead')
const Decoration$json = {
  '1': 'Decoration',
  '2': [
    {
      '1': 'color',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Decoration.Color',
      '9': 0,
      '10': 'color'
    },
    {
      '1': 'image',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Decoration.Image',
      '9': 0,
      '10': 'image'
    },
  ],
  '3': [Decoration_Color$json, Decoration_Image$json],
  '8': [
    {'1': 'kind'},
  ],
};

@$core.Deprecated('Use decorationDescriptor instead')
const Decoration_Color$json = {
  '1': 'Color',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ColorData',
      '10': 'value'
    },
  ],
};

@$core.Deprecated('Use decorationDescriptor instead')
const Decoration_Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'value', '17': true},
  ],
  '8': [
    {'1': '_value'},
  ],
};

/// Descriptor for `Decoration`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decorationDescriptor = $convert.base64Decode(
    'CgpEZWNvcmF0aW9uEi8KBWNvbG9yGAEgASgLMhcubW90aWYuRGVjb3JhdGlvbi5Db2xvckgAUg'
    'Vjb2xvchIvCgVpbWFnZRgCIAEoCzIXLm1vdGlmLkRlY29yYXRpb24uSW1hZ2VIAFIFaW1hZ2Ua'
    'LwoFQ29sb3ISJgoFdmFsdWUYASABKAsyEC5tb3RpZi5Db2xvckRhdGFSBXZhbHVlGiwKBUltYW'
    'dlEhkKBXZhbHVlGAEgASgJSABSBXZhbHVliAEBQggKBl92YWx1ZUIGCgRraW5k');

@$core.Deprecated('Use decorationsDescriptor instead')
const Decorations$json = {
  '1': 'Decorations',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.Decoration',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `Decorations`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decorationsDescriptor = $convert.base64Decode(
    'CgtEZWNvcmF0aW9ucxIrCgdlbnRyaWVzGAEgAygLMhEubW90aWYuRGVjb3JhdGlvblIHZW50cm'
    'llcw==');

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
      '4': 1,
      '5': 11,
      '6': '.motif.CornerRadii',
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
  '8': [
    {'1': '_radius'},
  ],
};

/// Descriptor for `FilletFaceStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List filletFaceStatementDescriptor = $convert.base64Decode(
    'ChNGaWxsZXRGYWNlU3RhdGVtZW50EikKBGZhY2UYASABKAsyFS5tb3RpZi5TaW5nbGVTZWxlY3'
    'RvclIEZmFjZRIsCgdjb3JuZXJzGAIgASgLMhIubW90aWYuQ29ybmVyUmFkaWlSB2Nvcm5lcnMS'
    'MAoGcmFkaXVzGAMgASgLMhMubW90aWYuQ29ybmVyUmFkaXVzSABSBnJhZGl1c4gBAUIJCgdfcm'
    'FkaXVz');

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
    {
      '1': 'text_format',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.TextFormat',
      '10': 'textFormat'
    },
    {
      '1': 'paragraph_format',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.ParagraphFormat',
      '10': 'paragraphFormat'
    },
    {
      '1': 'vertex_style',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '10': 'vertexStyle'
    },
    {
      '1': 'edge_style',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '10': 'edgeStyle'
    },
    {
      '1': 'face_style',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '10': 'faceStyle'
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
    'bnNmb3JtEisKBnBhcmVudBgEIAEoCzIOLm1vdGlmLkNlbGxSZWZIAFIGcGFyZW50iAEBEjIKC3'
    'RleHRfZm9ybWF0GAYgASgLMhEubW90aWYuVGV4dEZvcm1hdFIKdGV4dEZvcm1hdBJBChBwYXJh'
    'Z3JhcGhfZm9ybWF0GAUgASgLMhYubW90aWYuUGFyYWdyYXBoRm9ybWF0Ug9wYXJhZ3JhcGhGb3'
    'JtYXQSNQoMdmVydGV4X3N0eWxlGAcgASgLMhIubW90aWYuVmVydGV4U3R5bGVSC3ZlcnRleFN0'
    'eWxlEi8KCmVkZ2Vfc3R5bGUYCCABKAsyEC5tb3RpZi5FZGdlU3R5bGVSCWVkZ2VTdHlsZRIvCg'
    'pmYWNlX3N0eWxlGAkgASgLMhAubW90aWYuRmFjZVN0eWxlUglmYWNlU3R5bGVCCQoHX3BhcmVu'
    'dA==');

@$core.Deprecated('Use reorderStatementDescriptor instead')
const ReorderStatement$json = {
  '1': 'ReorderStatement',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.CellSelector',
      '10': 'target'
    },
    {
      '1': 'placement',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.motif.ZPlacement',
      '10': 'placement'
    },
    {'1': 'rank', '3': 3, '4': 1, '5': 5, '9': 0, '10': 'rank', '17': true},
    {
      '1': 'sibling',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.CellSelector',
      '9': 1,
      '10': 'sibling',
      '17': true
    },
  ],
  '8': [
    {'1': '_rank'},
    {'1': '_sibling'},
  ],
};

/// Descriptor for `ReorderStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reorderStatementDescriptor = $convert.base64Decode(
    'ChBSZW9yZGVyU3RhdGVtZW50EisKBnRhcmdldBgBIAEoCzITLm1vdGlmLkNlbGxTZWxlY3Rvcl'
    'IGdGFyZ2V0Ei8KCXBsYWNlbWVudBgCIAEoDjIRLm1vdGlmLlpQbGFjZW1lbnRSCXBsYWNlbWVu'
    'dBIXCgRyYW5rGAMgASgFSABSBHJhbmuIAQESMgoHc2libGluZxgEIAEoCzITLm1vdGlmLkNlbG'
    'xTZWxlY3RvckgBUgdzaWJsaW5niAEBQgcKBV9yYW5rQgoKCF9zaWJsaW5n');

@$core.Deprecated('Use prefabOriginStatementDescriptor instead')
const PrefabOriginStatement$json = {
  '1': 'PrefabOriginStatement',
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

/// Descriptor for `PrefabOriginStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prefabOriginStatementDescriptor = $convert.base64Decode(
    'ChVQcmVmYWJPcmlnaW5TdGF0ZW1lbnQSJQoGbGF5b3V0GAEgASgLMg0ubW90aWYuTGF5b3V0Ug'
    'ZsYXlvdXQSJQoEc2l6ZRgCIAEoCzIRLm1vdGlmLkxheW91dFNpemVSBHNpemUSKQoJdHJhbnNm'
    'b3JtGAMgASgLMgsubW90aWYuTWF0NFIJdHJhbnNmb3JtEigKBXNoYXBlGAQgASgLMhIubW90aW'
    'YuT2JqZWN0U2hhcGVSBXNoYXBlEjUKDHZlcnRleF9zdHlsZRgFIAEoCzISLm1vdGlmLlZlcnRl'
    'eFN0eWxlUgt2ZXJ0ZXhTdHlsZRIvCgplZGdlX3N0eWxlGAYgASgLMhAubW90aWYuRWRnZVN0eW'
    'xlUgllZGdlU3R5bGUSLwoKZmFjZV9zdHlsZRgHIAEoCzIQLm1vdGlmLkZhY2VTdHlsZVIJZmFj'
    'ZVN0eWxlEisKBnBhcmVudBgIIAEoCzIOLm1vdGlmLkNlbGxSZWZIAFIGcGFyZW50iAEBQgkKB1'
    '9wYXJlbnQ=');

@$core.Deprecated('Use prefabInstanceStatementDescriptor instead')
const PrefabInstanceStatement$json = {
  '1': 'PrefabInstanceStatement',
  '2': [
    {
      '1': 'prefab_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.StatementId',
      '10': 'prefabId'
    },
    {
      '1': 'layout',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Layout',
      '9': 0,
      '10': 'layout',
      '17': true
    },
    {
      '1': 'size',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutSize',
      '9': 1,
      '10': 'size',
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
    {
      '1': 'shape',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape',
      '9': 2,
      '10': 'shape',
      '17': true
    },
    {
      '1': 'vertex_style',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '9': 3,
      '10': 'vertexStyle',
      '17': true
    },
    {
      '1': 'edge_style',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '9': 4,
      '10': 'edgeStyle',
      '17': true
    },
    {
      '1': 'face_style',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '9': 5,
      '10': 'faceStyle',
      '17': true
    },
    {
      '1': 'parent',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.motif.CellRef',
      '9': 6,
      '10': 'parent',
      '17': true
    },
    {
      '1': 'overrides',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.motif.GeneratorOverrides',
      '10': 'overrides'
    },
  ],
  '3': [PrefabInstanceStatement_Override$json],
  '8': [
    {'1': '_layout'},
    {'1': '_size'},
    {'1': '_shape'},
    {'1': '_vertex_style'},
    {'1': '_edge_style'},
    {'1': '_face_style'},
    {'1': '_parent'},
  ],
};

@$core.Deprecated('Use prefabInstanceStatementDescriptor instead')
const PrefabInstanceStatement_Override$json = {
  '1': 'Override',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.motif.StatementId', '10': 'id'},
    {
      '1': 'partial',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.StatementPartial',
      '10': 'partial'
    },
  ],
};

/// Descriptor for `PrefabInstanceStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prefabInstanceStatementDescriptor = $convert.base64Decode(
    'ChdQcmVmYWJJbnN0YW5jZVN0YXRlbWVudBIvCglwcmVmYWJfaWQYASABKAsyEi5tb3RpZi5TdG'
    'F0ZW1lbnRJZFIIcHJlZmFiSWQSKgoGbGF5b3V0GAIgASgLMg0ubW90aWYuTGF5b3V0SABSBmxh'
    'eW91dIgBARIqCgRzaXplGAMgASgLMhEubW90aWYuTGF5b3V0U2l6ZUgBUgRzaXpliAEBEikKCX'
    'RyYW5zZm9ybRgEIAEoCzILLm1vdGlmLk1hdDRSCXRyYW5zZm9ybRItCgVzaGFwZRgFIAEoCzIS'
    'Lm1vdGlmLk9iamVjdFNoYXBlSAJSBXNoYXBliAEBEjoKDHZlcnRleF9zdHlsZRgGIAEoCzISLm'
    '1vdGlmLlZlcnRleFN0eWxlSANSC3ZlcnRleFN0eWxliAEBEjQKCmVkZ2Vfc3R5bGUYByABKAsy'
    'EC5tb3RpZi5FZGdlU3R5bGVIBFIJZWRnZVN0eWxliAEBEjQKCmZhY2Vfc3R5bGUYCCABKAsyEC'
    '5tb3RpZi5GYWNlU3R5bGVIBVIJZmFjZVN0eWxliAEBEisKBnBhcmVudBgJIAEoCzIOLm1vdGlm'
    'LkNlbGxSZWZIBlIGcGFyZW50iAEBEjcKCW92ZXJyaWRlcxgKIAEoCzIZLm1vdGlmLkdlbmVyYX'
    'Rvck92ZXJyaWRlc1IJb3ZlcnJpZGVzGmEKCE92ZXJyaWRlEiIKAmlkGAEgASgLMhIubW90aWYu'
    'U3RhdGVtZW50SWRSAmlkEjEKB3BhcnRpYWwYAiABKAsyFy5tb3RpZi5TdGF0ZW1lbnRQYXJ0aW'
    'FsUgdwYXJ0aWFsQgkKB19sYXlvdXRCBwoFX3NpemVCCAoGX3NoYXBlQg8KDV92ZXJ0ZXhfc3R5'
    'bGVCDQoLX2VkZ2Vfc3R5bGVCDQoLX2ZhY2Vfc3R5bGVCCQoHX3BhcmVudA==');

@$core.Deprecated('Use statementPartialDescriptor instead')
const StatementPartial$json = {
  '1': 'StatementPartial',
  '2': [
    {
      '1': 'fields',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.StatementPartial.Value',
      '10': 'fields'
    },
  ],
  '3': [StatementPartial_Value$json],
};

@$core.Deprecated('Use statementPartialDescriptor instead')
const StatementPartial_Value$json = {
  '1': 'Value',
  '2': [
    {
      '1': 'modifiers',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ModifierStack',
      '9': 0,
      '10': 'modifiers'
    },
    {'1': 'name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'name'},
    {
      '1': 'transform',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.Mat4',
      '9': 0,
      '10': 'transform'
    },
    {
      '1': 'layout_size',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.LayoutSize',
      '9': 0,
      '10': 'layoutSize'
    },
    {
      '1': 'vertex_style',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.motif.VertexStyle',
      '9': 0,
      '10': 'vertexStyle'
    },
    {
      '1': 'edge_style',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.motif.EdgeStyle',
      '9': 0,
      '10': 'edgeStyle'
    },
    {
      '1': 'face_style',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.motif.FaceStyle',
      '9': 0,
      '10': 'faceStyle'
    },
    {
      '1': 'object_shape',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.motif.ObjectShape',
      '9': 0,
      '10': 'objectShape'
    },
    {
      '1': 'position',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'position'
    },
    {'1': 'text', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'text'},
    {
      '1': 'text_format',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.motif.TextFormat',
      '9': 0,
      '10': 'textFormat'
    },
    {
      '1': 'paragraph_format',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.motif.ParagraphFormat',
      '9': 0,
      '10': 'paragraphFormat'
    },
    {
      '1': 'corners',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.motif.CornerRadii',
      '9': 0,
      '10': 'corners'
    },
    {
      '1': 'radius',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.motif.CornerRadius',
      '9': 0,
      '10': 'radius'
    },
    {
      '1': 'glue_vertices_position',
      '3': 15,
      '4': 1,
      '5': 14,
      '6': '.motif.GlueVerticesStatement.Position',
      '9': 0,
      '10': 'glueVerticesPosition'
    },
    {
      '1': 'layout',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.motif.Layout',
      '9': 0,
      '10': 'layout'
    },
  ],
  '8': [
    {'1': 'kind'},
  ],
};

/// Descriptor for `StatementPartial`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementPartialDescriptor = $convert.base64Decode(
    'ChBTdGF0ZW1lbnRQYXJ0aWFsEjUKBmZpZWxkcxgBIAMoCzIdLm1vdGlmLlN0YXRlbWVudFBhcn'
    'RpYWwuVmFsdWVSBmZpZWxkcxq5BgoFVmFsdWUSNAoJbW9kaWZpZXJzGAEgASgLMhQubW90aWYu'
    'TW9kaWZpZXJTdGFja0gAUgltb2RpZmllcnMSFAoEbmFtZRgCIAEoCUgAUgRuYW1lEisKCXRyYW'
    '5zZm9ybRgDIAEoCzILLm1vdGlmLk1hdDRIAFIJdHJhbnNmb3JtEjQKC2xheW91dF9zaXplGAQg'
    'ASgLMhEubW90aWYuTGF5b3V0U2l6ZUgAUgpsYXlvdXRTaXplEjcKDHZlcnRleF9zdHlsZRgFIA'
    'EoCzISLm1vdGlmLlZlcnRleFN0eWxlSABSC3ZlcnRleFN0eWxlEjEKCmVkZ2Vfc3R5bGUYBiAB'
    'KAsyEC5tb3RpZi5FZGdlU3R5bGVIAFIJZWRnZVN0eWxlEjEKCmZhY2Vfc3R5bGUYByABKAsyEC'
    '5tb3RpZi5GYWNlU3R5bGVIAFIJZmFjZVN0eWxlEjcKDG9iamVjdF9zaGFwZRgIIAEoCzISLm1v'
    'dGlmLk9iamVjdFNoYXBlSABSC29iamVjdFNoYXBlEikKCHBvc2l0aW9uGAkgASgLMgsubW90aW'
    'YuVmVjMkgAUghwb3NpdGlvbhIUCgR0ZXh0GAogASgJSABSBHRleHQSNAoLdGV4dF9mb3JtYXQY'
    'CyABKAsyES5tb3RpZi5UZXh0Rm9ybWF0SABSCnRleHRGb3JtYXQSQwoQcGFyYWdyYXBoX2Zvcm'
    '1hdBgMIAEoCzIWLm1vdGlmLlBhcmFncmFwaEZvcm1hdEgAUg9wYXJhZ3JhcGhGb3JtYXQSLgoH'
    'Y29ybmVycxgNIAEoCzISLm1vdGlmLkNvcm5lclJhZGlpSABSB2Nvcm5lcnMSLQoGcmFkaXVzGA'
    '4gASgLMhMubW90aWYuQ29ybmVyUmFkaXVzSABSBnJhZGl1cxJdChZnbHVlX3ZlcnRpY2VzX3Bv'
    'c2l0aW9uGA8gASgOMiUubW90aWYuR2x1ZVZlcnRpY2VzU3RhdGVtZW50LlBvc2l0aW9uSABSFG'
    'dsdWVWZXJ0aWNlc1Bvc2l0aW9uEicKBmxheW91dBgQIAEoCzINLm1vdGlmLkxheW91dEgAUgZs'
    'YXlvdXRCBgoEa2luZA==');

@$core.Deprecated('Use generatorOverridesDescriptor instead')
const GeneratorOverrides$json = {
  '1': 'GeneratorOverrides',
  '2': [
    {
      '1': 'children',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.GeneratorOverrideNode.Entry',
      '10': 'children'
    },
  ],
};

/// Descriptor for `GeneratorOverrides`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatorOverridesDescriptor = $convert.base64Decode(
    'ChJHZW5lcmF0b3JPdmVycmlkZXMSPgoIY2hpbGRyZW4YASADKAsyIi5tb3RpZi5HZW5lcmF0b3'
    'JPdmVycmlkZU5vZGUuRW50cnlSCGNoaWxkcmVu');

@$core.Deprecated('Use generatorOverrideNodeDescriptor instead')
const GeneratorOverrideNode$json = {
  '1': 'GeneratorOverrideNode',
  '2': [
    {
      '1': 'partial',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.StatementPartial',
      '9': 0,
      '10': 'partial',
      '17': true
    },
    {
      '1': 'children',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.GeneratorOverrideNode.Entry',
      '10': 'children'
    },
  ],
  '3': [GeneratorOverrideNode_Entry$json],
  '8': [
    {'1': '_partial'},
  ],
};

@$core.Deprecated('Use generatorOverrideNodeDescriptor instead')
const GeneratorOverrideNode_Entry$json = {
  '1': 'Entry',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.motif.StatementId', '10': 'id'},
    {
      '1': 'node',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.GeneratorOverrideNode',
      '10': 'node'
    },
  ],
};

/// Descriptor for `GeneratorOverrideNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatorOverrideNodeDescriptor = $convert.base64Decode(
    'ChVHZW5lcmF0b3JPdmVycmlkZU5vZGUSNgoHcGFydGlhbBgBIAEoCzIXLm1vdGlmLlN0YXRlbW'
    'VudFBhcnRpYWxIAFIHcGFydGlhbIgBARI+CghjaGlsZHJlbhgCIAMoCzIiLm1vdGlmLkdlbmVy'
    'YXRvck92ZXJyaWRlTm9kZS5FbnRyeVIIY2hpbGRyZW4aXQoFRW50cnkSIgoCaWQYASABKAsyEi'
    '5tb3RpZi5TdGF0ZW1lbnRJZFICaWQSMAoEbm9kZRgCIAEoCzIcLm1vdGlmLkdlbmVyYXRvck92'
    'ZXJyaWRlTm9kZVIEbm9kZUIKCghfcGFydGlhbA==');

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
    {'1': 'LAYOUT_ALIGN_NONE', '2': 0},
    {'1': 'LAYOUT_ALIGN_START', '2': 1},
    {'1': 'LAYOUT_ALIGN_CENTER', '2': 2},
    {'1': 'LAYOUT_ALIGN_END', '2': 3},
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
    'JFQ1RJT05fQ09MVU1OEAEiZQoFQWxpZ24SFQoRTEFZT1VUX0FMSUdOX05PTkUQABIWChJMQVlP'
    'VVRfQUxJR05fU1RBUlQQARIXChNMQVlPVVRfQUxJR05fQ0VOVEVSEAISFAoQTEFZT1VUX0FMSU'
    'dOX0VORBADIngKB0p1c3RpZnkSGAoUTEFZT1VUX0pVU1RJRllfU1RBUlQQABIZChVMQVlPVVRf'
    'SlVTVElGWV9DRU5URVIQARIWChJMQVlPVVRfSlVTVElGWV9FTkQQAhIgChxMQVlPVVRfSlVTVE'
    'lGWV9TUEFDRV9CRVRXRUVOEANCBwoFdmFsdWU=');

@$core.Deprecated('Use textFormatDescriptor instead')
const TextFormat$json = {
  '1': 'TextFormat',
  '2': [
    {'1': 'font_size', '3': 1, '4': 1, '5': 1, '10': 'fontSize'},
    {'1': 'line_height', '3': 2, '4': 1, '5': 1, '10': 'lineHeight'},
    {'1': 'letter_spacing', '3': 3, '4': 1, '5': 1, '10': 'letterSpacing'},
    {'1': 'font_family', '3': 4, '4': 1, '5': 9, '10': 'fontFamily'},
    {
      '1': 'font_slant',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.motif.TextFontSlant',
      '10': 'fontSlant'
    },
    {
      '1': 'font_weight',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.motif.TextFontWeight',
      '10': 'fontWeight'
    },
    {
      '1': 'font_width',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.motif.TextFontWidth',
      '10': 'fontWidth'
    },
    {
      '1': 'decorations',
      '3': 8,
      '4': 3,
      '5': 14,
      '6': '.motif.TextDecorationKind',
      '10': 'decorations'
    },
  ],
};

/// Descriptor for `TextFormat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textFormatDescriptor = $convert.base64Decode(
    'CgpUZXh0Rm9ybWF0EhsKCWZvbnRfc2l6ZRgBIAEoAVIIZm9udFNpemUSHwoLbGluZV9oZWlnaH'
    'QYAiABKAFSCmxpbmVIZWlnaHQSJQoObGV0dGVyX3NwYWNpbmcYAyABKAFSDWxldHRlclNwYWNp'
    'bmcSHwoLZm9udF9mYW1pbHkYBCABKAlSCmZvbnRGYW1pbHkSMwoKZm9udF9zbGFudBgFIAEoDj'
    'IULm1vdGlmLlRleHRGb250U2xhbnRSCWZvbnRTbGFudBI2Cgtmb250X3dlaWdodBgGIAEoDjIV'
    'Lm1vdGlmLlRleHRGb250V2VpZ2h0Ugpmb250V2VpZ2h0EjMKCmZvbnRfd2lkdGgYByABKA4yFC'
    '5tb3RpZi5UZXh0Rm9udFdpZHRoUglmb250V2lkdGgSOwoLZGVjb3JhdGlvbnMYCCADKA4yGS5t'
    'b3RpZi5UZXh0RGVjb3JhdGlvbktpbmRSC2RlY29yYXRpb25z');

@$core.Deprecated('Use paragraphFormatDescriptor instead')
const ParagraphFormat$json = {
  '1': 'ParagraphFormat',
  '2': [
    {
      '1': 'alignment',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.motif.TextAlignment',
      '10': 'alignment'
    },
    {
      '1': 'vertical_alignment',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.motif.TextVerticalAlignment',
      '10': 'verticalAlignment'
    },
    {
      '1': 'ellipsis',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'ellipsis',
      '17': true
    },
  ],
  '8': [
    {'1': '_ellipsis'},
  ],
};

/// Descriptor for `ParagraphFormat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paragraphFormatDescriptor = $convert.base64Decode(
    'Cg9QYXJhZ3JhcGhGb3JtYXQSMgoJYWxpZ25tZW50GAEgASgOMhQubW90aWYuVGV4dEFsaWdubW'
    'VudFIJYWxpZ25tZW50EksKEnZlcnRpY2FsX2FsaWdubWVudBgCIAEoDjIcLm1vdGlmLlRleHRW'
    'ZXJ0aWNhbEFsaWdubWVudFIRdmVydGljYWxBbGlnbm1lbnQSHwoIZWxsaXBzaXMYAyABKAlIAF'
    'IIZWxsaXBzaXOIAQFCCwoJX2VsbGlwc2lz');

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

@$core.Deprecated('Use generatorSliceDescriptor instead')
const GeneratorSlice$json = {
  '1': 'GeneratorSlice',
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
  ],
};

/// Descriptor for `GeneratorSlice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatorSliceDescriptor = $convert.base64Decode(
    'Cg5HZW5lcmF0b3JTbGljZRIhCgVub2RlcxgBIAMoCzILLm1vdGlmLk5vZGVSBW5vZGVzEjMKC2'
    'Nvbm5lY3Rpb25zGAIgAygLMhEubW90aWYuQ29ubmVjdGlvblILY29ubmVjdGlvbnMSPAoJcG9z'
    'aXRpb25zGAMgAygLMh4ubW90aWYuR2VuZXJhdG9yLlBvc2l0aW9uRW50cnlSCXBvc2l0aW9ucw'
    '==');

@$core.Deprecated('Use modifierStackDescriptor instead')
const ModifierStack$json = {
  '1': 'ModifierStack',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.Modifier',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ModifierStack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modifierStackDescriptor = $convert.base64Decode(
    'Cg1Nb2RpZmllclN0YWNrEikKB2VudHJpZXMYASADKAsyDy5tb3RpZi5Nb2RpZmllclIHZW50cm'
    'llcw==');

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

@$core.Deprecated('Use assetChangeDescriptor instead')
const AssetChange$json = {
  '1': 'AssetChange',
  '2': [
    {
      '1': 'removed',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.Asset',
      '10': 'removed'
    },
    {
      '1': 'inserted',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.motif.Asset',
      '10': 'inserted'
    },
  ],
};

/// Descriptor for `AssetChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetChangeDescriptor = $convert.base64Decode(
    'CgtBc3NldENoYW5nZRImCgdyZW1vdmVkGAEgAygLMgwubW90aWYuQXNzZXRSB3JlbW92ZWQSKA'
    'oIaW5zZXJ0ZWQYAiADKAsyDC5tb3RpZi5Bc3NldFIIaW5zZXJ0ZWQ=');

@$core.Deprecated('Use settingsChangeDescriptor instead')
const SettingsChange$json = {
  '1': 'SettingsChange',
  '2': [
    {
      '1': 'before',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramSettings',
      '10': 'before'
    },
    {
      '1': 'after',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.ProgramSettings',
      '10': 'after'
    },
  ],
};

/// Descriptor for `SettingsChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsChangeDescriptor = $convert.base64Decode(
    'Cg5TZXR0aW5nc0NoYW5nZRIuCgZiZWZvcmUYASABKAsyFi5tb3RpZi5Qcm9ncmFtU2V0dGluZ3'
    'NSBmJlZm9yZRIsCgVhZnRlchgCIAEoCzIWLm1vdGlmLlByb2dyYW1TZXR0aW5nc1IFYWZ0ZXI=');

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
      '1': 'asset',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.AssetChange',
      '9': 0,
      '10': 'asset'
    },
    {
      '1': 'settings',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.motif.SettingsChange',
      '9': 0,
      '10': 'settings'
    },
    {'1': 'empty', '3': 100, '4': 1, '5': 8, '9': 0, '10': 'empty'},
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `ProgramChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List programChangeDescriptor = $convert.base64Decode(
    'Cg1Qcm9ncmFtQ2hhbmdlEjYKCXN0YXRlbWVudBgBIAEoCzIWLm1vdGlmLlN0YXRlbWVudENoYW'
    '5nZUgAUglzdGF0ZW1lbnQSKgoFc3R5bGUYAiABKAsyEi5tb3RpZi5TdHlsZUNoYW5nZUgAUgVz'
    'dHlsZRIqCgVhc3NldBgDIAEoCzISLm1vdGlmLkFzc2V0Q2hhbmdlSABSBWFzc2V0EjMKCHNldH'
    'RpbmdzGAQgASgLMhUubW90aWYuU2V0dGluZ3NDaGFuZ2VIAFIIc2V0dGluZ3MSFgoFZW1wdHkY'
    'ZCABKAhIAFIFZW1wdHlCBwoFdmFsdWU=');

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

@$core.Deprecated('Use cornerRadiiDescriptor instead')
const CornerRadii$json = {
  '1': 'CornerRadii',
  '2': [
    {
      '1': 'corners',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.motif.CornerRadii.CornersEntry',
      '10': 'corners'
    },
  ],
  '3': [CornerRadii_CornersEntry$json],
};

@$core.Deprecated('Use cornerRadiiDescriptor instead')
const CornerRadii_CornersEntry$json = {
  '1': 'CornersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.CornerRadius',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `CornerRadii`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cornerRadiiDescriptor = $convert.base64Decode(
    'CgtDb3JuZXJSYWRpaRI5Cgdjb3JuZXJzGAEgAygLMh8ubW90aWYuQ29ybmVyUmFkaWkuQ29ybm'
    'Vyc0VudHJ5Ugdjb3JuZXJzGk8KDENvcm5lcnNFbnRyeRIQCgNrZXkYASABKAVSA2tleRIpCgV2'
    'YWx1ZRgCIAEoCzITLm1vdGlmLkNvcm5lclJhZGl1c1IFdmFsdWU6AjgB');

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

@$core.Deprecated('Use nodeDescriptor instead')
const Node$json = {
  '1': 'Node',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 11, '6': '.motif.NodeId', '10': 'id'},
    {
      '1': 'generator_input',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.GeneratorInput',
      '9': 0,
      '10': 'generatorInput'
    },
    {
      '1': 'generator_output',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.GeneratorOutput',
      '9': 0,
      '10': 'generatorOutput'
    },
    {
      '1': 'merge',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Merge',
      '9': 0,
      '10': 'merge'
    },
    {
      '1': 'vertex',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Vertex',
      '9': 0,
      '10': 'vertex'
    },
    {
      '1': 'rectangle',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Rectangle',
      '9': 0,
      '10': 'rectangle'
    },
    {
      '1': 'array',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Array',
      '9': 0,
      '10': 'array'
    },
    {
      '1': 'transform',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Transform',
      '9': 0,
      '10': 'transform'
    },
    {
      '1': 'connect_vertices',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.ConnectVertices',
      '9': 0,
      '10': 'connectVertices'
    },
    {
      '1': 'make_face',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.MakeFace',
      '9': 0,
      '10': 'makeFace'
    },
    {
      '1': 'bounding_box',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.BoundingBox',
      '9': 0,
      '10': 'boundingBox'
    },
    {
      '1': 'index',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Index',
      '9': 0,
      '10': 'index'
    },
    {
      '1': 'math',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Math',
      '9': 0,
      '10': 'math'
    },
    {
      '1': 'vector_math',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.VectorMath',
      '9': 0,
      '10': 'vectorMath'
    },
    {
      '1': 'trig_math',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.TrigMath',
      '9': 0,
      '10': 'trigMath'
    },
    {
      '1': 'expression',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Expression',
      '9': 0,
      '10': 'expression'
    },
    {
      '1': 'math_constant',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.MathConstant',
      '9': 0,
      '10': 'mathConstant'
    },
    {
      '1': 'math_round',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.MathRound',
      '9': 0,
      '10': 'mathRound'
    },
    {
      '1': 'combine_x_y',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.CombineXY',
      '9': 0,
      '10': 'combineXY'
    },
    {
      '1': 'separate_x_y',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.SeparateXY',
      '9': 0,
      '10': 'separateXY'
    },
    {
      '1': 'polar',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.Polar',
      '9': 0,
      '10': 'polar'
    },
    {
      '1': 'random_float',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.RandomFloat',
      '9': 0,
      '10': 'randomFloat'
    },
    {
      '1': 'random_vector',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.motif.Node.RandomVector',
      '9': 0,
      '10': 'randomVector'
    },
  ],
  '3': [
    Node_GeneratorInput$json,
    Node_GeneratorOutput$json,
    Node_Merge$json,
    Node_Vertex$json,
    Node_Rectangle$json,
    Node_Array$json,
    Node_Transform$json,
    Node_ConnectVertices$json,
    Node_MakeFace$json,
    Node_BoundingBox$json,
    Node_Index$json,
    Node_Math$json,
    Node_VectorMath$json,
    Node_TrigMath$json,
    Node_Expression$json,
    Node_MathConstant$json,
    Node_MathRound$json,
    Node_CombineXY$json,
    Node_SeparateXY$json,
    Node_Polar$json,
    Node_RandomFloat$json,
    Node_RandomVector$json
  ],
  '8': [
    {'1': 'kind'},
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
const Node_Merge$json = {
  '1': 'Merge',
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Vertex$json = {
  '1': 'Vertex',
  '2': [
    {
      '1': 'position',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'position',
      '17': true
    },
  ],
  '8': [
    {'1': '_position'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Rectangle$json = {
  '1': 'Rectangle',
  '2': [
    {
      '1': 'center',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'center',
      '17': true
    },
    {
      '1': 'size',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 1,
      '10': 'size',
      '17': true
    },
  ],
  '8': [
    {'1': '_center'},
    {'1': '_size'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Array$json = {
  '1': 'Array',
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
      '1': 'count',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 2,
      '10': 'count',
      '17': true
    },
  ],
  '8': [
    {'1': '_slice'},
    {'1': '_offset'},
    {'1': '_count'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Transform$json = {
  '1': 'Transform',
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
    {
      '1': 'translation',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 1,
      '10': 'translation',
      '17': true
    },
    {
      '1': 'scale',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 2,
      '10': 'scale',
      '17': true
    },
    {
      '1': 'rotation',
      '3': 4,
      '4': 1,
      '5': 1,
      '9': 3,
      '10': 'rotation',
      '17': true
    },
  ],
  '8': [
    {'1': '_slice'},
    {'1': '_translation'},
    {'1': '_scale'},
    {'1': '_rotation'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_ConnectVertices$json = {
  '1': 'ConnectVertices',
  '2': [
    {'1': 'closed', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'closed', '17': true},
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
    {'1': '_closed'},
    {'1': '_slice'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_MakeFace$json = {
  '1': 'MakeFace',
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
const Node_BoundingBox$json = {
  '1': 'BoundingBox',
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
const Node_Index$json = {
  '1': 'Index',
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Math$json = {
  '1': 'Math',
  '2': [
    {'1': 'a', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'a', '17': true},
    {'1': 'b', '3': 2, '4': 1, '5': 1, '9': 1, '10': 'b', '17': true},
    {
      '1': 'operator',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.motif.MathOperatorType',
      '9': 2,
      '10': 'operator',
      '17': true
    },
  ],
  '8': [
    {'1': '_a'},
    {'1': '_b'},
    {'1': '_operator'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_VectorMath$json = {
  '1': 'VectorMath',
  '2': [
    {
      '1': 'a',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 0,
      '10': 'a',
      '17': true
    },
    {
      '1': 'b',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.motif.Vec2',
      '9': 1,
      '10': 'b',
      '17': true
    },
    {
      '1': 'operator',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.motif.VectorMathOperatorType',
      '9': 2,
      '10': 'operator',
      '17': true
    },
  ],
  '8': [
    {'1': '_a'},
    {'1': '_b'},
    {'1': '_operator'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_TrigMath$json = {
  '1': 'TrigMath',
  '2': [
    {'1': 'input', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'input', '17': true},
    {
      '1': 'operator',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.motif.TrigMathOperatorType',
      '9': 1,
      '10': 'operator',
      '17': true
    },
  ],
  '8': [
    {'1': '_input'},
    {'1': '_operator'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_Expression$json = {
  '1': 'Expression',
  '2': [
    {
      '1': 'expression',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'expression',
      '17': true
    },
  ],
  '8': [
    {'1': '_expression'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_MathConstant$json = {
  '1': 'MathConstant',
  '2': [
    {
      '1': 'constant',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.motif.MathConstantType',
      '9': 0,
      '10': 'constant',
      '17': true
    },
  ],
  '8': [
    {'1': '_constant'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_MathRound$json = {
  '1': 'MathRound',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'value', '17': true},
    {
      '1': 'mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.motif.MathRoundType',
      '9': 1,
      '10': 'mode',
      '17': true
    },
  ],
  '8': [
    {'1': '_value'},
    {'1': '_mode'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_CombineXY$json = {
  '1': 'CombineXY',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'x', '17': true},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '9': 1, '10': 'y', '17': true},
  ],
  '8': [
    {'1': '_x'},
    {'1': '_y'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_SeparateXY$json = {
  '1': 'SeparateXY',
  '2': [
    {
      '1': 'value',
      '3': 1,
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
const Node_Polar$json = {
  '1': 'Polar',
  '2': [
    {'1': 'radius', '3': 1, '4': 1, '5': 1, '9': 0, '10': 'radius', '17': true},
    {'1': 'angle', '3': 2, '4': 1, '5': 1, '9': 1, '10': 'angle', '17': true},
  ],
  '8': [
    {'1': '_radius'},
    {'1': '_angle'},
  ],
};

@$core.Deprecated('Use nodeDescriptor instead')
const Node_RandomFloat$json = {
  '1': 'RandomFloat',
  '2': [
    {'1': 'seed', '3': 1, '4': 1, '5': 5, '9': 0, '10': 'seed', '17': true},
    {'1': 'min', '3': 2, '4': 1, '5': 1, '9': 1, '10': 'min', '17': true},
    {'1': 'max', '3': 3, '4': 1, '5': 1, '9': 2, '10': 'max', '17': true},
  ],
  '8': [
    {'1': '_seed'},
    {'1': '_min'},
    {'1': '_max'},
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

/// Descriptor for `Node`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodeDescriptor = $convert.base64Decode(
    'CgROb2RlEh0KAmlkGAEgASgLMg0ubW90aWYuTm9kZUlkUgJpZBJFCg9nZW5lcmF0b3JfaW5wdX'
    'QYCiABKAsyGi5tb3RpZi5Ob2RlLkdlbmVyYXRvcklucHV0SABSDmdlbmVyYXRvcklucHV0EkgK'
    'EGdlbmVyYXRvcl9vdXRwdXQYCyABKAsyGy5tb3RpZi5Ob2RlLkdlbmVyYXRvck91dHB1dEgAUg'
    '9nZW5lcmF0b3JPdXRwdXQSKQoFbWVyZ2UYDCABKAsyES5tb3RpZi5Ob2RlLk1lcmdlSABSBW1l'
    'cmdlEiwKBnZlcnRleBgNIAEoCzISLm1vdGlmLk5vZGUuVmVydGV4SABSBnZlcnRleBI1CglyZW'
    'N0YW5nbGUYDiABKAsyFS5tb3RpZi5Ob2RlLlJlY3RhbmdsZUgAUglyZWN0YW5nbGUSKQoFYXJy'
    'YXkYDyABKAsyES5tb3RpZi5Ob2RlLkFycmF5SABSBWFycmF5EjUKCXRyYW5zZm9ybRgQIAEoCz'
    'IVLm1vdGlmLk5vZGUuVHJhbnNmb3JtSABSCXRyYW5zZm9ybRJIChBjb25uZWN0X3ZlcnRpY2Vz'
    'GBEgASgLMhsubW90aWYuTm9kZS5Db25uZWN0VmVydGljZXNIAFIPY29ubmVjdFZlcnRpY2VzEj'
    'MKCW1ha2VfZmFjZRgSIAEoCzIULm1vdGlmLk5vZGUuTWFrZUZhY2VIAFIIbWFrZUZhY2USPAoM'
    'Ym91bmRpbmdfYm94GBMgASgLMhcubW90aWYuTm9kZS5Cb3VuZGluZ0JveEgAUgtib3VuZGluZ0'
    'JveBIpCgVpbmRleBgUIAEoCzIRLm1vdGlmLk5vZGUuSW5kZXhIAFIFaW5kZXgSJgoEbWF0aBgV'
    'IAEoCzIQLm1vdGlmLk5vZGUuTWF0aEgAUgRtYXRoEjkKC3ZlY3Rvcl9tYXRoGBYgASgLMhYubW'
    '90aWYuTm9kZS5WZWN0b3JNYXRoSABSCnZlY3Rvck1hdGgSMwoJdHJpZ19tYXRoGBcgASgLMhQu'
    'bW90aWYuTm9kZS5UcmlnTWF0aEgAUgh0cmlnTWF0aBI4CgpleHByZXNzaW9uGBggASgLMhYubW'
    '90aWYuTm9kZS5FeHByZXNzaW9uSABSCmV4cHJlc3Npb24SPwoNbWF0aF9jb25zdGFudBgZIAEo'
    'CzIYLm1vdGlmLk5vZGUuTWF0aENvbnN0YW50SABSDG1hdGhDb25zdGFudBI2CgptYXRoX3JvdW'
    '5kGBogASgLMhUubW90aWYuTm9kZS5NYXRoUm91bmRIAFIJbWF0aFJvdW5kEjcKC2NvbWJpbmVf'
    'eF95GBsgASgLMhUubW90aWYuTm9kZS5Db21iaW5lWFlIAFIJY29tYmluZVhZEjoKDHNlcGFyYX'
    'RlX3hfeRgcIAEoCzIWLm1vdGlmLk5vZGUuU2VwYXJhdGVYWUgAUgpzZXBhcmF0ZVhZEikKBXBv'
    'bGFyGB0gASgLMhEubW90aWYuTm9kZS5Qb2xhckgAUgVwb2xhchI8CgxyYW5kb21fZmxvYXQYHi'
    'ABKAsyFy5tb3RpZi5Ob2RlLlJhbmRvbUZsb2F0SABSC3JhbmRvbUZsb2F0Ej8KDXJhbmRvbV92'
    'ZWN0b3IYHyABKAsyGC5tb3RpZi5Ob2RlLlJhbmRvbVZlY3RvckgAUgxyYW5kb21WZWN0b3IaEA'
    'oOR2VuZXJhdG9ySW5wdXQaEQoPR2VuZXJhdG9yT3V0cHV0GgcKBU1lcmdlGkMKBlZlcnRleBIs'
    'Cghwb3NpdGlvbhgBIAEoCzILLm1vdGlmLlZlYzJIAFIIcG9zaXRpb26IAQFCCwoJX3Bvc2l0aW'
    '9uGm8KCVJlY3RhbmdsZRIoCgZjZW50ZXIYASABKAsyCy5tb3RpZi5WZWMySABSBmNlbnRlcogB'
    'ARIkCgRzaXplGAIgASgLMgsubW90aWYuVmVjMkgBUgRzaXpliAEBQgkKB19jZW50ZXJCBwoFX3'
    'NpemUaqAEKBUFycmF5Ei4KBXNsaWNlGAEgASgLMhMubW90aWYuUHJvZ3JhbVNsaWNlSABSBXNs'
    'aWNliAEBEigKBm9mZnNldBgCIAEoCzILLm1vdGlmLlZlYzJIAVIGb2Zmc2V0iAEBEiYKBWNvdW'
    '50GAMgASgLMgsubW90aWYuVmVjMkgCUgVjb3VudIgBAUIICgZfc2xpY2VCCQoHX29mZnNldEII'
    'CgZfY291bnQa6QEKCVRyYW5zZm9ybRIuCgVzbGljZRgBIAEoCzITLm1vdGlmLlByb2dyYW1TbG'
    'ljZUgAUgVzbGljZYgBARIyCgt0cmFuc2xhdGlvbhgCIAEoCzILLm1vdGlmLlZlYzJIAVILdHJh'
    'bnNsYXRpb26IAQESJgoFc2NhbGUYAyABKAsyCy5tb3RpZi5WZWMySAJSBXNjYWxliAEBEh8KCH'
    'JvdGF0aW9uGAQgASgBSANSCHJvdGF0aW9uiAEBQggKBl9zbGljZUIOCgxfdHJhbnNsYXRpb25C'
    'CAoGX3NjYWxlQgsKCV9yb3RhdGlvbhpzCg9Db25uZWN0VmVydGljZXMSGwoGY2xvc2VkGAEgAS'
    'gISABSBmNsb3NlZIgBARIuCgVzbGljZRgCIAEoCzITLm1vdGlmLlByb2dyYW1TbGljZUgBUgVz'
    'bGljZYgBAUIJCgdfY2xvc2VkQggKBl9zbGljZRpECghNYWtlRmFjZRIuCgVzbGljZRgBIAEoCz'
    'ITLm1vdGlmLlByb2dyYW1TbGljZUgAUgVzbGljZYgBAUIICgZfc2xpY2UaRwoLQm91bmRpbmdC'
    'b3gSLgoFc2xpY2UYASABKAsyEy5tb3RpZi5Qcm9ncmFtU2xpY2VIAFIFc2xpY2WIAQFCCAoGX3'
    'NsaWNlGgcKBUluZGV4Gn8KBE1hdGgSEQoBYRgBIAEoAUgAUgFhiAEBEhEKAWIYAiABKAFIAVIB'
    'YogBARI4CghvcGVyYXRvchgDIAEoDjIXLm1vdGlmLk1hdGhPcGVyYXRvclR5cGVIAlIIb3Blcm'
    'F0b3KIAQFCBAoCX2FCBAoCX2JCCwoJX29wZXJhdG9yGqUBCgpWZWN0b3JNYXRoEh4KAWEYASAB'
    'KAsyCy5tb3RpZi5WZWMySABSAWGIAQESHgoBYhgCIAEoCzILLm1vdGlmLlZlYzJIAVIBYogBAR'
    'I+CghvcGVyYXRvchgDIAEoDjIdLm1vdGlmLlZlY3Rvck1hdGhPcGVyYXRvclR5cGVIAlIIb3Bl'
    'cmF0b3KIAQFCBAoCX2FCBAoCX2JCCwoJX29wZXJhdG9yGnoKCFRyaWdNYXRoEhkKBWlucHV0GA'
    'EgASgBSABSBWlucHV0iAEBEjwKCG9wZXJhdG9yGAIgASgOMhsubW90aWYuVHJpZ01hdGhPcGVy'
    'YXRvclR5cGVIAVIIb3BlcmF0b3KIAQFCCAoGX2lucHV0QgsKCV9vcGVyYXRvchpACgpFeHByZX'
    'NzaW9uEiMKCmV4cHJlc3Npb24YASABKAlIAFIKZXhwcmVzc2lvbogBAUINCgtfZXhwcmVzc2lv'
    'bhpVCgxNYXRoQ29uc3RhbnQSOAoIY29uc3RhbnQYASABKA4yFy5tb3RpZi5NYXRoQ29uc3Rhbn'
    'RUeXBlSABSCGNvbnN0YW50iAEBQgsKCV9jb25zdGFudBpoCglNYXRoUm91bmQSGQoFdmFsdWUY'
    'ASABKAFIAFIFdmFsdWWIAQESLQoEbW9kZRgCIAEoDjIULm1vdGlmLk1hdGhSb3VuZFR5cGVIAV'
    'IEbW9kZYgBAUIICgZfdmFsdWVCBwoFX21vZGUaPQoJQ29tYmluZVhZEhEKAXgYASABKAFIAFIB'
    'eIgBARIRCgF5GAIgASgBSAFSAXmIAQFCBAoCX3hCBAoCX3kaPgoKU2VwYXJhdGVYWRImCgV2YW'
    'x1ZRgBIAEoCzILLm1vdGlmLlZlYzJIAFIFdmFsdWWIAQFCCAoGX3ZhbHVlGlQKBVBvbGFyEhsK'
    'BnJhZGl1cxgBIAEoAUgAUgZyYWRpdXOIAQESGQoFYW5nbGUYAiABKAFIAVIFYW5nbGWIAQFCCQ'
    'oHX3JhZGl1c0IICgZfYW5nbGUabQoLUmFuZG9tRmxvYXQSFwoEc2VlZBgBIAEoBUgAUgRzZWVk'
    'iAEBEhUKA21pbhgCIAEoAUgBUgNtaW6IAQESFQoDbWF4GAMgASgBSAJSA21heIgBAUIHCgVfc2'
    'VlZEIGCgRfbWluQgYKBF9tYXgaiAEKDFJhbmRvbVZlY3RvchIXCgRzZWVkGAEgASgFSABSBHNl'
    'ZWSIAQESIgoDbWluGAIgASgLMgsubW90aWYuVmVjMkgBUgNtaW6IAQESIgoDbWF4GAMgASgLMg'
    'subW90aWYuVmVjMkgCUgNtYXiIAQFCBwoFX3NlZWRCBgoEX21pbkIGCgRfbWF4QgYKBGtpbmQ=');
