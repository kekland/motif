// This is a generated file - do not edit.
//
// Generated from core/program/program.proto.

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

class ZPlacement extends $pb.ProtobufEnum {
  static const ZPlacement Z_PLACEMENT_TOP =
      ZPlacement._(0, _omitEnumNames ? '' : 'Z_PLACEMENT_TOP');
  static const ZPlacement Z_PLACEMENT_BOTTOM =
      ZPlacement._(1, _omitEnumNames ? '' : 'Z_PLACEMENT_BOTTOM');
  static const ZPlacement Z_PLACEMENT_ABOVE =
      ZPlacement._(2, _omitEnumNames ? '' : 'Z_PLACEMENT_ABOVE');
  static const ZPlacement Z_PLACEMENT_BELOW =
      ZPlacement._(3, _omitEnumNames ? '' : 'Z_PLACEMENT_BELOW');

  static const $core.List<ZPlacement> values = <ZPlacement>[
    Z_PLACEMENT_TOP,
    Z_PLACEMENT_BOTTOM,
    Z_PLACEMENT_ABOVE,
    Z_PLACEMENT_BELOW,
  ];

  static final $core.List<ZPlacement?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ZPlacement? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ZPlacement._(super.value, super.name);
}

class TextFontSlant extends $pb.ProtobufEnum {
  static const TextFontSlant TEXT_FONT_SLANT_UPRIGHT =
      TextFontSlant._(0, _omitEnumNames ? '' : 'TEXT_FONT_SLANT_UPRIGHT');
  static const TextFontSlant TEXT_FONT_SLANT_ITALIC =
      TextFontSlant._(1, _omitEnumNames ? '' : 'TEXT_FONT_SLANT_ITALIC');
  static const TextFontSlant TEXT_FONT_SLANT_OBLIQUE =
      TextFontSlant._(2, _omitEnumNames ? '' : 'TEXT_FONT_SLANT_OBLIQUE');

  static const $core.List<TextFontSlant> values = <TextFontSlant>[
    TEXT_FONT_SLANT_UPRIGHT,
    TEXT_FONT_SLANT_ITALIC,
    TEXT_FONT_SLANT_OBLIQUE,
  ];

  static final $core.List<TextFontSlant?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TextFontSlant? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TextFontSlant._(super.value, super.name);
}

class TextFontWeight extends $pb.ProtobufEnum {
  static const TextFontWeight TEXT_FONT_WEIGHT_THIN =
      TextFontWeight._(0, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_THIN');
  static const TextFontWeight TEXT_FONT_WEIGHT_EXTRA_LIGHT =
      TextFontWeight._(1, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_EXTRA_LIGHT');
  static const TextFontWeight TEXT_FONT_WEIGHT_LIGHT =
      TextFontWeight._(2, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_LIGHT');
  static const TextFontWeight TEXT_FONT_WEIGHT_REGULAR =
      TextFontWeight._(3, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_REGULAR');
  static const TextFontWeight TEXT_FONT_WEIGHT_MEDIUM =
      TextFontWeight._(4, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_MEDIUM');
  static const TextFontWeight TEXT_FONT_WEIGHT_SEMI_BOLD =
      TextFontWeight._(5, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_SEMI_BOLD');
  static const TextFontWeight TEXT_FONT_WEIGHT_BOLD =
      TextFontWeight._(6, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_BOLD');
  static const TextFontWeight TEXT_FONT_WEIGHT_EXTRA_BOLD =
      TextFontWeight._(7, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_EXTRA_BOLD');
  static const TextFontWeight TEXT_FONT_WEIGHT_BLACK =
      TextFontWeight._(8, _omitEnumNames ? '' : 'TEXT_FONT_WEIGHT_BLACK');

  static const $core.List<TextFontWeight> values = <TextFontWeight>[
    TEXT_FONT_WEIGHT_THIN,
    TEXT_FONT_WEIGHT_EXTRA_LIGHT,
    TEXT_FONT_WEIGHT_LIGHT,
    TEXT_FONT_WEIGHT_REGULAR,
    TEXT_FONT_WEIGHT_MEDIUM,
    TEXT_FONT_WEIGHT_SEMI_BOLD,
    TEXT_FONT_WEIGHT_BOLD,
    TEXT_FONT_WEIGHT_EXTRA_BOLD,
    TEXT_FONT_WEIGHT_BLACK,
  ];

  static final $core.List<TextFontWeight?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static TextFontWeight? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TextFontWeight._(super.value, super.name);
}

class TextFontWidth extends $pb.ProtobufEnum {
  static const TextFontWidth TEXT_FONT_WIDTH_ULTRA_CONDENSED = TextFontWidth._(
      0, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_ULTRA_CONDENSED');
  static const TextFontWidth TEXT_FONT_WIDTH_EXTRA_CONDENSED = TextFontWidth._(
      1, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_EXTRA_CONDENSED');
  static const TextFontWidth TEXT_FONT_WIDTH_CONDENSED =
      TextFontWidth._(2, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_CONDENSED');
  static const TextFontWidth TEXT_FONT_WIDTH_SEMI_CONDENSED = TextFontWidth._(
      3, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_SEMI_CONDENSED');
  static const TextFontWidth TEXT_FONT_WIDTH_NORMAL =
      TextFontWidth._(4, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_NORMAL');
  static const TextFontWidth TEXT_FONT_WIDTH_SEMI_EXPANDED =
      TextFontWidth._(5, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_SEMI_EXPANDED');
  static const TextFontWidth TEXT_FONT_WIDTH_EXPANDED =
      TextFontWidth._(6, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_EXPANDED');
  static const TextFontWidth TEXT_FONT_WIDTH_EXTRA_EXPANDED = TextFontWidth._(
      7, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_EXTRA_EXPANDED');
  static const TextFontWidth TEXT_FONT_WIDTH_ULTRA_EXPANDED = TextFontWidth._(
      8, _omitEnumNames ? '' : 'TEXT_FONT_WIDTH_ULTRA_EXPANDED');

  static const $core.List<TextFontWidth> values = <TextFontWidth>[
    TEXT_FONT_WIDTH_ULTRA_CONDENSED,
    TEXT_FONT_WIDTH_EXTRA_CONDENSED,
    TEXT_FONT_WIDTH_CONDENSED,
    TEXT_FONT_WIDTH_SEMI_CONDENSED,
    TEXT_FONT_WIDTH_NORMAL,
    TEXT_FONT_WIDTH_SEMI_EXPANDED,
    TEXT_FONT_WIDTH_EXPANDED,
    TEXT_FONT_WIDTH_EXTRA_EXPANDED,
    TEXT_FONT_WIDTH_ULTRA_EXPANDED,
  ];

  static final $core.List<TextFontWidth?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static TextFontWidth? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TextFontWidth._(super.value, super.name);
}

class TextDecorationKind extends $pb.ProtobufEnum {
  static const TextDecorationKind TEXT_DECORATION_KIND_UNDERLINE =
      TextDecorationKind._(
          0, _omitEnumNames ? '' : 'TEXT_DECORATION_KIND_UNDERLINE');
  static const TextDecorationKind TEXT_DECORATION_KIND_OVERLINE =
      TextDecorationKind._(
          1, _omitEnumNames ? '' : 'TEXT_DECORATION_KIND_OVERLINE');
  static const TextDecorationKind TEXT_DECORATION_KIND_STRIKETHROUGH =
      TextDecorationKind._(
          2, _omitEnumNames ? '' : 'TEXT_DECORATION_KIND_STRIKETHROUGH');

  static const $core.List<TextDecorationKind> values = <TextDecorationKind>[
    TEXT_DECORATION_KIND_UNDERLINE,
    TEXT_DECORATION_KIND_OVERLINE,
    TEXT_DECORATION_KIND_STRIKETHROUGH,
  ];

  static final $core.List<TextDecorationKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TextDecorationKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TextDecorationKind._(super.value, super.name);
}

class TextAlignment extends $pb.ProtobufEnum {
  static const TextAlignment TEXT_ALIGNMENT_LEFT =
      TextAlignment._(0, _omitEnumNames ? '' : 'TEXT_ALIGNMENT_LEFT');
  static const TextAlignment TEXT_ALIGNMENT_RIGHT =
      TextAlignment._(1, _omitEnumNames ? '' : 'TEXT_ALIGNMENT_RIGHT');
  static const TextAlignment TEXT_ALIGNMENT_CENTER =
      TextAlignment._(2, _omitEnumNames ? '' : 'TEXT_ALIGNMENT_CENTER');
  static const TextAlignment TEXT_ALIGNMENT_JUSTIFY =
      TextAlignment._(3, _omitEnumNames ? '' : 'TEXT_ALIGNMENT_JUSTIFY');

  static const $core.List<TextAlignment> values = <TextAlignment>[
    TEXT_ALIGNMENT_LEFT,
    TEXT_ALIGNMENT_RIGHT,
    TEXT_ALIGNMENT_CENTER,
    TEXT_ALIGNMENT_JUSTIFY,
  ];

  static final $core.List<TextAlignment?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TextAlignment? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TextAlignment._(super.value, super.name);
}

class TextVerticalAlignment extends $pb.ProtobufEnum {
  static const TextVerticalAlignment TEXT_VERTICAL_ALIGNMENT_TOP =
      TextVerticalAlignment._(
          0, _omitEnumNames ? '' : 'TEXT_VERTICAL_ALIGNMENT_TOP');
  static const TextVerticalAlignment TEXT_VERTICAL_ALIGNMENT_MIDDLE =
      TextVerticalAlignment._(
          1, _omitEnumNames ? '' : 'TEXT_VERTICAL_ALIGNMENT_MIDDLE');
  static const TextVerticalAlignment TEXT_VERTICAL_ALIGNMENT_BOTTOM =
      TextVerticalAlignment._(
          2, _omitEnumNames ? '' : 'TEXT_VERTICAL_ALIGNMENT_BOTTOM');

  static const $core.List<TextVerticalAlignment> values =
      <TextVerticalAlignment>[
    TEXT_VERTICAL_ALIGNMENT_TOP,
    TEXT_VERTICAL_ALIGNMENT_MIDDLE,
    TEXT_VERTICAL_ALIGNMENT_BOTTOM,
  ];

  static final $core.List<TextVerticalAlignment?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TextVerticalAlignment? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TextVerticalAlignment._(super.value, super.name);
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
