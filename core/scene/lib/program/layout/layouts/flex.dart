part of '../../program.dart';

Size2 _measureFlex(_Node node, FlexChildLayout childLayout) {
  final children = node.children;
  final dir = childLayout.direction;
  final gap = childLayout.gap;

  var main = 0.0, cross = 0.0;
  for (final c in children) {
    main += dir.mainOfSize(c.orientedNatural);
    cross = math.max(cross, dir.crossOfSize(c.orientedNatural));
  }

  if (children.isNotEmpty) main += gap * (children.length - 1);
  return dir.size(main: main, cross: cross).hull(node.box.naturalSize);
}

List<LayoutResult> _placeFlex(_Node node, Size2 inner, FlexChildLayout childLayout) {
  final gap = childLayout.gap;
  final dir = childLayout.direction;
  final n = node.children.length;
  final innerMain = dir.mainOfSize(inner);
  final innerCross = dir.crossOfSize(inner);
  final gapTotal = n > 1 ? childLayout.gap * (n - 1) : 0.0;

  final mains = List<double>.filled(n, 0.0);
  final crosses = List<double>.filled(n, 0.0);
  final flexible = <int>[];

  var used = gapTotal;

  for (var i = 0; i < n; i++) {
    final c = node.children[i];
    final main = dir.mainOf(c.box.size);

    crosses[i] = c.resolve(dir.crossOf(c.box.size), dir.crossOfSize(c.orientedNatural), innerCross);
    if (main.isExpand) {
      flexible.add(i);
    } else {
      mains[i] = c.resolve(main, dir.mainOfSize(c.orientedNatural), innerMain);
      used += mains[i];
    }
  }

  if (flexible.isNotEmpty) {
    final share = math.max(0.0, innerMain - used) / flexible.length;
    for (final i in flexible) {
      mains[i] = dir.mainOf(node.children[i].box.size).clamp(share);
    }
  }

  var consumed = gapTotal;
  for (final m in mains) consumed += m;

  final slack = innerMain - consumed;
  final (start, between) = switch (childLayout.justify) {
    .start => (0.0, gap),
    .center => (slack / 2.0, gap),
    .end => (slack, gap),
    .spaceBetween => n > 1 ? (0.0, gap + slack / (n - 1)) : (0.0, gap),
  };

  final out = <LayoutResult>[];
  var cursor = start;
  for (var i = 0; i < n; i++) {
    final c = node.children[i];
    final main = mains[i];
    final cross = crosses[i];

    final cursorOffset = dir.vec(main: cursor, cross: childLayout.crossAlign.offset(innerCross, cross));
    final localSize = c.resolveSize(dir.size(main: main, cross: cross));
    final offset = cursorOffset - c.transformShift(localSize);

    out.add(.new(offset: offset, size: localSize));
    cursor += main + between;
  }

  return out;
}
