import 'package:flutter/widgets.dart';
import 'package:state/state.dart';
import 'package:native/native.dart';

class FullscreenListener extends HookWidget {
  const FullscreenListener({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, bool isFullscreen) builder;

  @override
  Widget build(BuildContext context) {
    final observer = useDisposable(() => FullscreenObserver());
    final isFullscreen = useComputedValue(() => observer.isFullscreen);
    return builder(context, isFullscreen);
  }
}
