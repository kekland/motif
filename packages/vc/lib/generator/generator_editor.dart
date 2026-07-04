// ignore_for_file: prefer_function_declarations_over_variables

import 'package:blueprint/core/core.dart';
import 'package:blueprint/widgets.dart';
import 'package:geometry/geometry.dart';
import 'package:ui/ui.dart';
import 'package:vc/vc.dart';
import 'package:vc/widgets.dart';

class GeneratorEditor extends HookWidget {
  const GeneratorEditor({
    super.key,
    required this.vectorComplexContext,
    required this.generator,
  });

  final Generator generator;
  final VectorComplexContext vectorComplexContext;

  @override
  Widget build(BuildContext context) {
    final controller = useDisposable(() => GeneratorBlueprintController(generator));

    return BlueprintEditor(
      controller: controller,
      socketValueBuilders: [
        _SymbolIdSocketValueBuilder(vectorComplexContext: vectorComplexContext),
        _Angle2SocketValueBuilder(),
        _Vector22SocketValueBuilder(),
      ],
    );
  }
}

class _SymbolIdSocketValueBuilder extends BlueprintSocketValueBuilder<SymbolId?> {
  _SymbolIdSocketValueBuilder({required this.vectorComplexContext});

  final VectorComplexContext vectorComplexContext;

  Future<SymbolId?> _selectSymbol(BuildContext context) async {
    final symbol = await WindowNavigator.pushUnique(
      context,
      SymbolSelectWindow.createEntry(context, vectorComplexContext: vectorComplexContext),
    );

    return symbol?.id;
  }

  @override
  Widget build(
    BuildContext context,
    InputSocket<SymbolId?> socket,
    SymbolId? value,
    void Function(SymbolId? value)? onChanged,
  ) {
    if (value == null) {
      return Button(
        onTap: () async {
          final symbol = await _selectSymbol(context);
          if (symbol == null) return;
          onChanged?.call(symbol);
        },
        leading: Icons.symbols(),
        child: Text('Select'),
      );
    }

    return Row(
      children: [
        Text(value),
        IconButton(
          onTap: () async {
            final symbol = await _selectSymbol(context);
            onChanged?.call(symbol);
          },
          child: Icons.close(),
        ),
      ],
    );
  }
}

class _Angle2SocketValueBuilder extends BlueprintSocketValueBuilder<Angle2> {
  @override
  Widget build(
    BuildContext context,
    InputSocket<Angle2> socket,
    Angle2? value,
    void Function(Angle2 value)? onChanged,
  ) {
    return DoubleExpressionInputField(
      value: value?.valueDegrees ?? 0.0,
      onChanged: (v) => onChanged?.call(.degrees(v)),
      options: .new(
        leading: Icons.angle(),
        trailing: Text('°'),
      ),
    );
  }
}

class _Vector22SocketValueBuilder extends BlueprintSocketValueBuilder<Vector2> {
  @override
  Widget build(
    BuildContext context,
    InputSocket<Vector2> socket,
    Vector2? value,
    void Function(Vector2 value)? onChanged,
  ) {
    final _value = value ?? .zero();

    return Column(
      children: [
        DoubleExpressionInputField(
          value: _value.x,
          options: .new(leading: Icons.x()),
        ),
        const SizedBox(height: 4.0),
        DoubleExpressionInputField(
          value: _value.y,
          options: .new(leading: Icons.y()),
        ),
      ],
    );
  }
}
