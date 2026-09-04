part of '../cubic.dart';

extension Cubic2IterableCopy on Iterable<Cubic2> {
  List<Cubic2> copy() => map((c) => c.copy()).toList(growable: false);
}
