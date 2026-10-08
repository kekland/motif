import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

bool get _isApple => switch (defaultTargetPlatform) {
  .macOS || .iOS => true,
  _ => false,
};

final class KeyboardUtils {
  KeyboardUtils._();

  static KeyboardUtils get instance => _instance;
  static final KeyboardUtils _instance = KeyboardUtils._();

  bool get isCtrlPressed {
    if (_isApple) return hardware.isMetaPressed;
    return hardware.isControlPressed;
  }

  bool get isShiftPressed => hardware.isShiftPressed;
  bool get isAltPressed => hardware.isAltPressed;

  HardwareKeyboard get hardware => HardwareKeyboard.instance;
}

extension KeyboardUtilsContext on BuildContext {
  KeyboardUtils get keyboard => .instance;
}
