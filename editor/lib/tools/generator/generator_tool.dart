import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_overlay/selection_overlay.dart';

class GeneratorTool extends Tool {
  const GeneratorTool();

  @override
  Widget buildIcon(BuildContext context) => Icons.generator();

  @override
  String resolveName(BuildContext context) => 'Generator';

  @override
  String get key => 'generator';

  @override
  Widget buildViewportOverlay(
    BuildContext context,
    OverlayChildLayoutInfo info,
    GeneratorTool tool,
  ) => _GeneratorToolOverlay(info: info, tool: tool);
}

class _GeneratorToolOverlay extends HookWidget {
  const new({
    super.key,
    required this.info,
    required this.tool,
  });

  final OverlayChildLayoutInfo info;
  final GeneratorTool tool;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final selectedStatements = useState<Set<StatementId>>({});
    final selectedRefs = useState<Set<CellRef>>({});

    return Stack(
      fit: .expand,
      children: [
        CellSelectionGroupOverlay(
          editor: editor,
          childPaintTransform: info.childPaintTransform,
          colors: context.colors.selectionAlt,
          refs: selectedRefs.value,
          showHandles: false,
        ),
        MarqueeDetector(
          color: context.colors.selectionAlt.primary,
          onGlobalRectChanged: (v) {
            if (v == null) return;
            final (rect, mode) = v;
            final hitTestResult = editor.hitTestRect(rect, mode: mode);
            final statements = hitTestResult.statements;
            selectedStatements.value = statements.toSet();

            final refs = <CellRef>{};
            for (final s in statements) refs.addAll(editor.productsOf(s));
            selectedRefs.value = refs;
          },
          onEnd: () {
            final targets = selectedStatements.value.toList();
            selectedRefs.value = {};
            selectedStatements.value = {};

            final generator = editor.edit((txn) => txn.wrapGenerator(targets));
            editor.selection.setStatement(generator.id);
            editor.tab.value = .generators;
          },
          onCancel: () {
            selectedRefs.value = {};
          },
        ),
      ],
    );
  }
}
