part of 'core.dart';

sealed class Cell extends SceneObject {
  Cell({super.id, super.transform});

  int get degree => _star.length;
  late final star = UnmodifiableSetView<Cell>(_star);
  final _star = <Cell>{};

  void _addStar(Cell c) => _star.add(c);
  void _removeStar(Cell c) => _star.remove(c);

  void setFrom(covariant Cell other);
  void applyTransform(Matrix4 transform);

  Aabb2 get bboxTight;

  SceneObject get owner => _owner ?? this;
  TopologicalSceneObject? _owner;
  bool get isOwned => _owner != null;

  @override
  void _markNeedsLayout() {
    super._markNeedsLayout();
    for (final cell in _star) cell._markNeedsLayout();
  }

  @override
  Size performLayout([BoxConstraints? constraints]);

  @override
  ReadonlySignal<Cell> call() => _scene!._signalFor(this);
}
