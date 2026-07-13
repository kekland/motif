part of '../core.dart';

abstract class EdgeWeights {
  const EdgeWeights();
  factory EdgeWeights.immutable({StrokeWeightParameterProfile profile}) = ImmutableEdgeWeights;
  factory EdgeWeights.mutable({StrokeWeightParameterProfile profile}) = MutableEdgeWeights;

  StrokeWeightParameterProfile get profile;

  ImmutableEdgeWeights asImmutable() => .new(profile: profile.copy());
  MutableEdgeWeights asMutable() => .new(profile: profile.copy());

  (EdgeWeights, EdgeWeights) split(double t);
  List<EdgeWeights> splitMultiple(List<double> ts);
}

class ImmutableEdgeWeights extends EdgeWeights {
  ImmutableEdgeWeights({StrokeWeightParameterProfile? profile}) : profile = profile ?? .empty();
  static final ImmutableEdgeWeights default_ = .new();

  @override
  final StrokeWeightParameterProfile profile;

  ImmutableEdgeWeights copyWith({StrokeWeightParameterProfile? profile}) {
    return .new(profile: profile ?? this.profile);
  }

  @override
  (ImmutableEdgeWeights, ImmutableEdgeWeights) split(double t) {
    final splits = profile.split(t);
    return (.new(profile: splits.$1), .new(profile: splits.$2));
  }

  @override
  List<ImmutableEdgeWeights> splitMultiple(List<double> ts) {
    final splits = profile.splitMultiple(ts);
    return splits.map((s) => ImmutableEdgeWeights(profile: s)).toList();
  }
}

class MutableEdgeWeights extends EdgeWeights with ChangeNotifier, ChangeNotifierDisposable {
  MutableEdgeWeights({StrokeWeightParameterProfile? profile}) {
    _profile = $signal(profile ?? .empty());
    notifyListenersOn([_profile]);
  }

  @override
  StrokeWeightParameterProfile get profile => _profile.value;
  late final Signal<StrokeWeightParameterProfile> _profile;
  set profile(StrokeWeightParameterProfile value) => _profile.value = value;

  @override
  (ImmutableEdgeWeights, ImmutableEdgeWeights) split(double t) {
    final splits = profile.split(t);
    return (.new(profile: splits.$1), .new(profile: splits.$2));
  }

  @override
  List<ImmutableEdgeWeights> splitMultiple(List<double> ts) {
    final splits = profile.splitMultiple(ts);
    return splits.map((s) => ImmutableEdgeWeights(profile: s)).toList();
  }
}
