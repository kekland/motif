import 'package:editor/imports.dart';

final class const LayoutSizePartial({
  final LayoutDimension? width,
  final LayoutDimension? height,
}) extends Partial<LayoutSize> with Equatable {
  factory from(LayoutSize? value) => .new(width: value?.width, height: value?.height);

  @override
  LayoutSize apply(LayoutSize current) => .new(width ?? current.width, height ?? current.height);

  @override
  List<Object?> get props => [width, height];
}

final class LayoutSizeProp(super.sources, {super.kind = .layoutSize}) extends Prop<LayoutSize, LayoutSizePartial> {
  late final LayoutDimensionProp width = remap(
    .layoutDimension,
    getter: (v) => v.width,
    setter: (p, v) => .new(width: v),
    override: (v) => v?.width,
  );

  late final LayoutDimensionProp height = remap(
    .layoutDimension,
    getter: (v) => v.height,
    setter: (p, v) => .new(height: v),
    override: (v) => v?.height,
  );

  @override
  Iterable<Prop> get children => [width, height];

  @override
  PropWidget? buildWidget(BuildContext context) => LayoutSizePropWidget(prop: this);
}

final class LayoutSizePropWidget extends HookWidget with PropWidget {
  const LayoutSizePropWidget({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final LayoutSizeProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Size';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: resolvedPadding,
      child: Row(
        spacing: 4.0,
        children: [
          Expanded(
            child: LayoutDimensionPropWidget(prop: prop.width, axis: .x, isNested: true),
          ),
          Expanded(
            child: LayoutDimensionPropWidget(prop: prop.height, axis: .y, isNested: true),
          ),
        ],
      ),
    );
  }
}
