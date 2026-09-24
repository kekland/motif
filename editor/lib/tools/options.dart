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

final class SnapToPixelToolOption extends ToolOption<bool> {
  SnapToPixelToolOption({bool? value}) : super('snapToPixel', value ?? true);

  static final entry = SnapToPixelToolOption();

  @override
  SnapToPixelToolOption copyWith({bool? value}) => .new(value: value);

  @override
  Widget performBuild(BuildContext context, ReadonlySignal<bool> value, ValueChanged<bool> onChanged) {
    return CheckboxListItem(
      title: Text('Snap to pixel grid'),
      value: value,
      onChanged: onChanged,
    );
  }
}

abstract class EdgeStyleToolOption extends ToolOption<EdgeStyle> {
  EdgeStyleToolOption(super.id, super.value);

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

final class PenEdgeStyleToolOption extends EdgeStyleToolOption {
  PenEdgeStyleToolOption({EdgeStyle? value}) : super('penEdgeStyle', value ?? .default_);

  static final entry = PenEdgeStyleToolOption();

  @override
  PenEdgeStyleToolOption copyWith({EdgeStyle? value}) => .new(value: value);
}

final class ShapeEdgeStyleToolOption extends EdgeStyleToolOption {
  ShapeEdgeStyleToolOption({EdgeStyle? value}) : super('shapeEdgeStyle', value ?? .new(width: 0.0, color: .white));

  static final entry = ShapeEdgeStyleToolOption();

  @override
  ShapeEdgeStyleToolOption copyWith({EdgeStyle? value}) => .new(value: value);
}

final class FaceStyleToolOption extends ToolOption<FaceStyle> {
  FaceStyleToolOption({FaceStyle? value}) : super('faceStyle', value ?? .default_);

  static final entry = FaceStyleToolOption();

  @override
  FaceStyleToolOption copyWith({FaceStyle? value}) => .new(value: value);

  @override
  Widget performBuild(BuildContext context, ReadonlySignal<FaceStyle> value, ValueChanged<FaceStyle> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8.0,
        crossAxisAlignment: .start,
        children: [
          Text('Fill', style: context.typography.body.secondary),
          ColorField(
            value: useMemoComputed(() => value().color.partial),
            onChanged: (v) => onChanged(value().copyWith(color: v.apply(value().color))),
          ),
        ],
      ),
    );
  }
}
