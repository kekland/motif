import 'package:geometry/geometry.dart';
import 'package:scene/scene.dart';
import 'package:ui/ui.dart';

class SizeComponentWidget extends StatelessWidget {
  const SizeComponentWidget({
    super.key,
    required this.size,
    this.resolvedSize,
    this.onChanged,
  });

  final LayoutSize size;
  final Size2? resolvedSize;
  final ValueChanged<LayoutSize>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      children: [
        Expanded(
          child: _LayoutSizeDimensionWidget(
            isWidth: true,
            leading: Icons.w(),
            dimension: size.width,
            resolvedValue: resolvedSize?.width,
            onChanged: onChanged != null ? (d) => onChanged!(size.withWidth(d)) : null,
          ),
        ),
        Expanded(
          child: _LayoutSizeDimensionWidget(
            isWidth: false,
            leading: Icons.h(),
            dimension: size.height,
            resolvedValue: resolvedSize?.height,
            onChanged: onChanged != null ? (d) => onChanged!(size.withHeight(d)) : null,
          ),
        ),
      ],
    );
  }
}

class _LayoutSizeDimensionWidget extends StatelessWidget {
  const _LayoutSizeDimensionWidget({
    super.key,
    required this.leading,
    required this.dimension,
    required this.isWidth,
    this.resolvedValue,
    this.onChanged,
  });

  final Widget leading;
  final LayoutDimension dimension;
  final double? resolvedValue;
  final ValueChanged<LayoutDimension>? onChanged;
  final bool isWidth;

  @override
  Widget build(BuildContext context) {
    final dimensionTypeChild = ToggleableButtonRow(
      isFilled: false,
      height: 24.0,
      children: [
        ToggleableButton(
          isActive: dimension.type == .fixed,
          onChanged: onChanged != null ? (v) => onChanged!(dimension.withType(.fixed)) : null,
          iconSize: 16.0,
          child: Icons.layoutSizeFixed(),
        ),
        ToggleableButton(
          isActive: dimension.type == .contain,
          onChanged: onChanged != null ? (v) => onChanged!(dimension.withType(.contain)) : null,
          iconSize: 16.0,
          child: RotatedBox(
            quarterTurns: isWidth ? 1 : 0,
            child: Icons.layoutSizeContain(),
          ),
        ),
        ToggleableButton(
          isActive: dimension.type == .expand,
          onChanged: onChanged != null ? (v) => onChanged!(dimension.withType(.expand)) : null,
          iconSize: 16.0,
          child: RotatedBox(
            quarterTurns: isWidth ? 1 : 0,
            child: Icons.layoutSizeExpand(),
          ),
        ),
      ],
    );

    return DoubleExpressionInputField(
      value: resolvedValue ?? dimension.value,
      onChanged: onChanged != null ? (v) => onChanged!(dimension.withFixed(v)) : null,
      options: .new(
        leading: leading,
        hintText: '0',
        textStyle: resolvedValue != dimension.value ? context.typography.body.tertiary : null,
        builder: (context, child) {
          return Column(
            children: [
              child,
              Divider(),
              dimensionTypeChild,
            ],
          );
        },
      ),
    );
  }
}
