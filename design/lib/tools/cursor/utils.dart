import 'package:design/imports.dart';

Iterable<RenderNode> hitTestNodes(RenderRootNode root, Offset globalPosition) {
  final localPosition = root.globalToLocal(globalPosition);
  final result = NodeHitTestResult();
  root.nodeHitTest(result, position: localPosition);
  return result.path.map((p) => p.target);
}
