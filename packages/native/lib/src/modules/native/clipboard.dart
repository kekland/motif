import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' hide Clipboard;
import 'package:flutter/widgets.dart';
import 'package:native/native.dart';
import 'package:objective_c/objective_c.dart';

import 'package:native/macos.dart' as macos;

ClipboardImpl createClipboardImpl() => MacOSClipboard();

final class MacOSClipboard extends ClipboardImpl {
  macos.NSPasteboard get pasteboard => macos.NSPasteboard.getGeneralPasteboard();

  @override
  void addCustomTypes(List<String> customTypes) => _customTypes.addAll(customTypes);
  final _customTypes = <String>[];

  late final _png = macos.NSPasteboardTypePNG.toDartString();
  late final _jpeg = 'public.jpeg';
  late final _tiff = macos.NSPasteboardTypeTIFF.toDartString();
  late final _gif = 'com.compuserve.gif';
  late final _fileUrl = macos.NSPasteboardTypeFileURL.toDartString();
  late final _html = macos.NSPasteboardTypeHTML.toDartString();
  late final _string = macos.NSPasteboardTypeString.toDartString();

  late final pasteboardPreferences = <NSString>[
    _gif.toNSString(),
    _png.toNSString(),
    _jpeg.toNSString(),
    _tiff.toNSString(),
    _fileUrl.toNSString(),
    _string.toNSString(),
    _html.toNSString(),
  ].toNSArray();

  @override
  FutureOr<ClipboardValue> get() {
    final result = <ClipboardItem>[];

    autoReleasePool(() {
      final items = pasteboard.pasteboardItems;
      if (items == null) return;

      for (final obj in items.asDart()) {
        final item = macos.NSPasteboardItem.fromPointer(obj.ref.pointer);
        result.add(_read(item));
      }
    });

    return .new(result);
  }

  ClipboardItem _read(macos.NSPasteboardItem item) {
    final custom = _readCustom(item);
    if (custom != null) return custom;

    final type = item.availableTypeFromArray(pasteboardPreferences);
    if (type == null) return .unsupported;
    final src = type.toDartString();

    if (src == _html) {
      final html = item.stringForType(type)?.toDartString();
      return html != null ? .html(html) : .unsupported;
    }

    final data = item.dataForType(type);
    if (data == null) return .unsupported;

    // image types
    if (src == _png) return .image(data.toList(), 'image/png');
    if (src == _jpeg) return .image(data.toList(), 'image/jpeg');
    if (src == _gif) return .image(data.toList(), 'image/gif');
    if (src == _tiff) {
      final rep = macos.NSBitmapImageRep.imageRepWithData(data);
      final pngData = rep?.representationUsingType(.NSBitmapImageFileTypePNG, properties: .dictionary());
      return pngData != null ? .image(pngData.toList(), 'image/png') : .unsupported;
    }

    // other types
    if (src == _string) return .text(utf8.decode(data.toList()));
    if (src == _fileUrl) {
      final path = NSURL.URLWithDataRepresentation(data).filePathURL?.path?.toDartString();
      return path != null ? .file(.file(path)) : .unsupported;
    }

    return .unsupported;
  }

  ClipboardCustom? _readCustom(macos.NSPasteboardItem item) {
    if (_customTypes.isEmpty) return null;

    final entries = <String, Uint8List>{};
    for (final type in _customTypes) {
      final data = item.dataForType(type.toNSString());
      if (data != null) entries[type] = data.toList();
    }

    if (entries.isNotEmpty) return .new(entries);

    final html = item.stringForType(macos.NSPasteboardTypeHTML)?.toDartString();
    if (html == null) return null;
    return ClipboardCustom.decodeFromHtml(html, _customTypes);
  }

  @override
  Future<void> set(List<ClipboardItem> representations) async {
    final custom = representations.whereType<ClipboardCustom>().firstOrNull;
    final html = mergedHtmlFor(representations);

    autoReleasePool(() {
      final item = macos.NSPasteboardItem();

      if (custom != null) {
        for (final entry in custom.entries.entries) {
          item.setData(entry.value.toNSData(), forType: entry.key.toNSString());
        }
      }

      for (final r in representations) {
        if (r is ClipboardImage) {
          final type = switch (r.mimeType) {
            'image/png' => _png,
            'image/jpeg' => _jpeg,
            'image/gif' => _gif,
            'image/tiff' => _tiff,
            _ => null,
          };

          if (type != null) item.setData(r.bytes.toNSData(), forType: type.toNSString());
        }

        if (r is ClipboardText) item.setString(r.text.toNSString(), forType: macos.NSPasteboardTypeString);
        if (r is ClipboardFile) item.setString(r.uri.toString().toNSString(), forType: macos.NSPasteboardTypeFileURL);
      }

      if (html != null) item.setString(html.toNSString(), forType: macos.NSPasteboardTypeHTML);

      pasteboard.clearContents();
      pasteboard.writeObjects([item].toNSArray());
    });
  }

  @override
  Future<ClipboardImage?> readImage(ClipboardFile file) async {
    final uri = file.uri;
    if (!uri.isScheme('file')) return null;

    try {
      final file = await File.fromUri(uri).open();
      try {
        final mime = _readImageMime(await file.read(12));
        if (mime == null) return null;
        await file.setPosition(0);
        return .new(await file.read(await file.length()), mime);
      } finally {
        await file.close();
      }
    } on FileSystemException {
      return null;
    }
  }
}

String? _readImageMime(Uint8List b) => switch (b) {
  [0x89, 0x50, 0x4E, 0x47, ...] => 'image/png',
  [0xFF, 0xD8, 0xFF, ...] => 'image/jpeg',
  [0x47, 0x49, 0x46, 0x38, ...] => 'image/gif',
  [0x52, 0x49, 0x46, 0x46, _, _, _, _, 0x57, 0x45, 0x42, 0x50, ...] => 'image/webp',
  _ => null,
};

class PasteHandlerWidgetState extends State<PasteHandlerWidget> {
  bool _activates(KeyEvent event) {
    final _isApple = switch (defaultTargetPlatform) {
      .macOS || .iOS => true,
      _ => false,
    };

    final SingleActivator activator = _isApple ? .new(.keyV, meta: true) : .new(.keyV, control: true);
    return activator.accepts(event, HardwareKeyboard.instance);
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    final context = node.context;
    if (context == null) return .ignored;
    if (!_activates(event)) return .ignored;

    final items = Clipboard.get() as ClipboardValue;
    final intent = PasteIntent(items);

    final action = Actions.maybeFind<PasteIntent>(context, intent: intent);
    if (action != null) {
      final (enabled, result) = Actions.of(context).invokeActionIfEnabled(action, intent, context);
      if (enabled) {
        return action.toKeyEventResult(intent, result);
      }
    }

    return .ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: _onKeyEvent,
      child: widget.child,
    );
  }
}
