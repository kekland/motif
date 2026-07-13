part of '../core.dart';

class EdgeWeightsPrimitive {
  EdgeWeightsPrimitive({required this.profile});

  final StrokeWeightParameterProfile profile;

  EdgeWeightsPrimitive copyWith({StrokeWeightParameterProfile? profile}) => .new(
    profile: profile ?? this.profile.copy(),
  );

  EdgeWeights inflate() => .new(profile: profile.copy());
}

class EdgeWeights with EdgeProperty<EdgeWeights> {
  EdgeWeights({StrokeWeightParameterProfile? profile}) : _profile = profile ?? .empty();

  Edge? _edge;
  void _markAsDirty() => _edge?._markAsDirty();

  StrokeWeightParameterProfile _profile;
  StrokeWeightParameterProfile get profile => _profile;
  set profile(StrokeWeightParameterProfile value) {
    if (_profile == value) return;
    _profile = value;
    _markAsDirty();
  }

  EdgeWeights copyWith({StrokeWeightParameterProfile? profile}) => .new(
    profile: profile ?? _profile.copy(),
  );

  @override
  (EdgeWeights, EdgeWeights) split(double t) {
    final (left, right) = _profile.split(t);
    return (.new(profile: left), .new(profile: right));
  }

  @override
  List<EdgeWeights> splitMultiple(List<double> ts) {
    return _profile.splitMultiple(ts).map((p) => EdgeWeights(profile: p)).toList();
  }

  EdgeWeightsPrimitive deflate() => .new(profile: profile.copy());
}
