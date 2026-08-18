import 'package:flutter/widgets.dart';

typedef AppAnimations = ({
  AnimationStyle window,
});

const AppAnimations materialAnimations = (
  window: AnimationStyle(
    duration: Duration(milliseconds: 400),
    curve: Curves.linear,
  ),
);

const AppAnimations cupertinoAnimations = (
  window: AnimationStyle(
    duration: Duration(milliseconds: 400),
    curve: Curves.linear,
  ),
);
