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
      colorResolvers: .new(
        (category) => switch (category) {
          #int => context.colors.blueprint.int,
          #float => context.colors.blueprint.float,
          #vector => context.colors.blueprint.vector,
          #geometry => context.colors.blueprint.geometry,
          #math => context.colors.blueprint.math,
          _ => null,
        },
      ),
      socketValueBuilders: [
        _Angle2SocketValueBuilder(),
        _Vector22SocketValueBuilder(),
      ],
    );
  }
}

class _Angle2SocketValueBuilder extends BlueprintSocketValueBuilder<Angle2> {
  @override
  Widget build(
    BuildContext context,
    InputSocket<Angle2> socket,
    ReadonlySignal<Object?> value,
    void Function(Angle2 value)? onChanged,
  ) {
    return DoubleExpressionInputField(
      value: useComputed(() => (value() as Angle2?)?.valueDegrees),
      onChanged: (v) => onChanged?.call(.degrees(v)),
      options: .new(
        leading: Icons.angle(),
        trailing: Text('°'),
      ),
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
