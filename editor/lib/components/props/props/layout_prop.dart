import 'package:editor/components/props/widgets/inputs/layout/layout_align_input_field.dart';
import 'package:editor/components/props/widgets/inputs/layout/layout_justify_input_field.dart';
import 'package:editor/imports.dart';

class LayoutPartial({
  final LayoutInsetsPartial? padding,
}) extends Partial<Layout> {
  @override
  Layout apply(Layout current) => current.copyWith(padding: padding?.apply(current.padding));
}

final class StackLayoutPartial({
  final LayoutAlign? alignHorizontal,
  final LayoutAlign? alignVertical,
  super.padding,
}) extends LayoutPartial {
  @override
  Layout apply(Layout current) {
    if (current is StackLayout) {
      return current.copyWith(
        alignHorizontal: alignHorizontal,
        alignVertical: alignVertical,
        padding: padding?.apply(current.padding),
      );
    }

    return .stack(
      alignHorizontal: alignHorizontal ?? .none,
      alignVertical: alignVertical ?? .none,
      padding: padding?.apply(current.padding) ?? current.padding,
    );
  }
}

final class FlexLayoutPartial({
  final FlexDirection? direction,
  final LayoutJustify? justify,
  final LayoutAlign? crossAlign,
  final double? gap,
  super.padding,
}) extends LayoutPartial {
  @override
  Layout apply(Layout current) {
    if (current is FlexLayout) {
      return current.copyWith(
        direction: direction,
        justify: justify,
        crossAlign: crossAlign,
        gap: gap,
        padding: padding?.apply(current.padding),
      );
    }

    return .flex(
      direction: direction ?? .row,
      justify: justify ?? .start,
      crossAlign: crossAlign ?? .start,
      gap: gap ?? 0.0,
      padding: padding?.apply(current.padding) ?? current.padding,
    );
  }
}

final class LayoutInsetsPartial({
  final double? left,
  final double? top,
  final double? right,
  final double? bottom,
}) extends Partial<LayoutInsets> {
  @override
  LayoutInsets apply(LayoutInsets current) => current.copyWith(
    left: left ?? current.left,
    top: top ?? current.top,
    right: right ?? current.right,
    bottom: bottom ?? current.bottom,
  );
}

final class LayoutProp(
  super.sources, {
  super.kind = .layout,
  super.tooltip = const .new('Controls how the children are laid out'),
}) extends Prop<Layout, LayoutPartial> {
  @override
  PropWidget? buildWidget(BuildContext context) => LayoutPropWidget(prop: this);

  late final LayoutKindProp layoutKind = remap(
    .layoutKind,
    getter: (v) => v.kind,
    setter: (v, k) => k,
  );

  late final LayoutInsetsProp layoutPadding = remap(
    .layoutPadding,
    getter: (v) => v.padding,
    setter: (v, p) => .new(padding: p),
  );

  late final StackLayoutProp layoutStack = remap(
    .layoutStack,
    getter: (v) => v as StackLayout,
    setter: (v, l) => l,
  );

  late final FlexLayoutProp layoutFlex = remap(
    .layoutFlex,
    getter: (v) => v as FlexLayout,
    setter: (v, l) => l,
  );
}

final class LayoutKindProp(super.sources, {super.kind = .layoutKind}) extends Prop<LayoutKind, LayoutPartial>;

final class LayoutInsetsProp(super.sources, {super.kind = .layoutPadding})
    extends Prop<LayoutInsets, LayoutInsetsPartial> {
  late final DoubleProp left = remap(
    .double_,
    getter: (v) => v.left,
    setter: (_, v) => .new(left: v),
  );

  late final DoubleProp top = remap(
    .double_,
    getter: (v) => v.top,
    setter: (_, v) => .new(top: v),
  );

  late final DoubleProp right = remap(
    .double_,
    getter: (v) => v.right,
    setter: (_, v) => .new(right: v),
  );

  late final DoubleProp bottom = remap(
    .double_,
    getter: (v) => v.bottom,
    setter: (_, v) => .new(bottom: v),
  );
}

final class LayoutAlignProp(super.sources, {super.kind = .layoutAlign}) extends Prop<LayoutAlign, LayoutAlign>;
final class LayoutJustifyProp(super.sources, {super.kind = .layoutJustify}) extends Prop<LayoutJustify, LayoutJustify>;
final class LayoutGapProp(super.sources, {super.kind = .layoutGap}) extends Prop<double, double>;

final class StackLayoutProp(super.sources, {super.kind = .layoutStack}) extends Prop<StackLayout, StackLayoutPartial> {
  late final LayoutAlignProp alignHorizontal = remap(
    .layoutAlign,
    getter: (v) => v.alignHorizontal,
    setter: (v, a) => .new(alignHorizontal: a),
  );

  late final LayoutAlignProp alignVertical = remap(
    .layoutAlign,
    getter: (v) => v.alignVertical,
    setter: (v, a) => .new(alignVertical: a),
  );
}

final class FlexLayoutProp(super.sources, {super.kind = .layoutFlex}) extends Prop<FlexLayout, FlexLayoutPartial> {
  late final LayoutJustifyProp justify = remap(
    .layoutJustify,
    getter: (v) => v.justify,
    setter: (v, j) => .new(justify: j),
  );

  late final LayoutAlignProp crossAlign = remap(
    .layoutAlign,
    getter: (v) => v.crossAlign,
    setter: (v, a) => .new(crossAlign: a),
  );

  late final LayoutGapProp gap = remap(
    .layoutGap,
    getter: (v) => v.gap,
    setter: (v, g) => .new(gap: g),
  );
}

final class LayoutPropWidget extends HookWidget with PropWidget {
  const LayoutPropWidget({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final LayoutProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Layout';

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction();
    final layoutKind = useProxyComputedValue(usePropComputed(prop.layoutKind), (v) => v.resolve());

    final paddingLeft = usePropComputed(prop.layoutPadding.left);
    final paddingTop = usePropComputed(prop.layoutPadding.top);
    final paddingRight = usePropComputed(prop.layoutPadding.right);
    final paddingBottom = usePropComputed(prop.layoutPadding.bottom);

    final paddingHorizontalValue = useComputed(() {
      final left = paddingLeft().resolve();
      final right = paddingRight().resolve();
      if (left == right) return left;
      return null;
    }, keys: [paddingLeft, paddingRight]);

    final paddingVerticalValue = useComputed(() {
      final top = paddingTop().resolve();
      final bottom = paddingBottom().resolve();
      if (top == bottom) return top;
      return null;
    }, keys: [paddingTop, paddingBottom]);

    return Padding(
      padding: resolvedPadding,
      child: Column(
        spacing: 8.0,
        children: [
          ToggleableButtonRow(
            children: [
              ToggleableButton(
                onChanged: (v) => prop.set(txn, StackLayoutPartial()),
                isActive: layoutKind == .stack,
                child: Icons.layoutStack(),
              ),
              ToggleableButton(
                onChanged: (v) => prop.set(txn, FlexLayoutPartial(direction: .row)),
                isActive: layoutKind == .flexRow,
                child: Icons.layoutRow(),
              ),
              ToggleableButton(
                onChanged: (v) => prop.set(txn, FlexLayoutPartial(direction: .column)),
                isActive: layoutKind == .flexColumn,
                child: Icons.layoutColumn(),
              ),
            ],
          ),

          ?switch (layoutKind) {
            .stack => StackLayoutPropWidget(prop: prop.layoutStack),
            .flexRow || .flexColumn => FlexLayoutPropWidget(prop: prop.layoutFlex),
            _ => null,
          },

          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: DoubleInputField(
                  value: paddingHorizontalValue,
                  onChanged: (v) => prop.set(
                    txn,
                    .new(
                      padding: .new(left: v, right: v),
                    ),
                  ),
                  options: .new(
                    leading: Icons.paddingAxis(),
                    hintText: 'Mixed',
                  ),
                ),
              ),
              Expanded(
                child: DoubleInputField(
                  value: paddingVerticalValue,
                  onChanged: (v) => prop.set(
                    txn,
                    .new(
                      padding: .new(top: v, bottom: v),
                    ),
                  ),
                  options: .new(
                    leading: RotatedBox(quarterTurns: 1, child: Icons.paddingAxis()),
                    hintText: 'Mixed',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --
// Stack/flex layouts
// --

final class const StackLayoutPropWidget({
  super.key,
  required final StackLayoutProp prop,
  @override final bool isNested = false,
}) extends HookWidget with PropWidget {
  @override
  String? resolveHeader(BuildContext context) => 'Stack layout';

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction();
    final computed = usePropComputed(prop);

    return Row(
      spacing: 8.0,
      children: [
        Expanded(
          child: LayoutAlignInputField(
            value: useProxyComputed(computed, (v) => v.resolve()?.alignHorizontal),
            isVertical: false,
            canBeNone: true,
            onChanged: (v) => prop.set(txn, .new(alignHorizontal: v)),
          ),
        ),
        Expanded(
          child: LayoutAlignInputField(
            value: useProxyComputed(computed, (v) => v.resolve()?.alignVertical),
            isVertical: true,
            canBeNone: true,
            onChanged: (v) => prop.set(txn, .new(alignVertical: v)),
          ),
        ),
      ],
    );
  }
}

final class const FlexLayoutPropWidget({
  super.key,
  required final FlexLayoutProp prop,
  @override final bool isNested = false,
}) extends HookWidget with PropWidget {
  @override
  String? resolveHeader(BuildContext context) => 'Flex layout';

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction();
    final computed = usePropComputed(prop);
    final direction = useProxyComputedValue(computed, (v) => v.resolve()?.direction);

    return Column(
      spacing: 8.0,
      children: [
        Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: LayoutJustifyInputField(
                value: useProxyComputed(computed, (v) => v.resolve()?.justify),
                isVertical: direction == .column,
                onChanged: (v) => prop.set(txn, .new(justify: v)),
              ),
            ),
            Expanded(
              child: LayoutAlignInputField(
                value: useProxyComputed(computed, (v) => v.resolve()?.crossAlign),
                isVertical: direction != .column,
                onChanged: (v) => prop.set(txn, .new(crossAlign: v)),
              ),
            ),
          ],
        ),
        DoubleInputField(
          value: useProxyComputed(computed, (v) => v.resolve()?.gap),
          onChanged: (v) => prop.set(txn, .new(gap: v)),
          options: .new(
            leading: Icons.gap(),
          ),
        ),
      ],
    );
  }
}
