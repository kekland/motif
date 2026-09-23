part of '../kernel.dart';

extension LcaQuery on TopologyQuery {
  FrameRef lca(CellRef a, CellRef b) {
    final ha = bundle.handle(a);
    final hb = bundle.handle(b);
    if (ha == null || hb == null) throw StateError('no handles for $a or $b');

    final f = bundle.lca(ha, hb);
    return bundle.frameRef(f);
  }

  FrameRef lcaMany(List<CellRef> cells) {
    if (cells.isEmpty) return .root;
    final handles = cells.map(bundle.handle).toList();
    if (handles.any((h) => h == null)) throw StateError('no handles for some cells');
    final f = bundle.lcaMany(handles.cast());
    return bundle.frameRef(f);
  }
}
