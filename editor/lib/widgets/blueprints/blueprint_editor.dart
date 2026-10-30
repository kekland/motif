import 'package:blueprint/editor.dart';
import 'package:editor/imports.dart';

List<BlueprintSocketValueBuilder> blueprintSocketValueBuilders(BuildContext context) => [
  IntegerSocketValueBuilder(),
  BoolSocketValueBuilder(),
  DoubleSocketValueBuilder(),
  StringValueBuilder(),
  Vector22SocketValueBuilder(),
];

BlueprintEnums blueprintEnums(BuildContext context) => BlueprintEnums({
  MathOperatorType: MathOperatorType.values,
  VectorMathOperatorType: VectorMathOperatorType.values,
  MathConstantType: MathConstantType.values,
  MathRoundType: MathRoundType.values,
  MathCompareType: MathCompareType.values,
  InterpolationType: InterpolationType.values,
});

BlueprintColorResolvers blueprintColorResolvers(BuildContext context) => BlueprintColorResolvers(
  (category) => switch (category) {
    #int => context.colors.blueprint.int,
    #float => context.colors.blueprint.float,
    #vector => context.colors.blueprint.vector,
    #geometry => context.colors.blueprint.geometry,
    #math => context.colors.blueprint.math,
    #value => context.colors.blueprint.math,
    _ => null,
  },
);

Map<String, List<BlueprintNodeFactory>> blueprintGeneratorIONodeFactories(BuildContext context) => {
  'I/O': [
    .new(name: 'Merge', create: () => MergeNode()),
  ],
};

Map<String, List<BlueprintNodeFactory>> blueprintShaderIONodeFactories(BuildContext context) => {};

Map<String, List<BlueprintNodeFactory>> blueprintPrimitivesNodeFactories(BuildContext context) => {
  'Primitives': [
    .new(name: 'Vertex', create: () => VertexNode()),
    .new(name: 'Rectangle', create: () => RectangleNode()),
  ],
};

Map<String, List<BlueprintNodeFactory>> blueprintGeometryNodeFactories(BuildContext context) => {
  'Geometry': [
    .new(name: 'Array', create: () => ArrayNode()),
    .new(name: 'Transform', create: () => TransformNode()),
    .new(name: 'Connect Vertices', create: () => ConnectVerticesNode()),
    .new(name: 'Make Face', create: () => MakeFaceNode()),
  ],
};

Map<String, List<BlueprintNodeFactory>> blueprintQueryNodeFactories(BuildContext context) => {
  'Query': [
    .new(name: 'Bounding Box', create: () => BoundingBoxNode()),
  ],
};

Map<String, List<BlueprintNodeFactory>> blueprintFieldNodeFactories(BuildContext context) => {
  'Field': [
    .new(name: 'Index', create: () => IndexNode()),
  ],
};

Map<String, List<BlueprintNodeFactory>> blueprintMathNodeFactories(BuildContext context) => {
  'Math': [
    .new(name: 'Math', create: () => MathNode()),
    .new(name: 'Vector Math', create: () => VectorMathNode()),
    .new(name: 'Trig Math', create: () => TrigMathNode()),
    .new(name: 'Expression', create: () => ExpressionNode()),
    .new(name: 'Constant', create: () => MathConstantNode()),
    .new(name: 'Round', create: () => MathRoundNode()),
    .new(name: 'Combine XY', create: () => CombineXYNode()),
    .new(name: 'Separate XY', create: () => SeparateXYNode()),
    .new(name: 'Polar', create: () => PolarNode()),
    .new(name: 'Abs', create: () => AbsNode()),
    .new(name: 'Abs Vector', create: () => AbsVectorNode()),
    .new(name: 'Wrap', create: () => WrapNode()),
    .new(name: 'Wrap Vector', create: () => WrapVectorNode()),
    .new(name: 'Sign', create: () => SignNode()),
    .new(name: 'Sign Vector', create: () => SignVectorNode()),
    .new(name: 'Vector Magnitude', create: () => VectorMagnitudeNode()),
    .new(name: 'Rotate Vector', create: () => RotateVectorNode()),
    .new(name: 'Random Float', create: () => RandomFloatNode()),
    .new(name: 'Random Vector', create: () => RandomVectorNode()),
    .new(name: 'Compare', create: () => CompareNode()),
    .new(name: 'Boolean to Float', create: () => BooleanToFloatNode()),
    .new(name: 'Map Range', create: () => MapRangeNode()),
    .new(name: 'Degrees to Radians', create: () => Deg2RadNode()),
    .new(name: 'Radians to Degrees', create: () => Rad2DegNode()),
  ],
};

Map<String, List<BlueprintNodeFactory>> blueprintColorNodeFactories(BuildContext context) => {
  'Color': [
    .new(name: 'From RGBA', create: () => ColorFromRGBANode()),
    .new(name: 'To RGBA', create: () => ColorToRGBANode()),
    .new(name: 'Mix', create: () => ColorMixNode()),
  ],
};

class IntegerSocketValueBuilder extends BlueprintSocketValueBuilder<int> {
  @override
  Widget build(
    BuildContext context,
    InputSocket<int> socket,
    ReadonlySignal<Object?> value,
    void Function(int value)? onChanged,
  ) {
    return IntInputField(
      value: useComputed(() => value() as int?),
      onChanged: (v) => onChanged?.call(v),
    );
  }
}

class BoolSocketValueBuilder extends BlueprintSocketValueBuilder<bool> {
  @override
  bool get isInline => true;

  @override
  Widget build(
    BuildContext context,
    InputSocket<bool> socket,
    ReadonlySignal<Object?> value,
    void Function(bool value)? onChanged,
  ) {
    return Checkbox(
      value: useComputed(() => value() as bool? ?? false),
      onChanged: (v) => onChanged?.call(v),
    );
  }
}

class DoubleSocketValueBuilder extends BlueprintSocketValueBuilder<double> {
  @override
  Widget build(
    BuildContext context,
    InputSocket<double> socket,
    ReadonlySignal<Object?> value,
    void Function(double value)? onChanged,
  ) {
    return DoubleInputField(
      value: useComputed(() => value() as double?),
      onChanged: (v) => onChanged?.call(v),
    );
  }
}

class StringValueBuilder extends BlueprintSocketValueBuilder<String> {
  @override
  Widget build(
    BuildContext context,
    InputSocket<String> socket,
    ReadonlySignal<Object?> value,
    void Function(String value)? onChanged,
  ) {
    return TextInputField(
      value: useComputed(() => value() as String?),
      onChanged: (v) => onChanged?.call(v),
      options: .new(),
    );
  }
}

class Vector22SocketValueBuilder extends BlueprintSocketValueBuilder<Vec2> {
  @override
  Widget build(
    BuildContext context,
    InputSocket<Vec2> socket,
    ReadonlySignal<Object?> value,
    void Function(Vec2 value)? onChanged,
  ) {
    final _value = useComputed<Vec2>(() => (value() as Vec2?) ?? .zero());

    return Column(
      children: [
        DoubleInputField(
          value: useComputed(() => _value().x),
          onChanged: (v) => onChanged?.call(.new(v, _value().y)),
          options: .new(leading: Icons.x()),
        ),
        const SizedBox(height: 4.0),
        DoubleInputField(
          value: useComputed(() => _value().y),
          onChanged: (v) => onChanged?.call(.new(_value().x, v)),
          options: .new(leading: Icons.y()),
        ),
      ],
    );
  }
}
