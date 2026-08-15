part of 'window_entry.dart';

window_manager.WindowTransitionBuilder windowTransitionBuilder(Rect src) {
  return (BuildContext context, Animation<double> animation, Widget window) {
    return GenieTransition(
      animation: animation,
      src: src,
      child: window,
    );
  };
}
