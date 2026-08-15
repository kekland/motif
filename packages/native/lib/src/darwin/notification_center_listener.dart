import 'dart:ffi';

import 'package:objective_c/objective_c.dart' as objc;
import 'package:state/state.dart';
import '../gen/darwin_bindings.g.dart' as darwin;

class NotificationCenterListener with Disposable implements Finalizable {
  NotificationCenterListener({
    required this.object,
    required this.name,
    required this.callback,
    this.synchronous = false,
  }) : _listener = darwin.NotificationCenterListener.alloc().initWithObject(
         object,
         name: name,
         callback: synchronous
             ? darwin.ObjCBlock_ffiVoid.fromFunction(callback)
             : darwin.ObjCBlock_ffiVoid.listener(callback),
       );

  final objc.NSObject object;
  final objc.NSString name;
  final void Function() callback;
  final bool synchronous;

  final darwin.NotificationCenterListener _listener;

  void stop() => _listener.stop();

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
