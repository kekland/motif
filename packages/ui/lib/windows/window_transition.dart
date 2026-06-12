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

Widget _windowTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Widget window,
  Rect src,
) {
  return GenieTransition(
    animation: animation,
    src: Rect.fromLTWH(800.0, 120.0, 32.0, 32.0),
    child: window,
  );

  // return FadeTransition(
  //   opacity: animation,
  //   child: SlideTransition(
  //     position: Tween<Offset>(begin: .new(0.0, 0.1), end: .zero).animate(animation),
  //     child: window,
  //   ),
  // );
}
