import 'dart:io';

import 'package:state/state.dart';

import 'package:native/darwin.dart' as darwin;
import 'package:native/macos.dart' as macos;
import 'package:native/src/logger.dart';

abstract class FullscreenObserver extends Controller {
  FullscreenObserver._() : super(logger: Logger('FullscreenObserver'));

  factory FullscreenObserver() {
    if (Platform.isMacOS) return _MacosFullscreenObserver();

    logger.warning(
      'FullscreenObserver is not implemented for this platform. Returning a no-op implementation.',
    );

    return _NoopFullscreenObserver();
  }

  late final _isFullscreen = $prop($signal(false));
  bool get isFullscreen => _isFullscreen.value;
}

class _NoopFullscreenObserver extends FullscreenObserver {
  _NoopFullscreenObserver() : super._();
}

class _MacosFullscreenObserver extends FullscreenObserver {
  _MacosFullscreenObserver() : super._() {
    final application = macos.NSApplication.getSharedApplication();
    final window = application.flutterWindow;

    enterFullscreenListener = $disposable(
      darwin.NotificationCenterListener(
        object: window,
        name: macos.NSWindowWillEnterFullScreenNotification,
        callback: () => _isFullscreen.value = true,
      ),
    );

    exitFullscreenListener = $disposable(
      darwin.NotificationCenterListener(
        object: window,
        name: macos.NSWindowWillExitFullScreenNotification,
        callback: () => _isFullscreen.value = false,
      ),
    );

    _isFullscreen.value = window.styleMask & macos.NSWindowStyleMask.NSWindowStyleMaskFullScreen != 0;
  }

  late final darwin.NotificationCenterListener enterFullscreenListener;
  late final darwin.NotificationCenterListener exitFullscreenListener;
}
