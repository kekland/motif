import 'package:editor/imports.dart';

final class MoveActivity extends TransformActivity {
  MoveActivity(super.editor, super.cells, {super.onStart, super.onEnd});

  @override
  @override
  void onUpdate(DragUpdateDetails details) {
    final start = editor.globalToScene(startDetails.globalPosition);
    final current = editor.globalToScene(details.globalPosition);
    final delta = current - start;
    session.translateBy(delta);
    super.onUpdate(details);
  }

  @override
  MouseCursor get cursor => Cursors.toolMove;
}
