part of '../core.dart';

abstract class EdgePath {
  const EdgePath();
  factory EdgePath.immutable({List<CubicKnot2> knots, List<StrokePoint>? rawStrokePoints}) = ImmutableEdgePath;
  factory EdgePath.mutable({List<CubicKnot2>? knots, List<StrokePoint>? rawStrokePoints}) = MutableEdgePath;

  List<StrokePoint>? get rawStrokePoints;
  CubicSpline2 get spline => .new(knots.toList());

  Iterable<CubicKnot2> get knots;
  CubicKnot2 knot(int i) => knots.elementAt(i);
  CubicKnot2 operator [](int i) => knot(i);
  CubicKnot2 get first => knot(0);
  CubicKnot2 get last => knot(length - 1);
  int get length => knots.length;

  ImmutableEdgePath asImmutable() => .new(knots: knots.copy(), rawStrokePoints: rawStrokePoints?.toList());
  MutableEdgePath asMutable() => .new(knots: knots.copy(), rawStrokePoints: rawStrokePoints?.toList());

  Aabb2 get bbox {
    if (knots.isEmpty) return .minMax(.zero(), .zero());
    final min = knots.first.p.clone(), max = knots.first.p.clone();

    for (final k in knots) {
      Vector2.min(min, k.p, min);
      Vector2.max(max, k.p, max);

      if (k.cIn != null) {
        Vector2.min(min, k.cIn!, min);
        Vector2.max(max, k.cIn!, max);
      }

      if (k.cOut != null) {
        Vector2.min(min, k.cOut!, min);
        Vector2.max(max, k.cOut!, max);
      }
    }

    return .minMax(min, max);
  }

  Aabb2 get bboxTight => spline.bboxTight;
}

class ImmutableEdgePath extends EdgePath {
  ImmutableEdgePath({List<CubicKnot2> knots = const [], this.rawStrokePoints}) : _knots = knots.copy();

  final List<CubicKnot2> _knots;

  @override
  final List<StrokePoint>? rawStrokePoints;

  @override
  Iterable<CubicKnot2> get knots => _knots;

  ImmutableEdgePath copyWith({List<CubicKnot2>? knots}) => .new(knots: knots ?? this.knots.copy());
}

class MutableEdgePath extends EdgePath with ChangeNotifier, ChangeNotifierDisposable {
  MutableEdgePath({List<CubicKnot2>? knots, this._rawStrokePoints}) {
    _knots = $listSignal(knots?.copy() ?? []);
    notifyListenersOn([_knots]);
  }

  late final ListSignal<CubicKnot2> _knots;

  void _onKnotsChanged() {
    _rawStrokePoints = null;
  }

  @override
  List<StrokePoint>? get rawStrokePoints => _rawStrokePoints;
  List<StrokePoint>? _rawStrokePoints;

  @override
  Iterable<CubicKnot2> get knots => _knots.value;
  void operator []=(int i, CubicKnot2 value) {
    _knots[i] = value;
    _onKnotsChanged();
  }

  set first(CubicKnot2 value) {
    _knots[0] = value;
    _onKnotsChanged();
  }

  set last(CubicKnot2 value) {
    _knots[_knots.length - 1] = value;
    _onKnotsChanged();
  }
}
