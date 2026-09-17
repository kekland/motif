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
      nodeFactories: [
        .new(name: 'Array', create: () => ArrayNode()),
        .new(name: 'Fillet', create: () => FilletNode()),
        .new(name: 'Vertices', create: () => VerticesNode()),
        .new(name: 'Random vector', create: () => RandomVectorNode()),
        .new(name: 'Connect vertices', create: () => ConnectVerticesNode()),
        .new(name: 'Number', create: () => NumberNode()),
        .new(name: 'Vector', create: () => VectorNode()),
        .new(name: 'Scale vector', create: () => ScaleVectorNode()),
        .new(name: 'Index', create: () => IndexNode()),
        .new(name: 'Face', create: () => FaceNode()),
        .new(name: 'Polar', create: () => PolarNode()),
        .new(name: 'Pi', create: () => PiNode()),
        .new(name: 'Divide', create: () => DivideNode()),
      ],
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
      ],
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
    return IntExpressionInputField(
      value: useComputed(() => value() as int?),
      onChanged: (v) => onChanged?.call(v),
    );
  }
}

class _BoolSocketValueBuilder extends BlueprintSocketValueBuilder<bool> {
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
    return DoubleExpressionInputField(
      value: useComputed(() => value() as double?),
      onChanged: (v) => onChanged?.call(v),
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
        DoubleExpressionInputField(
          value: useComputed(() => _value().x),
          onChanged: (v) => onChanged?.call(.new(v, _value().y)),
          options: .new(leading: Icons.x()),
        ),
        const SizedBox(height: 4.0),
        DoubleExpressionInputField(
          value: useComputed(() => _value().y),
          onChanged: (v) => onChanged?.call(.new(_value().x, v)),
          options: .new(leading: Icons.y()),
        ),
      ],
    );
  }
}
