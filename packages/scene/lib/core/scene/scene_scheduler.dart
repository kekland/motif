part of '../core.dart';

typedef FrameCallbackScheduler = void Function(void Function());

class SceneScheduler with Disposable {
  SceneScheduler(this.scene);
  final Scene scene;

  FrameCallbackScheduler? _scheduler;
  set scheduler(FrameCallbackScheduler? value) {
    if (_scheduler == value) return;
    _scheduler = value;
  }

  void scheduleFrameCallback(void Function() callback) {
    _scheduler?.call(callback);
  }
}
