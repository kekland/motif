part of '../../_program.dart';

mixin FramedStatement on Statement {
  FrameRef get frame;

  bool get isLeaf;

  Mat4 frameTransformOf(EvalContext context, Mat4 own, {FrameRef? parent}) {
    var t = own;
    final transients = context._evaluation.transientTransform;
    final global = transients.globalOf(id);
    final local = transients.localOf(id);

    if (global != null) t = context.worldToLocal(parent ?? .root) * global;
    if (local != null) t = local * t;

    return t;
  }
}
