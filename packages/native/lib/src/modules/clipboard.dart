import 'dart:async';

import 'package:flutter/widgets.dart';

import 'shared/clipboard.dart';
import 'native/clipboard.dart' if (dart.library.js_interop) 'web/clipboard.dart';

export 'shared/clipboard.dart';

abstract final class Clipboard {
  static ClipboardImpl get instance => _instance ??= createClipboardImpl();
  static ClipboardImpl? _instance;

  static void addCustomTypes(List<String> customTypes) => instance.addCustomTypes(customTypes);
  static FutureOr<ClipboardValue> get() => instance.get();
  static Future<void> set(List<ClipboardItem> representations) => instance.set(representations);

  static Future<ClipboardImage?> tryReadImage(ClipboardFile file) => instance.readImage(file);
}

final class const PasteHandlerWidget({
  super.key,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<PasteHandlerWidget> createState() => PasteHandlerWidgetState();
}
