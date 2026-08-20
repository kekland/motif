// This is a generated file - do not edit.
//
// Generated from scene.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LayoutAlign extends $pb.ProtobufEnum {
  static const LayoutAlign LAYOUT_ALIGN_START =
      LayoutAlign._(0, _omitEnumNames ? '' : 'LAYOUT_ALIGN_START');
  static const LayoutAlign LAYOUT_ALIGN_CENTER =
      LayoutAlign._(1, _omitEnumNames ? '' : 'LAYOUT_ALIGN_CENTER');
  static const LayoutAlign LAYOUT_ALIGN_END =
      LayoutAlign._(2, _omitEnumNames ? '' : 'LAYOUT_ALIGN_END');

  static const $core.List<LayoutAlign> values = <LayoutAlign>[
    LAYOUT_ALIGN_START,
    LAYOUT_ALIGN_CENTER,
    LAYOUT_ALIGN_END,
  ];

  static final $core.List<LayoutAlign?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static LayoutAlign? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LayoutAlign._(super.value, super.name);
}

class LayoutJustify extends $pb.ProtobufEnum {
  static const LayoutJustify LAYOUT_JUSTIFY_START =
      LayoutJustify._(0, _omitEnumNames ? '' : 'LAYOUT_JUSTIFY_START');
  static const LayoutJustify LAYOUT_JUSTIFY_CENTER =
      LayoutJustify._(1, _omitEnumNames ? '' : 'LAYOUT_JUSTIFY_CENTER');
  static const LayoutJustify LAYOUT_JUSTIFY_END =
      LayoutJustify._(2, _omitEnumNames ? '' : 'LAYOUT_JUSTIFY_END');
  static const LayoutJustify LAYOUT_JUSTIFY_SPACE_BETWEEN =
      LayoutJustify._(3, _omitEnumNames ? '' : 'LAYOUT_JUSTIFY_SPACE_BETWEEN');

  static const $core.List<LayoutJustify> values = <LayoutJustify>[
    LAYOUT_JUSTIFY_START,
    LAYOUT_JUSTIFY_CENTER,
    LAYOUT_JUSTIFY_END,
    LAYOUT_JUSTIFY_SPACE_BETWEEN,
  ];

  static final $core.List<LayoutJustify?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static LayoutJustify? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LayoutJustify._(super.value, super.name);
}

class FlexDirection extends $pb.ProtobufEnum {
  static const FlexDirection FLEX_DIRECTION_ROW =
      FlexDirection._(0, _omitEnumNames ? '' : 'FLEX_DIRECTION_ROW');
  static const FlexDirection FLEX_DIRECTION_COLUMN =
      FlexDirection._(1, _omitEnumNames ? '' : 'FLEX_DIRECTION_COLUMN');

  static const $core.List<FlexDirection> values = <FlexDirection>[
    FLEX_DIRECTION_ROW,
    FLEX_DIRECTION_COLUMN,
  ];

  static final $core.List<FlexDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static FlexDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FlexDirection._(super.value, super.name);
}

class GlueVerticesStatement_Position extends $pb.ProtobufEnum {
  static const GlueVerticesStatement_Position
      GLUE_VERTICES_STATEMENT_POSITION_CENTROID =
      GlueVerticesStatement_Position._(
          0, _omitEnumNames ? '' : 'GLUE_VERTICES_STATEMENT_POSITION_CENTROID');
  static const GlueVerticesStatement_Position
      GLUE_VERTICES_STATEMENT_POSITION_FIRST = GlueVerticesStatement_Position._(
          1, _omitEnumNames ? '' : 'GLUE_VERTICES_STATEMENT_POSITION_FIRST');

  static const $core.List<GlueVerticesStatement_Position> values =
      <GlueVerticesStatement_Position>[
    GLUE_VERTICES_STATEMENT_POSITION_CENTROID,
    GLUE_VERTICES_STATEMENT_POSITION_FIRST,
  ];

  static final $core.List<GlueVerticesStatement_Position?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static GlueVerticesStatement_Position? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GlueVerticesStatement_Position._(super.value, super.name);
}

class Ref_Kind extends $pb.ProtobufEnum {
  static const Ref_Kind REF_KIND_FRAME =
      Ref_Kind._(0, _omitEnumNames ? '' : 'REF_KIND_FRAME');
  static const Ref_Kind REF_KIND_VERTEX =
      Ref_Kind._(1, _omitEnumNames ? '' : 'REF_KIND_VERTEX');
  static const Ref_Kind REF_KIND_EDGE =
      Ref_Kind._(2, _omitEnumNames ? '' : 'REF_KIND_EDGE');
  static const Ref_Kind REF_KIND_FACE =
      Ref_Kind._(3, _omitEnumNames ? '' : 'REF_KIND_FACE');

  static const $core.List<Ref_Kind> values = <Ref_Kind>[
    REF_KIND_FRAME,
    REF_KIND_VERTEX,
    REF_KIND_EDGE,
    REF_KIND_FACE,
  ];

  static final $core.List<Ref_Kind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Ref_Kind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Ref_Kind._(super.value, super.name);
}

class LayoutDimension_Type extends $pb.ProtobufEnum {
  static const LayoutDimension_Type LAYOUT_DIMENSION_TYPE_FIXED =
      LayoutDimension_Type._(
          0, _omitEnumNames ? '' : 'LAYOUT_DIMENSION_TYPE_FIXED');
  static const LayoutDimension_Type LAYOUT_DIMENSION_TYPE_EXPAND =
      LayoutDimension_Type._(
          1, _omitEnumNames ? '' : 'LAYOUT_DIMENSION_TYPE_EXPAND');
  static const LayoutDimension_Type LAYOUT_DIMENSION_TYPE_CONTAIN =
      LayoutDimension_Type._(
          2, _omitEnumNames ? '' : 'LAYOUT_DIMENSION_TYPE_CONTAIN');

  static const $core.List<LayoutDimension_Type> values = <LayoutDimension_Type>[
    LAYOUT_DIMENSION_TYPE_FIXED,
    LAYOUT_DIMENSION_TYPE_EXPAND,
    LAYOUT_DIMENSION_TYPE_CONTAIN,
  ];

  static final $core.List<LayoutDimension_Type?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static LayoutDimension_Type? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LayoutDimension_Type._(super.value, super.name);
}

class ColorData_Type extends $pb.ProtobufEnum {
  static const ColorData_Type COLOR_DATA_TYPE_HSV =
      ColorData_Type._(0, _omitEnumNames ? '' : 'COLOR_DATA_TYPE_HSV');

  static const $core.List<ColorData_Type> values = <ColorData_Type>[
    COLOR_DATA_TYPE_HSV,
  ];

  static final $core.List<ColorData_Type?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 0);
  static ColorData_Type? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ColorData_Type._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
