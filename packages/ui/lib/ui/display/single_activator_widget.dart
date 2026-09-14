import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

class SingleActivatorWidget extends StatelessWidget {
  const new({
    super.key,
    required this.value,
  });

  final SingleActivator value;

  @override
  Widget build(BuildContext context) {
    final parts = [..._KeyGlyphs.modifiers(value), _KeyGlyphs.key(value.trigger)];

    if (_KeyGlyphs.isApple) {
      return KeyCapWidget(value: parts.join());
    } else {
      return Row(
        mainAxisSize: .min,
        children: [
          for (final part in parts) ...[
            KeyCapWidget(value: part),
            if (part != parts.last) const SizedBox(width: 4.0),
          ],
        ],
      );
    }
  }
}

class KeyCapWidget extends StatelessWidget {
  const new({
    super.key,
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: context.colors.divider,
      width: 1.0,
    );

    final bottomBorder = border.copyWith(width: 2.0);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface.primary,
        borderRadius: .circular(4.0),
        border: .fromLTRB(
          left: border,
          top: border,
          right: border,
          bottom: bottomBorder,
        ),
      ),
      padding: const .symmetric(horizontal: 4.0),
      height: 16.0,
      child: Center(
        child: Text(
          value,
          style: context.typography.footnote.primary,
        ),
      ),
    );
  }
}

abstract final class _KeyGlyphs {
  static bool get isApple => switch (defaultTargetPlatform) {
    .macOS || .iOS => true,
    _ => false,
  };

  static List<String> modifiers(SingleActivator a) => switch (defaultTargetPlatform) {
    .macOS || .iOS => [
      if (a.meta) '⌘',
      if (a.control) '⌃',
      if (a.shift) '⇧',
      if (a.alt) '⌥',
    ],
    .windows => [
      if (a.meta) 'Win',
      if (a.control) 'Ctrl',
      if (a.shift) 'Shift',
      if (a.alt) 'Alt',
    ],
    _ => [
      if (a.meta) 'Meta',
      if (a.control) 'Ctrl',
      if (a.shift) 'Shift',
      if (a.alt) 'Alt',
    ],
  };

  static String key(LogicalKeyboardKey k) => (isApple ? _appleKeys[k] : _otherKeys[k]) ?? _commonKeys[k] ?? k.keyLabel;

  static final _commonKeys = <LogicalKeyboardKey, String>{
    .arrowUp: '↑',
    .arrowDown: '↓',
    .arrowLeft: '←',
    .arrowRight: '→',
    .space: 'Space',
  };

  static final _appleKeys = <LogicalKeyboardKey, String>{
    .enter: '↩',
    .backspace: '⌫',
    .delete: '⌦',
    .tab: '⇥',
    .escape: '⎋',
    .capsLock: '⇪',
    .pageUp: '⇞',
    .pageDown: '⇟',
    .home: '↖',
    .end: '↘',
  };

  static final _otherKeys = <LogicalKeyboardKey, String>{
    .enter: 'Enter',
    .backspace: 'Backspace',
    .delete: 'Delete',
    .tab: 'Tab',
    .escape: 'Escape',
    .pageUp: 'Page Up',
    .pageDown: 'Page Down',
    .home: 'Home',
    .end: 'End',
  };
}
