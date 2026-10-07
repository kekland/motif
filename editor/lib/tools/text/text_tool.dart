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
    required this.id,
    required this.onClose,
  });

  final OverlayChildLayoutInfo info;
  final StatementId id;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final editableTextKey = useMemoized(() => GlobalKey<EditableTextState>());
    final gestureDetectorKey = useMemoized(() => GlobalKey());
    final gestureDelegate = useMemoized(() => _TextStatementEditOverlayDelegate(editableTextKey));
    final gestureBuilder = useMemoized(() => TextSelectionGestureDetectorBuilder(delegate: gestureDelegate));
    final statement = editor.statement<TextStatement>(id)!;
    useExistingSignal(editor.scene.notifier.forStatement(id), keys: [id]);

    final controller = useTextEditingController.fromValue(
      TextEditingValue(
        text: statement.text,
        selection: .new(baseOffset: 0, extentOffset: statement.text.length),
      ),
    );

    final focusNode = useFocusNode();

    final transform = editor.bundle.query.localToWorld(statement.frame);
    final bbox = editor.bundle.query.bbox(statement.frame)!;

    useControllerTextEffect(controller, (text) {
      editor.edit((txn) => txn.update<TextStatement>(id, (s) => s.copyWith(text: text)));
    });

    useListenerEffect(editor.selection, () {
      if (!editor.selection.statements.contains(id)) onClose();
    });

    useListenerEffect(focusNode, () {
      if (!focusNode.hasFocus) onClose();
    });

    final textFormat = statement.textFormat;
    final textStyle = TextStyle(
      color: Colors.transparent,
      fontFamily: textFormat.fontFamily,
      fontSize: textFormat.fontSize,
      letterSpacing: textFormat.letterSpacing,
      fontStyle: switch(textFormat.fontSlant) {
        .upright => .normal,
        .italic => .italic,
        .oblique => .normal,
      },
      fontWeight: .new(textFormat.fontWeight.value),
    );

    return Transform(
      transform: info.childPaintTransform,
      child: OverflowHitTestableStack(
        clipBehavior: .none,
        children: [
          Transform(
            transform: transform.asVM(),
            child: SizedBox(
              width: statement.size.width.isContain ? null : bbox.width,
              child: gestureBuilder.buildGestureDetector(
                key: gestureDetectorKey,
                behavior: .translucent,
                child: EditableText(
                  key: editableTextKey,
                  autofocus: true,
                  controller: controller,
                  focusNode: focusNode,
                  maxLines: null,
                  style: textStyle,
                  cursorColor: context.colors.selection.primary,
                  cursorWidth: 2.0 / info.childPaintTransform.getMaxScaleOnAxis2D(),
                  backgroundCursorColor: context.colors.selection.secondary.withScaledAlpha(0.5),
                  selectionColor: context.colors.selection.primary.withScaledAlpha(0.25),
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
