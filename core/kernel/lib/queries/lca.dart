part of '../kernel.dart';

extension LcaQuery on TopologyQuery {
  FrameRef lca(CellRef a, CellRef b) {
    final ha = bundle.handle(a);
    final hb = bundle.handle(b);
    if (ha == null || hb == null) throw StateError('no handles for $a or $b');

    final f = bundle.lca(ha, hb);
    return bundle.frameRef(f);
  }
}
