import 'package:editor/imports.dart';

final class ParagraphFormatPartial({
  final TextAlignment? alignment,
  final TextVerticalAlignment? verticalAlignment,
  final String? ellipsis,
}) extends Partial<ParagraphFormat> with Equatable {
  @override
  ParagraphFormat apply(ParagraphFormat current) => current.copyWith(
    alignment: alignment,
    verticalAlignment: verticalAlignment,
    ellipsis: ellipsis,
  );

  @override
  List<Object?> get props => [alignment, verticalAlignment, ellipsis];
}

final class ParagraphFormatProp(super.sources, {super.kind = .paragraphFormat})
    extends Prop<ParagraphFormat, ParagraphFormatPartial> {
  @override
  PropWidget? buildWidget(BuildContext context) => ParagraphFormatPropWidget(prop: this);
}

final class ParagraphFormatPropWidget extends HookWidget with PropWidget {
  const new({super.key, required this.prop});

  final ParagraphFormatProp prop;

  @override
  String resolveHeader(BuildContext context) => 'Paragraph';

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
