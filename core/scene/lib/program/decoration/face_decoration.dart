part of '../program.dart';

final class const FaceDecoration({
  final css.ColorData? color,
}) extends CellDecoration {
  FaceDecoration copyWith({
    css.ColorData? color,
  }) => FaceDecoration(
    color: color ?? this.color,
  );

  @override
  int get hashCode => color.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FaceDecoration && color == other.color);
}
