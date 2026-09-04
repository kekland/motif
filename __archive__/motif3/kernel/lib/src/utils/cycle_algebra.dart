part of '../kernel.dart';

extension CoedgeWalk on List<Coedge> {
  List<Coedge> get reversedWalk => reversed.map((c) => c.reversed).toList();
}

extension CycleAlgebra on Cycle {
  List<int> occurrencesOf(EdgeHandle e) => [
    for (var i = 0; i < coedges.length; i++)
      if (coedges[i].edge == e) i,
  ];

  List<Coedge> openAt(int i) => [...coedges.sublist(i + 1), ...coedges.sublist(0, i)];

  bool hasEdge(EdgeHandle e) => coedges.any((c) => c.edge == e);
}

extension BoundaryAlgebra on List<Cycle> {
  List<Cycle> dissolveEdge(EdgeHandle edge) {
    final occs = <(int, int)>[
      for (var c = 0; c < length; c++)
        for (final k in this[c].occurrencesOf(edge)) (c, k),
    ];

    assert(occs.length == 2, 'edge must occur exactly twice in the boundary');
    final (c1, i1) = occs[0];
    final (c2, i2) = occs[1];

    final rest = <Cycle>[
      for (var c = 0; c < length; c++)
        if (c != c1 && c != c2) this[c],
    ];

    if (c1 == c2) {
      final coedges = this[c1].coedges;
      final a = coedges.sublist(i1 + 1, i2);
      final b = [...coedges.sublist(i2 + 1), ...coedges.sublist(0, i1)];
      if (coedges[i1].forward != coedges[i2].forward) {
        return [
          ...rest,
          if (a.isNotEmpty) Cycle(a),
          if (b.isNotEmpty) Cycle(b),
        ];
      }

      final reclosed = [...a, ...b.reversedWalk];
      return [...rest, if (reclosed.isNotEmpty) Cycle(reclosed)];
    }

    final r1 = this[c1].openAt(i1);
    final r2 = this[c2].openAt(i2);
    final isOpposite = this[c1][i1].forward != this[c2][i2].forward;
    final sewn = isOpposite ? [...r1, ...r2] : [...r1, ...r2.reversedWalk];
    return [...rest, if (sewn.isNotEmpty) Cycle(sewn)];
  }
}
