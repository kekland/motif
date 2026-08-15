part of '../../core.dart';

sealed class ContainerChildLayout {
  const ContainerChildLayout();
  static const stack = StackContainerChildLayout();
  const factory ContainerChildLayout.flex({required FlexDirection direction, double gap}) = FlexContainerChildLayout;

  ContainerChildLayoutType get type;

  ResolvedSize layout(ObjectSize size, ObjectConstraints constraints, List<SceneObject> children);
}

final class StackContainerChildLayout extends ContainerChildLayout {
  const StackContainerChildLayout();

  @override
  ContainerChildLayoutType get type => .stack;

  @override
  bool operator ==(Object other) => other is StackContainerChildLayout;

  @override
  int get hashCode => type.hashCode;

  @override
  ResolvedSize layout(ObjectSize size, ObjectConstraints constraints, List<SceneObject> children) =>
      _layoutStack(this, size, constraints, children);
}

final class FlexContainerChildLayout extends ContainerChildLayout {
  const FlexContainerChildLayout({required this.direction, this.gap = 0.0});

  final FlexDirection direction;
  final double gap;

  @override
  ContainerChildLayoutType get type => .flex;

  @override
  bool operator ==(Object other) =>
      other is FlexContainerChildLayout && other.direction == direction && other.gap == gap;

  @override
  int get hashCode => Object.hash(type, direction, gap);

  @override
  ResolvedSize layout(ObjectSize size, ObjectConstraints constraints, List<SceneObject> children) =>
      _layoutFlex(this, size, constraints, children);
}

enum FlexDirection {
  row,
  column;

  ObjectLayoutDimension mainSize(ObjectSize size) => this == .row ? size.width : size.height;
  ObjectLayoutDimension crossSize(ObjectSize size) => this == .row ? size.height : size.width;

  double main(double x, double y) => this == .row ? x : y;
  double cross(double x, double y) => this == .row ? y : x;

  ({double min, double max}) mainConstraints(ObjectConstraints constraints) => switch (this) {
    .row => (min: constraints.minWidth, max: constraints.maxWidth),
    .column => (min: constraints.minHeight, max: constraints.maxHeight),
  };

  ({double min, double max}) crossConstraints(ObjectConstraints constraints) => switch (this) {
    .row => (min: constraints.minHeight, max: constraints.maxHeight),
    .column => (min: constraints.minWidth, max: constraints.maxWidth),
  };

  ObjectConstraints tightConstraintsFor({required double main, required double cross}) => switch (this) {
    .row => .new(minWidth: main, maxWidth: main, minHeight: cross, maxHeight: cross),
    .column => .new(minWidth: cross, maxWidth: cross, minHeight: main, maxHeight: main),
  };

  ResolvedSize sizeFor({required double main, required double cross}) => switch (this) {
    .row => .new(main, cross),
    .column => .new(cross, main),
  };
}

enum ContainerChildLayoutType { stack, flex }
