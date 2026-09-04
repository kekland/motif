part of '../../program.dart';

mixin PlacedStatement on Statement {
  Borrow<FrameRef>? get parent;
}
