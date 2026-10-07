import 'package:editor/imports.dart';

final class TopologicalToolOption extends ToolOption<bool> {
  TopologicalToolOption({bool? value}) : super('topological', value ?? true);

  static final entry = TopologicalToolOption();

  @override
  BooleanProp createProp(ToolController controller) => .new([
    .new(
      kind: .boolean,
      getter: () => controller.get(key),
      setter: (txn, p) => controller.set(key, p),
      signal: .new(controller.get(key)),
    ),
  ], label: 'Topological');

  @override
  TopologicalToolOption copyWith({bool? value}) => .new(value: value);
}

final class DestructiveToolOption extends ToolOption<bool> {
  DestructiveToolOption({bool? value}) : super('destructive', value ?? true);

  static final entry = DestructiveToolOption();

  @override
  BooleanProp createProp(ToolController controller) => .new([
    .new(
      kind: .boolean,
      getter: () => controller.get(key),
      setter: (txn, p) => controller.set(key, p),
      signal: .new(controller.get(key)),
    ),
  ], label: 'Destructive');

  @override
  DestructiveToolOption copyWith({bool? value}) => .new(value: value);
}

final class SnapToPixelToolOption extends ToolOption<bool> {
  SnapToPixelToolOption({bool? value}) : super('snapToPixel', value ?? true);

  static final entry = SnapToPixelToolOption();

  @override
  BooleanProp createProp(ToolController controller) => .new([
    .new(
      kind: .boolean,
      getter: () => controller.get(key),
      setter: (txn, p) => controller.set(key, p),
      signal: .new(controller.get(key)),
    ),
  ], label: 'Snap to Pixel');

  @override
  SnapToPixelToolOption copyWith({bool? value}) => .new(value: value);
}

abstract class EdgeStyleToolOption extends ToolOption<EdgeStyle> {
  EdgeStyleToolOption(super.id, super.value);

  String? get decorationsEmptyStateLabel;

  @override
  EdgeStyleProp createProp(ToolController controller) => .new([
    .new(
      kind: .edgeStyle,
      getter: () => controller.get(key),
      setter: (txn, p) => controller.set(key, p.apply(controller.get(key))),
      signal: .new(controller.get(key)),
    ),
  ], decorationsEmptyStateLabel: decorationsEmptyStateLabel);
}

final class PenEdgeStyleToolOption extends EdgeStyleToolOption {
  PenEdgeStyleToolOption({EdgeStyle? value}) : super('penEdgeStyle', value ?? .new(width: 1.0, decorations: .none));

  static final entry = PenEdgeStyleToolOption();

  @override
  String? get decorationsEmptyStateLabel =>
      'Tap on + to add decorations. If empty, the color will be resolved automatically.';

  @override
  PenEdgeStyleToolOption copyWith({EdgeStyle? value}) => .new(value: value);
}

final class ShapeEdgeStyleToolOption extends EdgeStyleToolOption {
  ShapeEdgeStyleToolOption({EdgeStyle? value}) : super('shapeEdgeStyle', value ?? .none);

  static final entry = ShapeEdgeStyleToolOption();

  @override
  String? get decorationsEmptyStateLabel => null;

  @override
  ShapeEdgeStyleToolOption copyWith({EdgeStyle? value}) => .new(value: value);
}

final class FaceStyleToolOption extends ToolOption<FaceStyle> {
  FaceStyleToolOption({FaceStyle? value}) : super('faceStyle', value ?? .none);

  static final entry = FaceStyleToolOption();

  @override
  FaceStyleProp createProp(ToolController controller) => .new([
    .new(
      kind: .faceStyle,
      getter: () => controller.get(key),
      setter: (txn, p) => controller.set(key, p.apply(controller.get(key))),
      signal: .new(controller.get(key)),
    ),
  ], decorationsEmptyStateLabel: 'Tap on + to add decorations. If empty, the color will be resolved automatically.');

  @override
  FaceStyleToolOption copyWith({FaceStyle? value}) => .new(value: value);
}
