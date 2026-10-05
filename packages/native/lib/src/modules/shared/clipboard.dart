import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:native/native.dart';

abstract class ClipboardImpl {
  void addCustomTypes(List<String> customTypes);

  FutureOr<ClipboardValue> get();
  Future<void> set(List<ClipboardItem> representations);

  String? mergedHtmlFor(List<ClipboardItem> representations) {
    final custom = representations.whereType<ClipboardCustom>().firstOrNull;
    final html = representations.whereType<ClipboardHtml>().firstOrNull?.html;
    return custom?.asHtml(html) ?? html;
  }

  Future<ClipboardImage?> readImage(ClipboardFile file) async => null;
}

final class const ClipboardValue(final List<ClipboardItem> items) {
  ClipboardValue.single(ClipboardItem item) : this([item]);
  static const empty = ClipboardValue([]);

  Future<ClipboardImage?> image() async {
    final image = items.whereType<ClipboardImage>().firstOrNull;
    if (image != null) return image;

    final file = items.whereType<ClipboardFile>().firstOrNull;
    if (file != null) return await Clipboard.tryReadImage(file);
    return null;
  }

  Future<List<ClipboardImage>> images() async {
    final result = <ClipboardImage>[];

    for (final i in items) {
      if (i is ClipboardImage) {
        result.add(i);
      } else if (i is ClipboardFile) {
        final image = await Clipboard.tryReadImage(i);
        if (image != null) result.add(image);
      }
    }

    return result;
  }

  String? text() => items.whereType<ClipboardText>().firstOrNull?.text;

  Uint8List? custom(String type) => items.whereType<ClipboardCustom>().firstOrNull?.entries[type];
}

sealed class const ClipboardItem() {
  static const unsupported = ClipboardUnsupported();
  const factory image(Uint8List bytes, String mimeType) = ClipboardImage;
  const factory file(Uri uri) = ClipboardFile;
  const factory text(String text) = ClipboardText;
  const factory html(String html) = ClipboardHtml;
  const factory custom(Map<String, Uint8List> entries) = ClipboardCustom;
}

final class const ClipboardUnsupported() extends ClipboardItem;
final class const ClipboardImage(final Uint8List bytes, final String mimeType) extends ClipboardItem;
final class const ClipboardFile(final Uri uri) extends ClipboardItem;
final class const ClipboardText(final String text) extends ClipboardItem;
final class const ClipboardHtml(final String html) extends ClipboardItem;

final class const ClipboardCustom(final Map<String, Uint8List> entries) extends ClipboardItem {
  static final _htmlPattern = RegExp(r'data-cc-([\w.-]+)="([A-Za-z0-9+/=]*)"');
  static ClipboardCustom? decodeFromHtml(String html, List<String> types) {
    final found = <String, Uint8List>{};
    for (final m in _htmlPattern.allMatches(html)) {
      if (types.contains(m[1])) found[m[1]!] = base64.decode(m[2]!);
    }

    if (found.isEmpty) return null;
    return .new(found);
  }

  String asHtml(String? html) {
    final buffer = StringBuffer();
    buffer.write('<meta charset="utf-8">');
    for (final custom in entries.entries) {
      buffer.write('<span data-cc-${custom.key}="${base64.encode(custom.value)}"></span>');
    }
    if (html != null) buffer.write(html);
    return buffer.toString();
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Widgets for paste handling
// ---------------------------------------------------------------------------------------------------------------------

final class PasteIntent extends Intent {
  const PasteIntent(this.items);
  final ClipboardValue? items;

  FutureOr<ClipboardValue> resolve() {
    if (items != null) return items!;
    return Clipboard.get();
  }
}
