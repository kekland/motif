import 'package:editor/imports.dart';

final class FaceStyleProp(super.sources, {super.kind = .faceStyle}) extends Prop<FaceStyle, FaceStylePartial> {
  late final DecorationsProp decorations = remap(
    .decorations,
    getter: (s) => s.decorations,
    setter: (s, v) => .new(decorations: v),
    override: (s) => s?.decorations,
  );

  @override
  Iterable<Prop> get children => [decorations];

  @override
  PropWidget? buildWidget(BuildContext context) => FaceStylePropWidget(prop: this);
}

final class FaceStylePropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
  });

  final FaceStyleProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Fill';

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      children: [
        DecorationsPropWidget(prop: prop.decorations),
      ],
    );
  }
}
