import 'package:editor/imports.dart';

extension Vec2Extensions on Vec2 {
  Offset get offset => Offset(x, y);
}

extension OffsetExtensions on Offset {
  Vec2 get vec2 => Vec2(dx, dy);
}
