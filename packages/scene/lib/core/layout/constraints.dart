part of '../core.dart';

class LayoutConstraints {
  const LayoutConstraints({
    this.minWidth = 0.0,
    this.maxWidth = .infinity,
    this.minHeight = 0.0,
    this.maxHeight = .infinity,
  });

  static const unconstrained = LayoutConstraints();

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LayoutConstraints &&
            minWidth == other.minWidth &&
            maxWidth == other.maxWidth &&
            minHeight == other.minHeight &&
            maxHeight == other.maxHeight;
  }

  @override
  int get hashCode => Object.hash(minWidth, maxWidth, minHeight, maxHeight);
}
