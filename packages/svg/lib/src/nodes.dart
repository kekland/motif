part of '../svg.dart';

sealed class const Node({
  final String? name,
  final Transform transform = .identity,
  final double opacity = 1.0,
});

final class const Group({
  required final List<Node> children,
  final Clip? clip,
  super.name,
  super.transform,
  super.opacity,
}) extends Node;

final class const Shape({
  required final Geometry geometry,
  required final Style style,
  super.name,
  super.transform,
  super.opacity,
}) extends Node;

final class const Clip(final List<Shape> shapes);
