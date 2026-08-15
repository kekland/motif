import 'package:flutter/widgets.dart';
import 'package:state/state.dart';

class FullscreenListener extends HookWidget {
  const FullscreenListener({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, bool isFullscreen) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, false);
  }
}
