import 'package:editor/imports.dart';

final class TopologicalToolOption extends ToolOption<bool> {
  TopologicalToolOption({bool? value}) : super('topological', value ?? true);

  static final entry = TopologicalToolOption();

  @override
  BooleanProp createProp(ToolController controller) => .new(
    [
      .new(
        kind: .boolean,
        getter: () => controller.get(key),
        setter: (txn, p) => controller.set(key, p),
        signal: .new(controller.get(key)),
      ),
    ],
    label: 'Topological',
    tooltip: .new('Whether intersections with existing geometry will be resolved'),
  );

  @override
  TopologicalToolOption copyWith({bool? value}) => .new(value: value);
}

final class DestructiveToolOption extends ToolOption<bool> {
  DestructiveToolOption({bool? value}) : super('destructive', value ?? true);

  static final entry = DestructiveToolOption();

  @override
  BooleanProp createProp(ToolController controller) => .new(
    [
      .new(
        kind: .boolean,
        getter: () => controller.get(key),
        setter: (txn, p) => controller.set(key, p),
        signal: .new(controller.get(key)),
      ),
    ],
    label: 'Destructive',
    tooltip: .new(
      'Whether intersections with existing geometry will be destructive (i.e. original geometry is modified)',
    ),
  );

  @override
  DestructiveToolOption copyWith({bool? value}) => .new(value: value);
}

final class SnapToPixelToolOption extends ToolOption<bool> {
  SnapToPixelToolOption({bool? value}) : super('snapToPixel', value ?? true);

  static final entry = SnapToPixelToolOption();

  @override
  BooleanProp createProp(ToolController controller) => .new(
    [
      .new(
        kind: .boolean,
        getter: () => controller.get(key),
        setter: (txn, p) => controller.set(key, p),
        signal: .new(controller.get(key)),
      ),
    ],
    label: 'Snap to Pixel',
    tooltip: .new('Whether the geometry will snap to the pixel grid'),
  );

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

  EdgeStyle resolve(Scene scene, Vec2 position) {
    if (value.decorations.isNotEmpty) return value;
    return value.copyWith(decorations: _resolveAutoDecoration(scene, position));
  }

  @override
  PenEdgeStyleToolOption copyWith({EdgeStyle? value}) => .new(value: value);
}

final class ShapeEdgeStyleToolOption extends EdgeStyleToolOption {
  ShapeEdgeStyleToolOption({EdgeStyle? value}) : super('shapeEdgeStyle', value ?? .none);

  static final entry = ShapeEdgeStyleToolOption();

  @override
  String? get decorationsEmptyStateLabel => null;

  EdgeStyle resolve(Scene scene, Vec2 position) => value;

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

  FaceStyle resolve(Scene scene, Vec2 position) {
    if (value.decorations.isNotEmpty) return value;
    return .new(decorations: _resolveAutoDecoration(scene, position));
  }

  @override
  FaceStyleToolOption copyWith({FaceStyle? value}) => .new(value: value);
}

Decorations _resolveAutoDecoration(Scene scene, Vec2 position) {
  final (color, isBackground) = scene.query.colorAt(position);
  final luminance = color.computeLuminance();

  if (isBackground) {
    if (luminance > 0.5) return .color(.black);
    return .color(.white);
  }

  if (luminance > 0.5) return .color(color.darken(0.6));
  return .color(color.lighten(0.6));
}
