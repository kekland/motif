part of '../cubic.dart';

abstract class CubicKnot2 {
  CubicKnot2._();

  factory CubicKnot2(Vec2 p, {Vec2 cIn, Vec2 cOut}) = RegularCubicKnot2;
  factory CubicKnot2.cubicView(Vec2List data, bool isStart) = CubicKnot2View;
  factory CubicKnot2.splineView(Vec2List data, int i) = RegularCubicKnot2.splineView;
  factory CubicKnot2.empty() = RegularCubicKnot2.empty;
  factory CubicKnot2.view(Vec2List storage) = RegularCubicKnot2.from;

  Aabb2 get bbox => _knotBbox(this);

  Vec2 get p;
  Vec2 get cIn;
  Vec2 get cOut;

  set p(Vec2 value);
  set cIn(Vec2 value);
  set cOut(Vec2 value);

  CubicKnot2 copy() => .new(p, cIn: cIn, cOut: cOut);

  void _writeToSplineStorage(Vec2List storage, int i);
}

final class CubicKnot2View extends CubicKnot2 {
  CubicKnot2View(Vec2List data, bool isStart)
    : _storage = data,
      _pIndex = isStart ? 0 : 3,
      _cInIndex = isStart ? -1 : 2,
      _cOutIndex = isStart ? 1 : -1,
      super._();

  final Vec2List _storage;
  final int _pIndex;
  final int _cInIndex;
  final int _cOutIndex;

  // dart format off
  @override Vec2 get p => _storage[_pIndex];
  @override Vec2 get cIn => _cInIndex != -1 ? _storage[_cInIndex] : p;
  @override Vec2 get cOut => _cOutIndex != -1 ? _storage[_cOutIndex] : p;

  @override set p(Vec2 value) => _storage[_pIndex] = value;
  @override set cIn(Vec2 value) {
    if (_cInIndex == -1) return;
    _storage[_cInIndex] = value;
  }

  @override set cOut(Vec2 value) {
    if (_cOutIndex == -1) return;
    _storage[_cOutIndex] = value;
  }
  // dart format on

  @override
  void _writeToSplineStorage(Vec2List storage, int i) {
    storage[i * 3] = p;
    storage[i * 3 + 1] = cIn;
    storage[i * 3 + 2] = cOut;
  }
}

final class RegularCubicKnot2 extends CubicKnot2 {
  RegularCubicKnot2(Vec2 p, {Vec2? cIn, Vec2? cOut}) : _storage = Vec2List(3), super._() {
    _storage[0] = p;
    _storage[1] = cIn ?? p;
    _storage[2] = cOut ?? p;
  }

  RegularCubicKnot2.splineView(Vec2List data, int i) : _storage = .sublistView(data, i * 3, (i + 1) * 3), super._();

  RegularCubicKnot2.empty() : _storage = Vec2List(3), super._();
  RegularCubicKnot2.from(Vec2List storage) : _storage = storage, super._();

  final Vec2List _storage;

  // dart format off
  @override Vec2 get p => _storage[0];
  @override Vec2 get cIn => _storage[1];
  @override Vec2 get cOut => _storage[2];

  @override set p(Vec2 value) => _storage[0] = value;
  @override set cIn(Vec2 value) => _storage[1] = value;
  @override set cOut(Vec2 value) => _storage[2] = value;
  // dart format on

  @override
  void _writeToSplineStorage(Vec2List storage, int i) {
    storage.setAll(i * 3, _storage);
  }
}
