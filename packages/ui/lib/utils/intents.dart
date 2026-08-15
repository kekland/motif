import 'package:flutter/widgets.dart';
import 'package:state/state.dart';

class LoggingActionDispatcher extends ActionDispatcher {
  LoggingActionDispatcher({required this.logger});

  final Logger logger;

  @override
  Object? invokeAction(covariant Action<Intent> action, covariant Intent intent, [BuildContext? context]) {
    logger.fine('invoking action: [${action.runtimeType}] from intent: [${intent.runtimeType}]');
    return super.invokeAction(action, intent, context);
  }

  @override
  (bool, Object?) invokeActionIfEnabled(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    logger.fine('invoking action (maybe): [${action.runtimeType}] from intent: [${intent.runtimeType}]');
    return super.invokeActionIfEnabled(action, intent, context);
  }
}

extension IntentBuildContextExtension on BuildContext {
  Object? invoke(Intent intent) => Actions.maybeInvoke(this, intent);
}
