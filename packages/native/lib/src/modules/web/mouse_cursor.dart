import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

abstract class FfiMouseCursor extends MouseCursor {
  const FfiMouseCursor({this.hotSpot});

  final Offset? hotSpot;

  Future<List<ui.Image>> get representations;
  Future<Size> get size;

  @override
  MouseCursorSession createSession(int device) {
    // TODO: Web cursor support.
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
