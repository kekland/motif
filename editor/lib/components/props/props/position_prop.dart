import 'package:editor/imports.dart';

final class Vec2Partial({final double? x, final double? y}) extends Partial<Vec2> with Equatable {
  factory from(Vec2? value) => .new(x: value?.x, y: value?.y);

  @override
  Vec2 apply(Vec2 current) => .new(x ?? current.x, y ?? current.y);

  @override
  List<Object?> get props => [x, y];
}

final class PositionProp(
  super.sources, {
  super.kind = .position,
  super.tooltip = const .new('Controls how the statement is positioned'),
}) extends Prop<Vec2, Vec2Partial> {
  late final CoordinateProp x = remap(
    .coordinate,
    getter: (v) => v.x,
    setter: (p, v) => .new(x: v),
    override: (v) => v?.x,
  );

  late final CoordinateProp y = remap(
    .coordinate,
    getter: (v) => v.y,
    setter: (p, v) => .new(y: v),
    override: (v) => v?.y,
  );

  @override
  Iterable<Prop> get children => [x, y];

  @override
  PropWidget? buildWidget(BuildContext context) => PositionPropWidget(prop: this);
}

final class PositionPropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final PositionProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Position';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: resolvedPadding,
      child: Row(
        spacing: 4.0,
        children: [
          Expanded(
            child: CoordinatePropWidget(prop: prop.x, axis: .x, isNested: true),
          ),
          Expanded(
            child: CoordinatePropWidget(prop: prop.y, axis: .y, isNested: true),
          ),
        ],
      ),
    );
  }
}
