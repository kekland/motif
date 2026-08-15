// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:objective_c/objective_c.dart' as objc;

class Structs {
  static objc.CGPoint CGPoint(double x, double y) {
    final point = malloc<objc.CGPoint>();
    point.ref.x = x;
    point.ref.y = y;
    zoneArena.using(point, (p) => malloc.free(p));
    return point.ref;
  }

  static objc.CGSize CGSize(double width, double height) {
    final size = malloc<objc.CGSize>();
    size.ref.width = width;
    size.ref.height = height;
    zoneArena.using(size, (s) => malloc.free(s));
    return size.ref;
  }

  static objc.CGRect CGRect(double x, double y, double width, double height) {
    final rect = malloc<objc.CGRect>();
    rect.ref.origin.x = x;
    rect.ref.origin.y = y;
    rect.ref.size.width = width;
    rect.ref.size.height = height;
    zoneArena.using(rect, (r) => malloc.free(r));
    return rect.ref;
  }
}
