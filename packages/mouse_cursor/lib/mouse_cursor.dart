import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:bindings/bindings.dart';
import 'package:state/state.dart';
import 'package:native/native.dart';
import 'package:vector_graphics/vector_graphics.dart' as vg;

export 'rotating_mouse_cursor.dart';

/// A global class that allows for setting an exclusive mouse cursor that blocks regular mouse cursor updates until
/// released.
///
/// Requires [AugmentedWidgetsFlutterBinding] to be initialized.
class ExclusiveMouseCursor {
  ExclusiveMouseCursor() {
    _binding.defaultBinaryMessenger.addOutgoingInterceptor(
      SystemChannels.mouseCursor.name,
      _mouseCursorChannelInterceptor,
    );

    _binding.pointerRouter.addGlobalRoute(_onPointerRouterEvent);
  }

  static final instance = ExclusiveMouseCursor();

  late final _binding = AugmentedWidgetsFlutterBinding.instance;

  bool get isSessionActive => _session != null;
  var _isSessionInitialized = false;
  MouseCursorSession? _session;
  MouseCursor? _sessionCursor;

  bool _mouseCursorChannelInterceptor(ByteData? message) => _isSessionInitialized;
  bool _mouseCursorSessionInterceptor(MouseCursor cursor) => isSessionActive;

  PointerEvent? _lastPointerEvent;
  void _onPointerRouterEvent(PointerEvent event) {
    _lastPointerEvent = event;
  }

  void _restoreMouseCursor() {
    final e = _lastPointerEvent;
    if (e == null) return;

    // Send removed/added event to trigger forced update in framework.
    _binding.handlePointerEvent(
      PointerRemovedEvent(
        device: e.device,
        pointer: e.pointer,
        kind: e.kind,
        timeStamp: e.timeStamp,
        position: e.position,
        embedderId: e.embedderId,
        viewId: e.viewId,
      ),
    );

    _binding.handlePointerEvent(
      PointerAddedEvent(
        device: e.device,
        pointer: e.pointer,
        kind: e.kind,
        timeStamp: e.timeStamp,
        position: e.position,
        embedderId: e.embedderId,
        viewId: e.viewId,
      ),
    );
  }

  Future<void> set(MouseCursor cursor, [int? device]) async {
    if (_sessionCursor == cursor) return;
    if (isSessionActive) release(update: true);

    final _device = device ?? _lastPointerEvent?.device;
    if (_device == null) return;

    // ignore: invalid_use_of_protected_member
    _session = cursor.createSession(_device);
    _sessionCursor = cursor;

    // ignore: invalid_use_of_protected_member
    await _session!.activate();
    _isSessionInitialized = true;
  }

  void release({bool update = false}) {
    if (!isSessionActive) return;

    // ignore: invalid_use_of_protected_member
    _session?.dispose();
    _session = null;
    _sessionCursor = null;
    _isSessionInitialized = false;

    if (!update) _restoreMouseCursor();
  }
}

mixin _StackMouseCursorMixin on MouseCursor {
  @override
  MouseCursorSession createSession(int device) {
    if (ExclusiveMouseCursor.instance._mouseCursorSessionInterceptor(this)) return _NoOpCursorSession(this, device);
    return super.createSession(device);
  }
}

class VectorGraphicsMouseCursor extends FfiMouseCursor with _StackMouseCursorMixin {
  VectorGraphicsMouseCursor({
    required this.loader,
    this.transform,
    super.hotSpot,
  });

  final vg.BytesLoader loader;
  final Matrix4? transform;

  final _pictureInfoMemozier = AsyncMemoizer<vg.PictureInfo>();
  Future<vg.PictureInfo> get pictureInfo => _pictureInfoMemozier.runOnce(() => vg.vg.loadPicture(loader, null));

  @override
  Future<List<ui.Image>> get representations async {
    final info = await pictureInfo;
    final results = <ui.Image>[];
    final size = info.size;

    final hotSpot = this.hotSpot ?? Offset(size.width / 2, size.height / 2);

    for (final dpr in const [1.0, 2.0, 3.0, 4.0]) {
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);

      canvas.scale(dpr, dpr);

      canvas.translate(hotSpot.dx, hotSpot.dy);
      if (transform != null) canvas.transform(transform!.storage);
      canvas.translate(-hotSpot.dx, -hotSpot.dy);

      canvas.drawPicture(info.picture);

      final canvasPicture = recorder.endRecording();
      final image = await canvasPicture.toImage((size.width * dpr).ceil(), (size.height * dpr).ceil());
      canvasPicture.dispose();

      results.add(image);
    }

    info.picture.dispose();
    return results;
  }

  @override
  Future<Size> get size => pictureInfo.then((info) => info.size);

  @override
  String get debugDescription => 'VectorGraphicsMouseCursor';
}

class ImageMouseCursor extends FfiMouseCursor with _StackMouseCursorMixin {
  ImageMouseCursor.single(ui.Image image)
    : _representations = [image],
      _size = Size(image.width.toDouble(), image.height.toDouble());

  ImageMouseCursor.multiDpr({
    required this._representations,
    required this._size,
    super.hotSpot,
  });

  final List<ui.Image> _representations;
  final Size _size;

  @override
  Future<List<ui.Image>> get representations async => _representations;

  @override
  Future<Size> get size async => _size;

  @override
  String get debugDescription => 'ImageMouseCursor';
}

class _NoOpCursorSession extends MouseCursorSession {
  _NoOpCursorSession(super.cursor, super.device);

  @override
  Future<void> activate() async {}

  @override
  void dispose() {}
}
