part of '../data.dart';

/// Represents node's layout-time properties, like dimensions, flex properties, etc.
class NodeLayoutData with EquatableMixin {
  const NodeLayoutData({required this.size, this.childLayout = .stack});
  NodeLayoutData.fixed(double width, double height, {this.childLayout = .stack}) : size = .fixed(width, height);

  static const zero = NodeLayoutData(size: .zero);
  static const infinity = NodeLayoutData(size: .infinity);

  final NodeLayoutSize size;
  final NodeChildLayout childLayout;

  NodeLayoutData copyWith({NodeLayoutSize? size, NodeChildLayout? childLayout}) {
    return .new(size: size ?? this.size, childLayout: childLayout ?? this.childLayout);
  }

  @override
  List<Object?> get props => [size, childLayout];
}

/// Represents the node's layout size.
class NodeLayoutSize with EquatableMixin {
  const NodeLayoutSize({required this.width, required this.height});

  NodeLayoutSize.fixed(double width, double height) : width = .fixed(width), height = .fixed(height);
  NodeLayoutSize.expand({double? width, double? height}) : width = .expand(width), height = .expand(height);
  NodeLayoutSize.contain({double? width, double? height}) : width = .contain(width), height = .contain(height);

  static const zero = NodeLayoutSize(width: .zero, height: .zero);
  static const infinity = NodeLayoutSize(width: .infinity, height: .infinity);

  final NodeLayoutDimension width;
  final NodeLayoutDimension height;

  NodeLayoutSize copyWith({NodeLayoutDimension? width, NodeLayoutDimension? height}) {
    return .new(width: width ?? this.width, height: height ?? this.height);
  }

  NodeLayoutSize copyWithFixed({double? width, double? height}) {
    return .new(
      width: width != null ? .fixed(width) : this.width,
      height: height != null ? .fixed(height) : this.height,
    );
  }

  @override
  List<Object?> get props => [width, height];
}

/// Represents the node's dimension (width or height) in the layout.
///
/// See [NodeLayoutDimensionType] for more details on how the dimension is calculated during layout.
final class NodeLayoutDimension with EquatableMixin {
  const NodeLayoutDimension({required this.value, required this.type});
  const NodeLayoutDimension.fixed(double this.value) : type = .fixed;
  const NodeLayoutDimension.expand([this.value]) : type = .expand;
  const NodeLayoutDimension.contain([this.value]) : type = .contain;

  static const zero = NodeLayoutDimension.fixed(0.0);
  static const infinity = NodeLayoutDimension.fixed(double.infinity);

  final double? value;
  final NodeLayoutDimensionType type;

  NodeLayoutDimension copyWith({double? value, NodeLayoutDimensionType? type}) {
    return NodeLayoutDimension(value: value ?? this.value, type: type ?? this.type);
  }

  @override
  List<Object?> get props => [value, type];
}

/// Determines how the node's dimension (width or height) is calculated during layout.
enum NodeLayoutDimensionType {
  /// The node's dimension is fixed to a specific value.
  fixed,

  /// The node's dimension expands to fill the available space.
  ///
  /// Can only be applied to a node that has a direct fixed-size parent, or a parent with [fill] dimension type.
  expand,

  /// The node's dimension is determined by its children and layout logic.
  ///
  /// Note: this is only applicable to nodes that have [isLeaf] set to `false`.
  contain,
}

/// Represents how the node lays out its children.
///
/// Note: this is subclassed for each [NodeChildLayoutType] to allow for different properties for different layout
/// types.
sealed class NodeChildLayout with EquatableMixin {
  const NodeChildLayout();
  static const stack = StackNodeChildLayout();
  const factory NodeChildLayout.flex({required FlexDirection direction, double gap}) = FlexNodeChildLayout;

  NodeChildLayoutType get type;
  bool get isChildrenTranslationIgnored;
}

final class StackNodeChildLayout extends NodeChildLayout {
  const StackNodeChildLayout();

  @override
  NodeChildLayoutType get type => .stack;

  @override
  bool get isChildrenTranslationIgnored => false;

  @override
  List<Object?> get props => [type];
}

final class FlexNodeChildLayout extends NodeChildLayout {
  const FlexNodeChildLayout({required this.direction, this.gap = 0.0});

  final FlexDirection direction;
  final double gap;

  @override
  NodeChildLayoutType get type => .flex;

  @override
  bool get isChildrenTranslationIgnored => true;

  @override
  List<Object?> get props => [type, direction, gap];
}

/// Represents how the node lays out its children.
enum NodeChildLayoutType {
  /// The node lays out its children in a [Stack], like a freeform canvas.
  stack,

  /// The node lays out its children in a Flexbox layout.
  flex,
}

/// Direction of flex layout.
enum FlexDirection { row, column }

// Convenience mixins for nodes that have layout properties.
mixin NodeWithLayout {
  /// Node's layout properties.
  NodeLayoutData get layout;
}

mixin MutableNodeWithLayout implements NodeWithLayout {
  // dart format off
  late final Signal<NodeLayoutData> _layoutSignal;
  @override NodeLayoutData get layout => _layoutSignal.value;
  set layout(NodeLayoutData value) => _layoutSignal.value = value;
  // dart format on
}
