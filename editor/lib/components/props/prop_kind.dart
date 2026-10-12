part of 'prop.dart';

final class const PropKind<G, S>(
  final Prop<G, S> Function(List<PropSource<G, S>>) factory,
) {
  static const coordinate = PropKind<double, double>(CoordinateProp.new);
  static const position = PropKind<Vec2, Vec2Partial>(PositionProp.new);
  static const rotation = PropKind<Angle2, Angle2>(RotationProp.new);
  static const transform = PropKind<TransformData, TransformDataPartial>(TransformProp.new);

  static const layoutDimension = PropKind<LayoutDimension, LayoutDimension>(LayoutDimensionProp.new);
  static const layoutSize = PropKind<LayoutSize, LayoutSizePartial>(LayoutSizeProp.new);

  static const layout = PropKind<Layout, LayoutPartial>(LayoutProp.new);
  static const layoutKind = PropKind<LayoutKind, LayoutPartial>(LayoutKindProp.new);
  static const layoutPadding = PropKind<LayoutInsets, LayoutInsetsPartial>(LayoutInsetsProp.new);

  static const layoutStack = PropKind<StackLayout, StackLayoutPartial>(StackLayoutProp.new);
  static const layoutFlex = PropKind<FlexLayout, FlexLayoutPartial>(FlexLayoutProp.new);

  static const layoutAlign = PropKind<LayoutAlign, LayoutAlign>(LayoutAlignProp.new);
  static const layoutJustify = PropKind<LayoutJustify, LayoutJustify>(LayoutJustifyProp.new);
  static const layoutGap = PropKind<double, double>(LayoutGapProp.new);

  static const strokeWidth = PropKind<double, double>(StrokeWidthProp.new);
  static const decorations = PropKind<Decorations, Decorations>(DecorationsProp.new);
  static const edgeStyle = PropKind<EdgeStyle, EdgeStylePartial>(EdgeStyleProp.new);
  static const faceStyle = PropKind<FaceStyle, FaceStylePartial>(FaceStyleProp.new);

  static const textFormat = PropKind<TextFormat, TextFormatPartial>(TextFormatProp.new);
  static const paragraphFormat = PropKind<ParagraphFormat, ParagraphFormatPartial>(ParagraphFormatProp.new);

  static const modifierStack = PropKind<ModifierStack, ModifierStack>(ModifierStackProp.new);

  static const boolean = PropKind<bool, bool>(BooleanProp.new);
  static const string = PropKind<String, String>(StringProp.new);
  static const double_ = PropKind<double, double>(DoubleProp.new);

  Prop<G, S> compose(Iterable<PropSource> props) {
    return factory(props.cast<PropSource<G, S>>().toList());
  }
}
