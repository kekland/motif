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
    final xTxn = usePropTransaction(scene, [prop]);
    final yTxn = usePropTransaction(scene, [prop]);

    final xProp = usePropComputed(scene, prop.x);
    final yProp = usePropComputed(scene, prop.y);

    final xValue = useMemoComputed(() => xProp.value.get()?.resolved, keys: [xProp]);
    final yValue = useMemoComputed(() => yProp.value.get()?.resolved, keys: [yProp]);

    final isXOverriden = useComputed(() => xProp.value.get()?.overridden != null, keys: [xProp]).value;
    final isYOverriden = useComputed(() => yProp.value.get()?.overridden != null, keys: [yProp]).value;

    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: xValue,
            onChanged: (v) => xTxn.edit((txn) => prop.x.set(txn, .new(v))),
            onStartChanging: xTxn.onStartChanging,
            onEndChanging: xTxn.onEndChanging,
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
            onChanged: (v) => yTxn.edit((txn) => prop.y.set(txn, .new(v))),
            onStartChanging: yTxn.onStartChanging,
            onEndChanging: yTxn.onEndChanging,
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
    final txn = usePropTransaction(scene, [prop]);

    final rotation = usePropComputed(scene, prop);
    final value = useMemoComputed(() {
      final value = rotation.value.get();
      if (value == null) return null;
      return value * rad2Deg;
    }, keys: [rotation]);

    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: DoubleExpressionInputField(
            value: value,
            onChanged: (v) => txn.edit((txn) => prop.set(txn, v * deg2Rad)),
            onStartChanging: txn.onStartChanging,
            onEndChanging: txn.onEndChanging,
            options: .new(
              leading: Icons.angle(),
              hintText: 'Mixed',
            ),
          ),
        ),
        IconButton(
          onTap: () => txn.edit((txn) => prop.alter(txn, (r) => r + (pi / 2))),
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
    final colorTxn = usePropTransaction(scene, [prop.color]);
    final widthTxn = usePropTransaction(scene, [prop.width]);

    final color = usePropComputed(scene, prop.color);
    final width = usePropComputed(scene, prop.width);

    return Column(
      spacing: 8.0,
      children: [
        ColorField(
          value: useMemoComputed(() => color.value.get() ?? .mixed, keys: [color]),
          onChanged: (color) => colorTxn.edit((txn) => prop.color.set(txn, color)),
          onStartChanging: colorTxn.onStartChanging,
          onEndChanging: colorTxn.onEndChanging,
          options: .new(hintText: 'Mixed'),
        ),
        DoubleExpressionInputField(
          value: useMemoComputed(() => width.value.get(), keys: [width]),
          onChanged: (width) => widthTxn.edit((txn) => prop.width.set(txn, width)),
          onStartChanging: widthTxn.onStartChanging,
          onEndChanging: widthTxn.onEndChanging,
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
    final colorTxn = usePropTransaction(scene, [prop.color]);
    final color = usePropComputed(scene, prop.color);

    return ColorField(
      value: useMemoComputed(() => color.value.get() ?? .mixed, keys: [color]),
      onChanged: (color) => colorTxn.edit((txn) => prop.color.set(txn, color)),
      onStartChanging: colorTxn.onStartChanging,
      onEndChanging: colorTxn.onEndChanging,
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

class LayoutPropWidget extends PropWidget {
  const new({
    super.key,
    required this.scene,
    required this.prop,
  });

  final Scene scene;
  final LayoutProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Layout';

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction(scene, [this.prop]);
    final prop = usePropComputed(scene, this.prop);
    final layout = useComputed(() => prop.value.get(), keys: [prop]).value;

    return ToggleableButtonRow(
      children: [
        ToggleableButton(
          onChanged: (v) => txn.edit((txn) => this.prop.set(txn, .stack())),
          isActive: layout is StackLayout,
          child: Icons.layoutStack(),
        ),
        ToggleableButton(
          onChanged: (v) => txn.edit((txn) => this.prop.set(txn, .flex(direction: .row))),
          isActive: layout is FlexLayout && layout.direction == .row,
          child: Icons.layoutRow(),
        ),
        ToggleableButton(
          onChanged: (v) => txn.edit((txn) => this.prop.set(txn, .flex(direction: .column))),
          isActive: layout is FlexLayout && layout.direction == .column,
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
    final widthTxn = usePropTransaction(scene, [prop.width]);
    final heightTxn = usePropTransaction(scene, [prop.height]);

    final width = usePropComputed(scene, prop.width);
    final height = usePropComputed(scene, prop.height);

    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: LayoutDimensionInputField(
            value: width,
            onChanged: (v) => widthTxn.edit((txn) => prop.set(txn, .new(width: v))),
            onStartChanging: widthTxn.onStartChanging,
            onEndChanging: widthTxn.onEndChanging,
            isWidth: true,
          ),
        ),
        Expanded(
          child: LayoutDimensionInputField(
            value: height,
            onChanged: (v) => heightTxn.edit((txn) => prop.set(txn, .new(height: v))),
            onStartChanging: heightTxn.onStartChanging,
            onEndChanging: heightTxn.onEndChanging,
            isWidth: false,
          ),
        ),
      ],
    );
  }
}

class LayoutDimensionInputField extends HookWidget {
  const new({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isWidth,
    this.onStartChanging,
    this.onEndChanging,
  });

  final bool isWidth;
  final ReadonlySignal<PropValue<ResolvedLayoutDimension?>> value;
  final ValueChanged<LayoutDimension> onChanged;
  final VoidCallback? onStartChanging;
  final VoidCallback? onEndChanging;

  @override
  Widget build(BuildContext context) {
    final value = useMemoComputed(() {
      final v = this.value().get();
      if (v?.overridden != null) return v?.overridden!;
      if (v?.dimension.isFixed == true) return v?.dimension.value;
      return null;
    }, keys: [this.value]);

    final type = useComputed(() => this.value().get()?.dimension.type, keys: [this.value]).value;
    final isOverridden = type == null || type != .fixed;
    final turns = isWidth ? 0 : 1;

    return DoubleExpressionInputField(
      value: value,
      onChanged: (v) => onChanged(.fixed(v)),
      onStartChanging: onStartChanging,
      onEndChanging: onEndChanging,
      options: .new(
        leading: isWidth ? Icons.w() : Icons.h(),
        textStyle: isOverridden ? context.typography.body.tertiary : null,
        hintText: 'Mixed',
        padding: .zero,
        builder: (context, child) => Column(
          children: [
            Padding(
              padding: .symmetric(horizontal: 6.0),
              child: child,
            ),
            Divider(),
            ToggleableButtonRow(
              borderRadius: .vertical(bottom: .circular(4.0)),
              height: 28.0,
              children: [
                ToggleableButton(
                  isActive: type == .fixed,
                  onChanged: (v) => onChanged(.fixed(value.get() ?? 0.0)),
                  iconSize: 16.0,
                  child: type == .fixed ? Icons.layoutSizeFixed() : Icons.layoutSizeNonFixed(),
                ),
                ToggleableButton(
                  isActive: type == .contain,
                  onChanged: (v) => onChanged(.contain()),
                  iconSize: 16.0,
                  child: RotatedBox(quarterTurns: turns + 1, child: Icons.layoutSizeContain()),
                ),
                ToggleableButton(
                  isActive: type == .expand,
                  onChanged: (v) => onChanged(.expand()),
                  iconSize: 16.0,
                  child: RotatedBox(quarterTurns: turns + 1, child: Icons.layoutSizeExpand()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
