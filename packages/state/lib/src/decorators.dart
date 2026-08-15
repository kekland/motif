import 'dart:async';

import 'package:state/state.dart';

extension PropExtension on Disposable {
  /// A property should be created with a disposable method. This is used as a keyword for the codegen to create getters
  /// and setters for the property.
  T $prop<T>(T s) => s;
}

mixin MethodExtension on Disposable {
  Logger get logger;

  void handleMethodError(Object exception, StackTrace? stackTrace) {
    // no-op by default.
  }

  FutureOr<R> $method<R>(FutureOr<R> Function() fn) {
    try {
      final result = logger.wrap(fn, level: 1);

      if (result is Future<R>) {
        return result.catchError((e, st) {
          handleMethodError(e, st);
          throw e;
        });
      }

      return result;
    } catch (e, st) {
      handleMethodError(e, st);
      rethrow;
    }
  }
}
