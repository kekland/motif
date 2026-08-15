import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:objective_c/objective_c.dart';
import 'package:state/state.dart';

import 'package:native/macos.dart' as macos;
import 'package:native/src/logger.dart';

abstract class FfiMouseCursor extends MouseCursor {
  FfiMouseCursor({this.hotSpot});

  final Offset? hotSpot;

  Future<List<ui.Image>> get representations;
  Future<Size> get size;

  /// Cached byte data for the representations.
  final _reprDataMemoizer = AsyncMemoizer<List<Uint8List>>();
  Future<List<Uint8List>> get _representationsByteData => _reprDataMemoizer.runOnce(
    () => representations.then(
      (r) => r.map((r) => r.toByteData(format: ui.ImageByteFormat.png).then((b) => b!.buffer.asUint8List())).wait,
    ),
  );

  /// Cached size.
  final _sizeMemoizer = AsyncMemoizer<Size>();
  Future<Size> get _size => _sizeMemoizer.runOnce(() => size);

  /// Cached native object.
  final _nativeObjectMemoizer = AsyncMemoizer<Object?>();

  @override
  MouseCursorSession createSession(int device) {
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      // No cursor support on mobile platforms.
      return _NoOpCursorSession(this, device);
    }

    if (Platform.isMacOS) return _MacosMouseCursorSession(this, device);

    logger.warning('Unsupported FfiMouseCursor platform. Defaulting to _NoOpCursorSession.');
    return _NoOpCursorSession(this, device);
  }
}

class _NoOpCursorSession extends MouseCursorSession {
  _NoOpCursorSession(super.cursor, super.device);

  @override
  Future<void> activate() async {}

  @override
  void dispose() {}
}

abstract class _FfiMouseCursorSession extends MouseCursorSession {
  _FfiMouseCursorSession(FfiMouseCursor super.cursor, super.device);

  Future<Size> get size => cursor._size;
  Future<List<ui.Image>> get representations => cursor.representations;
  Future<List<Uint8List>> get representationsByteData => cursor._representationsByteData;
  Offset? get hotSpot => cursor.hotSpot;

  @override
  FfiMouseCursor get cursor => super.cursor as FfiMouseCursor;
}

class _MacosMouseCursorSession extends _FfiMouseCursorSession {
  _MacosMouseCursorSession(super.cursor, super.device);

  macos.NSCursor? _cursor;
  var _disposed = false;

  @override
  Future<void> activate() async {
    final value = await cursor._nativeObjectMemoizer.runOnce(
      () => withZoneArena(() async {
        final size = await this.size;
        final cgSize = macos.Structs.CGSize(size.width, size.height);

        final nsImage = macos.NSImage();
        nsImage.size = cgSize;

        for (final data in await representationsByteData) {
          final bitmapRep = macos.NSBitmapImageRep.alloc().initWithData(data.toNSData())!;
          bitmapRep.size = cgSize;

          nsImage.addRepresentation(bitmapRep);
        }

        final hotSpot = this.hotSpot ?? size.center(Offset.zero);
        final hotSpotCgPoint = macos.Structs.CGPoint(hotSpot.dx, hotSpot.dy);

        final nsCursor = macos.NSCursor().initWithImage$1(nsImage, hotSpot: hotSpotCgPoint);
        return nsCursor;
      }),
    );

    _cursor = value as macos.NSCursor;
    if (!_disposed) _cursor?.set();
  }

  @override
  void dispose() {
    _disposed = true;
    // _cursor?.pop();
  }
}
