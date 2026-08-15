part of '../cubic.dart';

extension Cubic2IterableCopy on Iterable<Cubic2> {
  List<Cubic2> copy() => map((c) => c.copy()).toList(growable: false);
}

extension CubicKnot2IterableCopy on Iterable<CubicKnot2> {
  List<CubicKnot2> copy() => map((k) => k.copy()).toList(growable: false);
}
