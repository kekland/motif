import 'dart:async';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:objective_c/objective_c.dart';

import 'package:native/macos.dart' as macos;
import 'package:native/src/logger.dart';

import 'package:native/src/modules/shared/mouse_cursor.dart';

abstract class FfiMouseCursor extends FfiMouseCursorBase {
  FfiMouseCursor({super.hotSpot});

  @override
  MouseCursorSession createSession(int device) {
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      // No cursor support on mobile platforms.
      return NoOpCursorSession(this, device);
    }

    if (Platform.isMacOS) return _MacosMouseCursorSession(this, device);

    logger.warning('Unsupported FfiMouseCursor platform. Defaulting to _NoOpCursorSession.');
    return NoOpCursorSession(this, device);
  }
}

class _MacosMouseCursorSession extends FfiMouseCursorSession {
  _MacosMouseCursorSession(super.cursor, super.device);

  macos.NSCursor? _cursor;

  @override
  Future<void> activate() async {
    final value = await cursor.nativeObjectMemoizer.runOnce(
      () => withZoneArena(() async {
        final size = await this.size;
        final cgSize = macos.Structs.CGSize(size.width, size.height);

        final nsImage = macos.NSImage();
        nsImage.size = cgSize;

        for (final (data, _) in await resolvedReprs) {
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
    if (!disposed) _cursor?.set();
  }
}
