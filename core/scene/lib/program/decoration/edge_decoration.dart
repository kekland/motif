part of '../program.dart';

final class const EdgeDecoration({
  final double? strokeWidth,
  final css.ColorData? color,
}) extends CellDecoration {
  EdgeDecoration copyWith({
    double? strokeWidth,
    css.ColorData? color,
  }) => EdgeDecoration(
    strokeWidth: strokeWidth ?? this.strokeWidth,
    color: color ?? this.color,
  );

  @override
  int get hashCode => Object.hash(strokeWidth, color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is EdgeDecoration && strokeWidth == other.strokeWidth && color == other.color);
}
