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
  final PositionProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Position';

  @override
  Widget build(BuildContext context) {
    final xProp = usePropComputed(scene, prop.x);
    final yProp = usePropComputed(scene, prop.y);

    final xValue = useMemoComputed(() => xProp.value()?.value, keys: [xProp]);
    final yValue = useMemoComputed(() => yProp.value()?.value, keys: [yProp]);

    final isXOverriden = useComputed(() => xProp.value()?.overriden != null, keys: [xProp]).value;
    final isYOverriden = useComputed(() => yProp.value()?.overriden != null, keys: [yProp]).value;

    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: xValue,
            onChanged: (v) => scene.edit((txn) => prop.x.set(txn, v)),
            options: .new(
              leading: Icons.x(),
              textStyle: isXOverriden ? context.typography.body.tertiary : null,
              hintText: 'Mixed',
            ),
          ),
        ),
        Expanded(
          child: DoubleExpressionInputField(
            value: yValue,
            onChanged: (v) => scene.edit((txn) => prop.y.set(txn, v)),
            options: .new(
              leading: Icons.y(),
              textStyle: isYOverriden ? context.typography.body.tertiary : null,
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
  final RotationProp prop;

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
  final EdgeStyleProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Stroke';

  @override
  Widget build(BuildContext context) {
    final width = usePropComputed(scene, prop.width);
    final color = usePropComputed(scene, prop.color);

    return Column(
      spacing: 8.0,
      children: [
        ColorField(
          value: useMemoComputed(() => color.value(), keys: [color]),
          onChanged: (color) => scene.edit((txn) => prop.color.set(txn, color)),
          options: .new(hintText: 'Mixed'),
        ),
        DoubleExpressionInputField(
          value: useMemoComputed(() => width.value(), keys: [width]),
          onChanged: (width) => scene.edit((txn) => prop.width.set(txn, width)),
          options: .new(
            leading: Icons.weight(),
            hintText: 'Mixed',
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
  final FaceStyleProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Fill';

  @override
  Widget build(BuildContext context) {
    final color = usePropComputed(scene, prop.color);

    return ColorField(
      value: useMemoComputed(() => color.value(), keys: [color]),
      onChanged: (color) => scene.edit((txn) => prop.color.set(txn, color)),
      options: .new(hintText: 'Mixed'),
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
  final TransformProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Transform';

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: [
        PositionPropWidget(
          scene: scene,
          prop: prop.translation,
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
  final ChildLayoutProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Children';

  @override
  Widget build(BuildContext context) {
    final prop = usePropComputed(scene, this.prop);
    final layout = useComputed(() => prop.value(), keys: [prop]).value;

    return ToggleableButtonRow(
      children: [
        ToggleableButton(
          onChanged: (v) => scene.edit((txn) => this.prop.set(txn, .stack())),
          isActive: layout is StackChildLayout,
          child: Icons.layoutStack(),
        ),
        ToggleableButton(
          onChanged: (v) => scene.edit((txn) => this.prop.set(txn, .flex(direction: .row))),
          isActive: layout is FlexChildLayout && layout.direction == .row,
          child: Icons.layoutRow(),
        ),
        ToggleableButton(
          onChanged: (v) => scene.edit((txn) => this.prop.set(txn, .flex(direction: .column))),
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
  final LayoutSizeProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Size';

  @override
  Widget build(BuildContext context) {
    final width = usePropComputed(scene, prop.width);
    final height = usePropComputed(scene, prop.height);

    final isWidthFixed = useComputed(() => width.value()?.dimension.isFixed ?? true, keys: [width]).value;
    final isHeightFixed = useComputed(() => height.value()?.dimension.isFixed ?? true, keys: [height]).value;

    final widthValue = useMemoComputed(() {
      final w = width.value();
      if (w?.overriden != null) return w?.overriden!;
      if (w?.dimension.isFixed == true) return w?.dimension.value;
      return null;
    }, keys: [width]);

    final heightValue = useMemoComputed(() {
      final h = height.value();
      if (h?.overriden != null) return h?.overriden!;
      if (h?.dimension.isFixed == true) return h?.dimension.value;
      return null;
    }, keys: [height]);

    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: widthValue,
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
            value: heightValue,
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
