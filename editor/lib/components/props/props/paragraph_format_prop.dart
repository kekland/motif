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

final class ParagraphFormatProp(
  super.sources, {
  super.kind = .paragraphFormat,
  super.tooltip = const .new('Controls how the paragraph is formatted'),
}) extends Prop<ParagraphFormat, ParagraphFormatPartial> {
  @override
  PropWidget? buildWidget(BuildContext context) => ParagraphFormatPropWidget(prop: this);
}

final class ParagraphFormatPropWidget extends HookWidget with PropWidget {
  const new({
    super.key,
    required this.prop,
    this.isNested = false,
  });

  final ParagraphFormatProp prop;

  @override
  final bool isNested;

  @override
  String resolveHeader(BuildContext context) => 'Paragraph';

  @override
  Widget build(BuildContext context) {
    final txn = usePropTransaction();
    final computed = usePropComputed(prop);
    final format = useProxyComputed(computed, (value) => value.resolve());

    final alignment = useProxyComputedValue(format, (v) => v?.alignment);
    final verticalAlignment = useProxyComputedValue(format, (v) => v?.verticalAlignment);

    return Padding(
      padding: resolvedPadding,
      child: Column(
        spacing: 8.0,
        children: [
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ToggleableButtonRow(
                  height: 24.0,
                  children: [
                    ToggleableButton(
                      iconSize: 16.0,
                      isActive: alignment == .left,
                      onChanged: (v) => prop.set(txn, .new(alignment: .left)),
                      child: Icons.paragraphFormatAlignmentLeft(),
                    ),
                    ToggleableButton(
                      iconSize: 16.0,
                      isActive: alignment == .center,
                      onChanged: (v) => prop.set(txn, .new(alignment: .center)),
                      child: Icons.paragraphFormatAlignmentCenter(),
                    ),
                    ToggleableButton(
                      iconSize: 16.0,
                      isActive: alignment == .right,
                      onChanged: (v) => prop.set(txn, .new(alignment: .right)),
                      child: Icons.paragraphFormatAlignmentRight(),
                    ),
                    ToggleableButton(
                      iconSize: 16.0,
                      isActive: alignment == .justify,
                      onChanged: (v) => prop.set(txn, .new(alignment: .justify)),
                      child: Icons.paragraphFormatAlignmentJustify(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ToggleableButtonRow(
                  height: 24.0,
                  children: [
                    ToggleableButton(
                      iconSize: 16.0,
                      isActive: verticalAlignment == .top,
                      onChanged: (v) => prop.set(txn, .new(verticalAlignment: .top)),
                      child: Icons.paragraphFormatVerticalAlignmentTop(),
                    ),
                    ToggleableButton(
                      iconSize: 16.0,
                      isActive: verticalAlignment == .middle,
                      onChanged: (v) => prop.set(txn, .new(verticalAlignment: .middle)),
                      child: Icons.paragraphFormatVerticalAlignmentMiddle(),
                    ),
                    ToggleableButton(
                      iconSize: 16.0,
                      isActive: verticalAlignment == .bottom,
                      onChanged: (v) => prop.set(txn, .new(verticalAlignment: .bottom)),
                      child: Icons.paragraphFormatVerticalAlignmentBottom(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
