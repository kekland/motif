part of 'bindings.dart';

class GlobalPointerTracker {
  GlobalPointerTracker() {
    initialize();
  }

  static GlobalPointerTracker get instance => AugmentedWidgetsFlutterBinding.instance.pointerTracker;

  final Set<int> activePointerIds = {};

  void initialize() {
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerEvent);
  }

  void _handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      activePointerIds.add(event.pointer);
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      activePointerIds.remove(event.pointer);
    }
  }
}
