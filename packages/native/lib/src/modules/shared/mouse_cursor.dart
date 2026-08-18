import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:state/state.dart';

abstract class FfiMouseCursorBase extends MouseCursor {
  new({this.hotSpot});

  final Offset? hotSpot;

  Future<List<ui.Image>> get representations;
  Future<Size> get size;

  /// Cached byte data for the representations.
  final _reprsMemoizer = AsyncMemoizer<List<(Uint8List, Size)>>();
  Future<List<(Uint8List, Size)>> get resolvedReprs => _reprsMemoizer.runOnce(() async {
    final futures = (await representations).map((repr) async {
      final size = Size(repr.width.toDouble(), repr.height.toDouble());
      final byteData = await repr.toByteData(format: ui.ImageByteFormat.png);
      return (byteData!.buffer.asUint8List(), size);
    }).wait;

    return futures;
  });

  /// Cached size.
  final _sizeMemoizer = AsyncMemoizer<Size>();
  Future<Size> get resolvedSize => _sizeMemoizer.runOnce(() => size);

  /// Cached native object.
  final nativeObjectMemoizer = AsyncMemoizer<Object?>();
}

class NoOpCursorSession extends MouseCursorSession {
  NoOpCursorSession(super.cursor, super.device);

  @override
  Future<void> activate() async {}

  @override
  void dispose() {}
}

abstract class FfiMouseCursorSession extends MouseCursorSession {
  FfiMouseCursorSession(FfiMouseCursorBase super.cursor, super.device);

  Future<Size> get size => cursor.resolvedSize;
  Future<List<(Uint8List, Size)>> get resolvedReprs => cursor.resolvedReprs;
  Offset? get hotSpot => cursor.hotSpot;

  @override
  FfiMouseCursorBase get cursor => super.cursor as FfiMouseCursorBase;

  bool _disposed = false;
  bool get disposed => _disposed;

  @override
  void dispose() {
    _disposed = true;
  }
}
