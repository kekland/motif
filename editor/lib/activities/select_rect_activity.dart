import 'package:editor/imports.dart';

class SelectRectActivity extends MarqueeActivity {
  SelectRectActivity({
    required super.editor,
    super.onLocalRectChanged,
    super.onStart,
    super.onUpdate,
    super.onEnd,
  }) : super(
         onGlobalRectChanged: (v) {
           if (v == null) return;
           final (globalRect, mode) = v;
           final hitTestResult = editor.hitTestRect(globalRect, mode: mode);
           final refs = hitTestResult.refs;
           editor.selection.setMultiple(refs);
         },
       );
}

class SelectRectDetector extends HookWidget {
  const SelectRectDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return MarqueeDetector(
      activityFactory: (onLocalRectChanged) => SelectRectActivity(
        editor: Editor.of(context),
        onLocalRectChanged: onLocalRectChanged,
      ),
    );
  }
}
