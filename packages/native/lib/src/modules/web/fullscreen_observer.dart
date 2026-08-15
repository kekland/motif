import 'package:state/state.dart';

abstract class FullscreenObserver extends Controller {
  FullscreenObserver._() : super(logger: Logger('FullscreenObserver'));

  factory FullscreenObserver() => _NoopFullscreenObserver();
  bool get isFullscreen => false;
}

class _NoopFullscreenObserver extends FullscreenObserver {
  _NoopFullscreenObserver() : super._();
}
