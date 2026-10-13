import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class SelectRectActivity extends MarqueeActivity {
  SelectRectActivity({
    required this.editor,
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
  
  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    editor.selection.clear();
  }

  final Editor editor;
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
