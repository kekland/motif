import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:native/native.dart';
import 'package:web/web.dart' as web;

ClipboardImpl createClipboardImpl() => WebClipboardImpl();

final class WebClipboardImpl extends ClipboardImpl {
  WebClipboardImpl() {
    web.document.addEventListener('paste', _onPaste.toJS);
  }

  @override
  void addCustomTypes(List<String> customTypes) => _customTypes.addAll(customTypes);
  final _customTypes = <String>[];

  final _pasteStreamController = StreamController<ClipboardValue>.broadcast();
  Stream<ClipboardValue> get onPaste => _pasteStreamController.stream;

  var _parseQueue = Future<void>.value();

  void _onPaste(web.ClipboardEvent event) {
    final target = event.target;
    if (target != null && (target.isA<web.HTMLInputElement>() || target.isA<web.HTMLTextAreaElement>())) return;

    final data = event.clipboardData;
    if (data == null) return;
    event.preventDefault();

    final files = <web.File>[];
    for (var i = 0; i < data.files.length; i++) files.add(data.files.item(i)!);

    final text = data.getData('text/plain');
    final html = data.getData('text/html');

    _parseQueue = _parseQueue.then((_) async {
      final data = await _handleClipboardData(files, text, html);
      _pasteStreamController.add(data);
    });
  }

  Future<ClipboardValue> _handleClipboardData(List<web.File> files, String text, String html) async {
    final custom = ClipboardCustom.decodeFromHtml(html, _customTypes);
    if (custom != null) return .single(custom);

    if (files.isNotEmpty) {
      final result = <ClipboardItem>[];

      for (final file in files) {
        if (file.type.startsWith('image/')) {
          result.add(.image(await _readBlob(file), file.type));
        } else {
          result.add(.unsupported);
        }
      }

      return .new(result);
    }

    if (text.isNotEmpty) return .single(.text(text));
    if (html.isNotEmpty) return .single(.html(html));

    return .empty;
  }

  @override
  Future<ClipboardValue> get() async {
    final items = (await web.window.navigator.clipboard.read().toDart).toDart;
    final result = <ClipboardItem>[];

    for (final item in items) {
      final types = item.types.toDart.map((t) => t.toDart).toList();

      String? html;
      if (types.contains('text/html')) {
        html = await _readText(await item.getType('text/html').toDart);
        final custom = ClipboardCustom.decodeFromHtml(html, _customTypes);
        if (custom != null) {
          result.add(custom);
          continue;
        }
      }

      if (types.contains('image/png')) {
        final data = await _readBlob(await item.getType('image/png').toDart);
        result.add(.image(data, 'image/png'));
      } else if (types.contains('text/plain')) {
        final data = await _readText(await item.getType('text/plain').toDart);
        result.add(.text(data));
      } else if (html != null) {
        result.add(.html(html));
      } else {
        result.add(.unsupported);
      }
    }

    return .new(result);
  }

  @override
  Future<void> set(List<ClipboardItem> representations) async {
    final blobs = <String, web.Blob>{};

    for (final r in representations) {
      if (r is ClipboardImage && r.mimeType == 'image/png') blobs['image/png'] = _writeBlob(r.bytes, 'image/png');
      if (r is ClipboardText) blobs['text/plain'] = _writeBlob(utf8.encode(r.text), 'text/plain');
    }

    final html = mergedHtmlFor(representations);
    if (html != null) blobs['text/html'] = _writeBlob(utf8.encode(html), 'text/html');
    if (blobs.isEmpty) return;

    final obj = JSObject();
    for (final entry in blobs.entries) {
      obj[entry.key] = entry.value;
    }

    await web.window.navigator.clipboard.write([web.ClipboardItem(obj)].toJS).toDart;
  }

  Future<Uint8List> _readBlob(web.Blob blob) async {
    return (await blob.arrayBuffer().toDart).toDart.asUint8List();
  }

  Future<String> _readText(web.Blob blob) async {
    return (await blob.text().toDart).toDart;
  }

  web.Blob _writeBlob(Uint8List data, String type) => .new([data.toJS].toJS, .new(type: type));
}

class PasteHandlerWidgetState extends State<PasteHandlerWidget> {
  final _node = FocusNode(canRequestFocus: false, skipTraversal: true);
  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = (Clipboard.instance as WebClipboardImpl).onPaste.listen(_onPaste);
  }

  void _onPaste(ClipboardValue items) {
    if (!_node.hasFocus) return;

    final focusContext = _node.context;
    if (focusContext == null) return;

    final intent = PasteIntent(items);
    final action = Actions.maybeFind<PasteIntent>(context, intent: intent);
    if (action != null) Actions.of(context).invokeActionIfEnabled(action, intent, context);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _node,
      child: widget.child,
    );
  }
}
