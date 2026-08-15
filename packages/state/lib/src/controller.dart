import 'package:flutter/foundation.dart';
import 'package:state/state.dart';

/// A controller is a short-lived object that manages a specific piece of functionality, and that can be located
/// in the widget tree.
abstract class Controller with Disposable, MethodExtension {
  Controller({required this.logger}) {
    logger.fine('Created #${shortHash(this)}');
  }

  @override
  final Logger logger;

  @override
  @mustCallSuper
  void dispose() {
    logger.fine('Disposed #${shortHash(this)}');
    super.dispose();
  }
}
