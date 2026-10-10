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
  static const layout = PropKind<Layout, Layout>(LayoutProp.new);

  static const strokeWidth = PropKind<double, double>(StrokeWidthProp.new);
  static const decorations = PropKind<Decorations, Decorations>(DecorationsProp.new);
  static const edgeStyle = PropKind<EdgeStyle, EdgeStylePartial>(EdgeStyleProp.new);
  static const faceStyle = PropKind<FaceStyle, FaceStylePartial>(FaceStyleProp.new);

  static const textFormat = PropKind<TextFormat, TextFormatPartial>(TextFormatProp.new);
  static const paragraphFormat = PropKind<ParagraphFormat, ParagraphFormatPartial>(ParagraphFormatProp.new);

  static const modifierStack = PropKind<ModifierStack, ModifierStack>(ModifierStackProp.new);

  static const boolean = PropKind<bool, bool>(BooleanProp.new);
  static const string = PropKind<String, String>(StringProp.new);

  Prop<G, S> compose(Iterable<PropSource> props) {
    return factory(props.cast<PropSource<G, S>>().toList());
  }
}
