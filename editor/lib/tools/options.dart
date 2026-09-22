import 'package:editor/imports.dart';

final class TopologicalToolOption extends ToolOption<bool> {
  TopologicalToolOption({bool? value}) : super('topological', value ?? true);

  static final entry = TopologicalToolOption();

  @override
  TopologicalToolOption copyWith({bool? value}) => .new(value: value);

  @override
  Widget performBuild(BuildContext context, ReadonlySignal<bool> value, ValueChanged<bool> onChanged) {
    return CheckboxListItem(
      title: Text('Topological'),
      value: value,
      onChanged: onChanged,
    );
  }
}

final class DestructiveToolOption extends ToolOption<bool> {
  DestructiveToolOption({bool? value}) : super('destructive', value ?? true);

  static final entry = DestructiveToolOption();

  @override
  DestructiveToolOption copyWith({bool? value}) => .new(value: value);

  @override
  Widget performBuild(BuildContext context, ReadonlySignal<bool> value, ValueChanged<bool> onChanged) {
    return CheckboxListItem(
      title: Text('Destructive'),
      value: value,
      onChanged: onChanged,
    );
  }
}

final class EdgeStyleToolOption extends ToolOption<EdgeStyle> {
  EdgeStyleToolOption({EdgeStyle? value}) : super('edgeStyle', value ?? .default_);

  static final entry = EdgeStyleToolOption();

  @override
  EdgeStyleToolOption copyWith({EdgeStyle? value}) => .new(value: value);

  @override
  Widget performBuild(BuildContext context, ReadonlySignal<EdgeStyle> value, ValueChanged<EdgeStyle> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8.0,
        crossAxisAlignment: .start,
        children: [
          Text('Stroke', style: context.typography.body.secondary),
          ColorField(
            value: useMemoComputed(() => value().color.partial),
            onChanged: (v) => onChanged(value().copyWith(color: v.apply(value().color))),
          ),
          DoubleExpressionInputField(
            value: useMemoComputed(() => value().width),
            onChanged: (v) => onChanged(value().copyWith(width: v)),
            options: .new(leading: Icons.weight()),
          ),
        ],
      ),
    );
  }
}
