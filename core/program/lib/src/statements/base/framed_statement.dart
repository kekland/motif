part of '../../_program.dart';

mixin FramedStatement on Statement {
  FrameRef get frame;

  bool get isLeaf;
}
