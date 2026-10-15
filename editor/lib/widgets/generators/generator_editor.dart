import 'package:blueprint/editor.dart';
import 'package:geometry/geometry.dart';
import 'package:program/program.dart';
import 'package:ui/ui.dart';

class GeneratorEditor extends HookWidget {
  const GeneratorEditor({
    super.key,
    required this.editor,
  });

  final BlueprintEditor<Generator> editor;

  @override
  Widget build(BuildContext context) {
    return BlueprintEditorWidget(
      editor: editor,
      nodeFactories: {
        'I/O': [
          .new(name: 'Merge', create: () => MergeNode()),
        ],
        'Primitives': [
          .new(name: 'Vertex', create: () => VertexNode()),
          .new(name: 'Rectangle', create: () => RectangleNode()),
        ],
        'Geometry': [
          .new(name: 'Array', create: () => ArrayNode()),
          .new(name: 'Transform', create: () => TransformNode()),
          .new(name: 'Connect Vertices', create: () => ConnectVerticesNode()),
          .new(name: 'Make Face', create: () => MakeFaceNode()),
        ],
        'Query': [
          .new(name: 'Bounding Box', create: () => BoundingBoxNode()),
        ],
        'Field': [
          .new(name: 'Index', create: () => IndexNode()),
        ],
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
          .new(name: 'Random Float', create: () => RandomFloatNode()),
          .new(name: 'Random Vector', create: () => RandomVectorNode()),
          // .new(name: 'Number', create: () => NumberNode()),
          // .new(name: 'Vector', create: () => VectorNode()),
        ],
        // 'Geometry': [
        //   .new(name: 'Vertices', create: () => VerticesNode()),
        //   .new(name: 'Connect vertices', create: () => ConnectVerticesNode()),
        //   .new(name: 'Face', create: () => FaceNode()),
        // ],
        // 'Random': [
        //   .new(name: 'Random vector', create: () => RandomVectorNode()),
        // ],
        // 'Modifications': [
        //   .new(name: 'Array', create: () => ArrayNode()),
        //   .new(name: 'Fillet', create: () => FilletNode()),
        // ],
        // 'Transform': [
        //   .new(name: 'Scale vector', create: () => ScaleVectorNode()),
        // ],
        // 'Utilities': [
        //   .new(name: 'Index', create: () => IndexNode()),
        // ],
      },
      colorResolvers: .new(
        (category) => switch (category) {
          #int => context.colors.blueprint.int,
          #float => context.colors.blueprint.float,
          #vector => context.colors.blueprint.vector,
          #geometry => context.colors.blueprint.geometry,
          #math => context.colors.blueprint.math,
          #value => context.colors.blueprint.math,
          _ => null,
        },
      ),
      socketValueBuilders: [
        _BoolSocketValueBuilder(),
        _IntegerSocketValueBuilder(),
        _DoubleSocketValueBuilder(),
        _Vector22SocketValueBuilder(),
        _StringValueBuilder(),
      ],
      enums: .new({
        MathOperatorType: MathOperatorType.values,
        VectorMathOperatorType: VectorMathOperatorType.values,
        MathConstantType: MathConstantType.values,
        MathRoundType: MathRoundType.values,
      }),
    );
  }
}

class _IntegerSocketValueBuilder extends BlueprintSocketValueBuilder<int> {
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

class _BoolSocketValueBuilder extends BlueprintSocketValueBuilder<bool> {
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

class _DoubleSocketValueBuilder extends BlueprintSocketValueBuilder<double> {
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

class _StringValueBuilder extends BlueprintSocketValueBuilder<String> {
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

class _Vector22SocketValueBuilder extends BlueprintSocketValueBuilder<Vec2> {
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
