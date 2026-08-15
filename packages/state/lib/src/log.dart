
import 'package:state/state.dart';

class LoggerSignalsObserver extends SignalsObserver {
  final log = Logger('signals');

  @override
  void onSignalCreated<T>(Signal<T> instance, T value) {
    log.finest('Created [${instance.globalId}, ${value.runtimeType}] SIGNAL');
  }

  @override
  void onSignalUpdated<T>(Signal<T> instance, T value) {
    log.finest('Updated [${instance.globalId}, type ${value.runtimeType}] SIGNAL');
  }

  @override
  void onComputedCreated<T>(Computed<T> instance) {
    log.finest('Created [${instance.globalId}] COMPUTED');
  }

  @override
  void onComputedUpdated<T>(Computed<T> instance, T value) {
    log.finest('Updated [${instance.globalId}, ${value.runtimeType}] COMPUTED');
  }

  @override
  void onEffectCreated(Effect instance) {
    log.finest('Created [${instance.globalId}] EFFECT');
  }

  @override
  void onEffectCalled(Effect instance) {
    log.finest('Called [${instance.globalId}] EFFECT');
  }

  @override
  void onEffectRemoved(Effect instance) {
    log.finest('Removed [${instance.globalId}] EFFECT');
  }
}
