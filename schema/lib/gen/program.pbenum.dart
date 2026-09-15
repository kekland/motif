// This is a generated file - do not edit.
//
// Generated from program.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CellKind extends $pb.ProtobufEnum {
  static const CellKind CELL_KIND_FRAME =
      CellKind._(0, _omitEnumNames ? '' : 'CELL_KIND_FRAME');
  static const CellKind CELL_KIND_VERTEX =
      CellKind._(1, _omitEnumNames ? '' : 'CELL_KIND_VERTEX');
  static const CellKind CELL_KIND_EDGE =
      CellKind._(2, _omitEnumNames ? '' : 'CELL_KIND_EDGE');
  static const CellKind CELL_KIND_FACE =
      CellKind._(3, _omitEnumNames ? '' : 'CELL_KIND_FACE');

  static const $core.List<CellKind> values = <CellKind>[
    CELL_KIND_FRAME,
    CELL_KIND_VERTEX,
    CELL_KIND_EDGE,
    CELL_KIND_FACE,
  ];

  static final $core.List<CellKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CellKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CellKind._(super.value, super.name);
}

class GlueVerticesStatement_Position extends $pb.ProtobufEnum {
  static const GlueVerticesStatement_Position
      GLUE_VERTICES_STATEMENT_POSITION_FIRST = GlueVerticesStatement_Position._(
          0, _omitEnumNames ? '' : 'GLUE_VERTICES_STATEMENT_POSITION_FIRST');
  static const GlueVerticesStatement_Position
      GLUE_VERTICES_STATEMENT_POSITION_CENTROID =
      GlueVerticesStatement_Position._(
          1, _omitEnumNames ? '' : 'GLUE_VERTICES_STATEMENT_POSITION_CENTROID');

  static const $core.List<GlueVerticesStatement_Position> values =
      <GlueVerticesStatement_Position>[
    GLUE_VERTICES_STATEMENT_POSITION_FIRST,
    GLUE_VERTICES_STATEMENT_POSITION_CENTROID,
  ];

  static final $core.List<GlueVerticesStatement_Position?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static GlueVerticesStatement_Position? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GlueVerticesStatement_Position._(super.value, super.name);
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

class Layout_Align extends $pb.ProtobufEnum {
  static const Layout_Align LAYOUT_ALIGN_START =
      Layout_Align._(0, _omitEnumNames ? '' : 'LAYOUT_ALIGN_START');
  static const Layout_Align LAYOUT_ALIGN_CENTER =
      Layout_Align._(1, _omitEnumNames ? '' : 'LAYOUT_ALIGN_CENTER');
  static const Layout_Align LAYOUT_ALIGN_END =
      Layout_Align._(2, _omitEnumNames ? '' : 'LAYOUT_ALIGN_END');

  static const $core.List<Layout_Align> values = <Layout_Align>[
    LAYOUT_ALIGN_START,
    LAYOUT_ALIGN_CENTER,
    LAYOUT_ALIGN_END,
  ];

  static final $core.List<Layout_Align?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Layout_Align? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Layout_Align._(super.value, super.name);
}

class Layout_Justify extends $pb.ProtobufEnum {
  static const Layout_Justify LAYOUT_JUSTIFY_START =
      Layout_Justify._(0, _omitEnumNames ? '' : 'LAYOUT_JUSTIFY_START');
  static const Layout_Justify LAYOUT_JUSTIFY_CENTER =
      Layout_Justify._(1, _omitEnumNames ? '' : 'LAYOUT_JUSTIFY_CENTER');
  static const Layout_Justify LAYOUT_JUSTIFY_END =
      Layout_Justify._(2, _omitEnumNames ? '' : 'LAYOUT_JUSTIFY_END');
  static const Layout_Justify LAYOUT_JUSTIFY_SPACE_BETWEEN =
      Layout_Justify._(3, _omitEnumNames ? '' : 'LAYOUT_JUSTIFY_SPACE_BETWEEN');

  static const $core.List<Layout_Justify> values = <Layout_Justify>[
    LAYOUT_JUSTIFY_START,
    LAYOUT_JUSTIFY_CENTER,
    LAYOUT_JUSTIFY_END,
    LAYOUT_JUSTIFY_SPACE_BETWEEN,
  ];

  static final $core.List<Layout_Justify?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Layout_Justify? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Layout_Justify._(super.value, super.name);
}

class Layout_Flex_Direction extends $pb.ProtobufEnum {
  static const Layout_Flex_Direction LAYOUT_FLEX_DIRECTION_ROW =
      Layout_Flex_Direction._(
          0, _omitEnumNames ? '' : 'LAYOUT_FLEX_DIRECTION_ROW');
  static const Layout_Flex_Direction LAYOUT_FLEX_DIRECTION_COLUMN =
      Layout_Flex_Direction._(
          1, _omitEnumNames ? '' : 'LAYOUT_FLEX_DIRECTION_COLUMN');

  static const $core.List<Layout_Flex_Direction> values =
      <Layout_Flex_Direction>[
    LAYOUT_FLEX_DIRECTION_ROW,
    LAYOUT_FLEX_DIRECTION_COLUMN,
  ];

  static final $core.List<Layout_Flex_Direction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static Layout_Flex_Direction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Layout_Flex_Direction._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
