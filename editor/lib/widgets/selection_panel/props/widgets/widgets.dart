part of '../prop.dart';

abstract class PropWidget extends HookWidget {
  const PropWidget({super.key});

  String resolveHeader(BuildContext context);
}

class PositionPropWidget extends PropWidget {
  const new({
    super.key,
    required this.scene,
    required this.prop,
  });

  final Scene scene;
  final Prop<Vec2Partial> prop;

  @override
  String resolveHeader(BuildContext context) => 'Position';

  @override
  Widget build(BuildContext context) {
    final position = usePropComputed(scene, prop);
    final x = useMemoComputed(() => position.value()?.x, keys: [position]);
    final y = useMemoComputed(() => position.value()?.y, keys: [position]);

    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: x,
            onChanged: (v) => scene.edit((txn) => prop.set(txn, .new(x: v))),
            options: .new(
              leading: Icons.x(),
              // textStyle: overridePosition != null ? context.typography.body.tertiary : null,
              hintText: 'Mixed',
            ),
          ),
        ),
        Expanded(
          child: DoubleExpressionInputField(
            value: y,
            onChanged: (v) => scene.edit((txn) => prop.set(txn, .new(y: v))),
            options: .new(
              leading: Icons.y(),
              // textStyle: overridePosition != null ? context.typography.body.tertiary : null,
              hintText: 'Mixed',
            ),
          ),
        ),
      ],
    );
  }
}

final class RotationPropWidget extends PropWidget {
  const new({
    super.key,
    required this.scene,
    required this.prop,
  });

  final Scene scene;
  final Prop<double> prop;

  @override
  String resolveHeader(BuildContext context) => 'Rotation';

  @override
  Widget build(BuildContext context) {
    final rotation = usePropComputed(scene, prop);
    final value = useMemoComputed(() {
      final value = rotation.value();
      if (value == null) return null;
      return value * rad2Deg;
    }, keys: [rotation]);

    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: value,
            onChanged: (v) => scene.edit((txn) => prop.set(txn, v * deg2Rad)),
            options: .new(
              leading: Icons.angle(),
              hintText: 'Mixed',
            ),
          ),
        ),
        IconButton(
          onTap: () => scene.edit((txn) => prop.alter(txn, (r) => r + (pi / 2))),
          child: Icons.rotateCw(),
        ),
      ],
    );
  }
}

final class EdgeStylePropWidget extends PropWidget {
  const new({
    super.key,
    required this.scene,
    required this.prop,
  });

  final Scene scene;
  final Prop<EdgeStylePartial> prop;

  @override
  String resolveHeader(BuildContext context) => 'Stroke';

  @override
  Widget build(BuildContext context) {
    final style = usePropComputed(scene, prop);
    final width = useMemoComputed(() => style.value()?.width, keys: [style]);
    final color = useMemoComputed(() => style.value()?.color, keys: [style]);

    return Column(
      spacing: 8.0,
      children: [
        ColorField(
          value: color,
          onChanged: (color) => scene.edit((txn) => prop.set(txn, .new(color: color))),
        ),
        DoubleExpressionInputField(
          value: width,
          onChanged: (width) => scene.edit((txn) => prop.set(txn, .new(width: width))),
          options: .new(
            leading: Icons.weight(),
            hintText: '0',
          ),
        ),
      ],
    );
  }
}

final class FaceStylePropWidget extends PropWidget {
  const new({
    super.key,
    required this.scene,
    required this.prop,
  });

  final Scene scene;
  final Prop<FaceStylePartial> prop;

  @override
  String resolveHeader(BuildContext context) => 'Fill';

  @override
  Widget build(BuildContext context) {
    final style = usePropComputed(scene, prop);
    final color = useMemoComputed(() => style.value()?.color, keys: [style]);

    return ColorField(
      value: color,
      onChanged: (color) => scene.edit((txn) => prop.set(txn, .new(color: color))),
    );
  }
}

class TransformPropWidget extends PropWidget {
  const new({
    super.key,
    required this.scene,
    required this.prop,
  });

  final Scene scene;
  final Prop<Mat4> prop;

  @override
  String resolveHeader(BuildContext context) => 'Transform';

  @override
  Widget build(BuildContext context) {
    final prop = this.prop as TransformPropBase;

    return Column(
      spacing: 8.0,
      children: [
        PositionPropWidget(
          scene: scene,
          prop: prop.position,
        ),
        RotationPropWidget(
          scene: scene,
          prop: prop.rotation,
        ),
      ],
    );
  }
}

class ChildLayoutPropWidget extends PropWidget {
  const new({
    super.key,
    required this.scene,
    required this.prop,
  });

  final Scene scene;
  final Prop<ChildLayout> prop;

  @override
  String resolveHeader(BuildContext context) => 'Child Layout';

  @override
  Widget build(BuildContext context) {
    final value = usePropComputed(scene, prop);
    final layout = useComputed(() => value.value(), keys: [value]).value;

    return ToggleableButtonRow(
      children: [
        ToggleableButton(
          onChanged: (v) => scene.edit((txn) => prop.set(txn, .stack())),
          isActive: layout is StackChildLayout,
          child: Icons.layoutStack(),
        ),
        ToggleableButton(
          onChanged: (v) => scene.edit((txn) => prop.set(txn, .flex(direction: .row))),
          isActive: layout is FlexChildLayout && layout.direction == .row,
          child: Icons.layoutRow(),
        ),
        ToggleableButton(
          onChanged: (v) => scene.edit((txn) => prop.set(txn, .flex(direction: .column))),
          isActive: layout is FlexChildLayout && layout.direction == .column,
          child: Icons.layoutColumn(),
        ),
      ],
    );
  }
}

class LayoutSizePropWidget extends PropWidget {
  const new({
    super.key,
    required this.scene,
    required this.prop,
  });

  final Scene scene;
  final Prop<LayoutSizePartial> prop;

  @override
  String resolveHeader(BuildContext context) => 'Size';

  @override
  Widget build(BuildContext context) {
    final size = usePropComputed(scene, prop);
    final resolvedSize = useMemoComputed(() {
      scene.signal();
      return (prop as LayoutSizePropBase).resolvedSize(scene);
    });

    final layoutSize = useMemoComputed(() {
      final s = size.value;
      if (s.isMixed) return null;
      return s()!.unwrap.natural(resolvedSize() ?? .zero());
    }, keys: [size]);

    final width = useMemoComputed(() => layoutSize()?.width, keys: [layoutSize]);
    final height = useMemoComputed(() => layoutSize()?.height, keys: [layoutSize]);

    final isWidthFixed = useComputed(() => size.value()?.width?.isFixed ?? true).value;
    final isHeightFixed = useComputed(() => size.value()?.height?.isFixed ?? true).value;

    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: width,
            onChanged: (v) => scene.edit((txn) => prop.set(txn, .new(width: .fixed(v)))),
            options: .new(
              leading: Icons.w(),
              textStyle: isWidthFixed ? null : context.typography.body.tertiary,
              hintText: 'Mixed',
            ),
          ),
        ),
        Expanded(
          child: DoubleExpressionInputField(
            value: height,
            onChanged: (v) => scene.edit((txn) => prop.set(txn, .new(height: .fixed(v)))),
            options: .new(
              leading: Icons.h(),
              textStyle: isHeightFixed ? null : context.typography.body.tertiary,
              hintText: 'Mixed',
            ),
          ),
        ),
      ],
    );
  }
}
