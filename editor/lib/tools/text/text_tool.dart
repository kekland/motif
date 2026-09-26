import 'package:editor/imports.dart';

class const TextTool() extends LayoutBoxTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.text();

  @override
  String get key => 'text';

  @override
  String resolveName(BuildContext context) => 'Text';

  @override
  CreateLayoutBoxActivityFactory get activityFactory => CreateTextActivity.new;

  @override
  MouseCursor get cursor => Cursors.precise;

  @override
  SingleActivator? get shortcut => .new(.keyT);
}

class TextStatementEditOverlay extends HookWidget {
  const new({
    super.key,
    required this.info,
    required this.statement,
    required this.onClose,
  });

  final OverlayChildLayoutInfo info;
  final TextStatement statement;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final editableTextKey = useMemoized(() => GlobalKey<EditableTextState>());
    final gestureDetectorKey = useMemoized(() => GlobalKey());
    final gestureDelegate = useMemoized(() => _TextStatementEditOverlayDelegate(editableTextKey));
    final gestureBuilder = useMemoized(() => TextSelectionGestureDetectorBuilder(delegate: gestureDelegate));

    final controller = useTextEditingController.fromValue(
      TextEditingValue(
        text: statement.text,
        selection: .new(baseOffset: 0, extentOffset: statement.text.length),
      ),
    );

    final focusNode = useFocusNode();

    final editor = Editor.of(context);
    final transform = editor.bundle.query.localToWorld(statement.frame);
    final bbox = editor.bundle.query.bbox(statement.frame)!;

    useControllerTextEffect(controller, (text) {
      editor.edit((txn) => txn.update<TextStatement>(statement.id, (s) => s.copyWith(text: text)));
    });

    useListenerEffect(editor.selection, () {
      if (!editor.selection.statements.contains(statement.id)) onClose();
    });

    useListenerEffect(focusNode, () {
      if (!focusNode.hasFocus) onClose();
    });

    return Transform(
      transform: info.childPaintTransform,
      child: OverflowHitTestableStack(
        clipBehavior: .none,
        children: [
          Transform(
            transform: transform.asVM(),
            child: SizedBox(
              width: bbox.width,
              height: bbox.height,
              child: gestureBuilder.buildGestureDetector(
                key: gestureDetectorKey,
                behavior: .translucent,
                child: EditableText(
                  key: editableTextKey,
                  autofocus: true,
                  controller: controller,
                  focusNode: focusNode,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Roboto Mono',
                    package: 'ui',
                  ),
                  cursorColor: context.colors.selection.primary,
                  cursorWidth: 2.0 / info.childPaintTransform.getMaxScaleOnAxis(),
                  backgroundCursorColor: context.colors.selection.secondary.withScaledAlpha(0.5),
                  selectionColor: context.colors.selection.primary.withScaledAlpha(0.5),
                  rendererIgnoresPointer: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextStatementEditOverlayDelegate extends TextSelectionGestureDetectorBuilderDelegate {
  _TextStatementEditOverlayDelegate(this.editableTextKey);

  @override
  final GlobalKey<EditableTextState> editableTextKey;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;
}
