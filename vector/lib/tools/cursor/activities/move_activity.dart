part of 'cursor_activities.dart';

sealed class MoveDragActivity extends DragActivity {
  MoveDragActivity({required this.controller});
  final VectorController controller;

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final delta =
        controller.globalToArtworkLocal(details.globalPosition) -
        controller.globalToArtworkLocal(startDetails.globalPosition);

    applyDelta(delta);
  }

  void applyDelta(Offset delta);
}
