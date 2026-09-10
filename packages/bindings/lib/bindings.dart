import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:state/initializer.dart';

part 'mouse_cursor_manager.dart';

class AugmentedWidgetsFlutterBinding extends BindingBase
    with
        GestureBinding,
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        SemanticsBinding,
        RendererBinding,
        WidgetsBinding {
  AugmentedWidgetsFlutterBinding() : super() {
    initializeState();

    // ignore: invalid_use_of_visible_for_testing_member
    initMouseTracker(
      CustomMouseTracker(
        (Offset position, int viewId) {
          final result = HitTestResult();
          hitTestInView(result, position, viewId);
          return result;
        },
        ExclusiveMouseCursorManager(SystemMouseCursors.basic),
      ),
    );
  }

  static AugmentedWidgetsFlutterBinding? _instance;
  static AugmentedWidgetsFlutterBinding get instance => _instance!;

  static WidgetsBinding ensureInitialized() {
    if (_instance != null) return _instance!;

    _instance = AugmentedWidgetsFlutterBinding();
    return _instance!;
  }

  @override
  CustomMouseTracker get mouseTracker => super.mouseTracker as CustomMouseTracker;
  ExclusiveMouseCursorManager get mouseCursorManager => mouseTracker.mouseCursorManager as ExclusiveMouseCursorManager;
}
