import 'package:flutter/material.dart';

typedef AppAnimations = ({
  AnimationStyle spatialFast,
  AnimationStyle spatialDefault,
  AnimationStyle spatialSlow,
  AnimationStyle effectFast,
  AnimationStyle effectDefault,
  AnimationStyle effectSlow,
  AnimationStyle window,
});

const AppAnimations materialAnimations = (
  spatialFast: AnimationStyle(
    duration: Duration(milliseconds: 350),
    curve: Cubic(0.42, 1.67, 0.21, 0.90),
  ),
  spatialDefault: AnimationStyle(
    duration: Duration(milliseconds: 500),
    curve: Cubic(0.38, 1.21, 0.22, 1.00),
  ),
  spatialSlow: AnimationStyle(
    duration: Duration(milliseconds: 650),
    curve: Cubic(0.39, 1.29, 0.35, 0.98),
  ),
  effectFast: AnimationStyle(
    duration: Duration(milliseconds: 150),
    curve: Cubic(0.31, 0.94, 0.34, 1.00),
  ),
  effectDefault: AnimationStyle(
    duration: Duration(milliseconds: 200),
    curve: Cubic(0.34, 0.80, 0.34, 1.00),
  ),
  effectSlow: AnimationStyle(
    duration: Duration(milliseconds: 300),
    curve: Cubic(0.34, 0.88, 0.34, 1.00),
  ),
  window: AnimationStyle(
    duration: Duration(milliseconds: 275),
    curve: Easing.emphasizedDecelerate,
    reverseCurve: Easing.emphasizedAccelerate,
  ),
);

const AppAnimations cupertinoAnimations = (
  spatialFast: AnimationStyle(
    duration: Duration(milliseconds: 350),
    curve: Cubic(0.42, 1.67, 0.21, 0.90),
  ),
  spatialDefault: AnimationStyle(
    duration: Duration(milliseconds: 500),
    curve: Cubic(0.38, 1.21, 0.22, 1.00),
  ),
  spatialSlow: AnimationStyle(
    duration: Duration(milliseconds: 650),
    curve: Cubic(0.39, 1.29, 0.35, 0.98),
  ),
  effectFast: AnimationStyle(
    duration: Duration(milliseconds: 150),
    curve: Cubic(0.31, 0.94, 0.34, 1.00),
  ),
  effectDefault: AnimationStyle(
    duration: Duration(milliseconds: 200),
    curve: Cubic(0.34, 0.80, 0.34, 1.00),
  ),
  effectSlow: AnimationStyle(
    duration: Duration(milliseconds: 300),
    curve: Cubic(0.34, 0.88, 0.34, 1.00),
  ),
  window: AnimationStyle(
    duration: Duration(milliseconds: 275),
    curve: Easing.emphasizedDecelerate,
    reverseCurve: Easing.emphasizedAccelerate,
  ),
);
