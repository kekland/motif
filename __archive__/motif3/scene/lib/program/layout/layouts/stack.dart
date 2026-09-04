part of '../../program.dart';

Size2 _measureStack(_Node node, StackChildLayout childLayout) {
  var out = node.box.naturalSize;
  for (final c in node.children) out = out.hull(c.orientedNatural);
  return out;
}

List<LayoutResult> _placeStack(_Node node, Size2 inner, StackChildLayout childLayout) {
  final out = <LayoutResult>[];

  final alignX = childLayout.alignHorizontal;
  final alignY = childLayout.alignVertical;

  for (final c in node.children) {
    final localSize = c.resolveSize(inner);

    if (alignX == null && alignY == null) {
      out.add(.new(offset: null, size: localSize));
      continue;
    }

    final oriented = c.orientedSize(localSize);
    final shift = c.transformShift(localSize);
    final original = c.box.transform.translation2;

    final x = alignX != null ? alignX.offset(inner.width, oriented.width) - shift.x : original.x;
    final y = alignY != null ? alignY.offset(inner.height, oriented.height) - shift.y : original.y;
    out.add(.new(offset: .new(x, y), size: localSize));
  }

  return out;
}
