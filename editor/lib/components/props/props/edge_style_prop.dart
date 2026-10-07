import 'package:editor/imports.dart';

final class EdgeStyleProp(
  super.sources, {
  super.kind = .edgeStyle,
  final String? decorationsEmptyStateLabel,
}) extends Prop<EdgeStyle, EdgeStylePartial> {
  late final StrokeWidthProp strokeWidth = remap(
    .strokeWidth,
    getter: (s) => s.width,
    setter: (s, v) => .new(width: v),
    override: (s) => s?.width,
  );

  late final DecorationsProp decorations = remap(
    .decorations,
    getter: (s) => s.decorations,
    setter: (s, v) => .new(decorations: v),
    override: (s) => s?.decorations,
  );

  @override
  Iterable<Prop> get children => [strokeWidth, decorations];

  @override
  PropWidget? buildWidget(BuildContext context) => EdgeStylePropWidget(prop: this);
}

final class EdgeStylePropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final EdgeStyleProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Stroke';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecorationsPropWidget(
          prop: prop.decorations,
          padding: resolvedPadding.copyWith(bottom: 4.0),
          emptyStateLabel: prop.decorationsEmptyStateLabel,
        ),
        StrokeWidthPropWidget(prop: prop.strokeWidth),
      ],
    );
  }
}
