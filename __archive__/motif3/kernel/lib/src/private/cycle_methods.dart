part of '../kernel.dart';

extension TopologyBundleCycle on TopologyBundle {
  Cycle _cycleFor(Iterable<CoedgeIndex> cycle) {
    final out = <Coedge>[];
    for (final ce in cycle) out.add(_coedgeAt(ce));
    return .new(out);
  }

  Iterable<CoedgeIndex> _cycleCoedges(CoedgeIndex head) sync* {
    var i = head;
    do {
      yield i;
      i = _coedge.cycleNext[i];
    } while (i != head);
  }

  Cycle _addCycle(FaceHandle face, Cycle cycle) {
    assert(_checkFace(face));
    assert(cycle.isNotEmpty, 'cannot add empty cycle');

    final fi = face.index;
    final coedges = <CoedgeIndex>[];

    for (final ce in cycle) coedges.add(_addCoedge(ce.edge.index, ce.forward, fi));
    for (var i = 0; i < coedges.length; i++) {
      _coedge.cycleNext[coedges[i]] = coedges[(i + 1) % coedges.length];
    }

    _face.boundary[fi].add(coedges.first);
    return cycle;
  }

  void _removeCycle(FaceIndex face, CoedgeIndex head) {
    final cycle = _cycleCoedges(head).toList();
    for (final ce in cycle) _removeCoedge(ce);
    _face.boundary[face].remove(head);
  }

  void _spliceCycle(FaceHandle face, List<Coedge> remove, List<Coedge> insert) {
    assert(_checkFace(face));
    assert(remove.isNotEmpty && insert.isNotEmpty, 'remove and insert must be non-empty');

    final faceIndex = face.index;
    CoedgeIndex startC = .none;

    for (final c in _edgeRadial(remove.first.edge.index)) {
      if (_coedge.face[c] == faceIndex && _coedge.direction[c] == remove.first.forward) {
        startC = c;
        break;
      }
    }

    assert(startC.isNotNone, 'face cycle does not contain the provided run');

    final slots = <CoedgeIndex>[startC];
    var curr = startC;
    for (var k = 1; k < remove.length; k++) {
      curr = _coedge.cycleNext[curr];
      slots.add(curr);

      assert(() {
        final expected = remove[k];
        return _coedge.edge[curr] == expected.edge.index && _coedge.direction[curr] == expected.forward;
      }(), 'face cycle does not match the provided run');
    }

    final next = _coedge.cycleNext[curr];

    final newCoedges = <CoedgeIndex>[];
    for (final ce in insert) newCoedges.add(_addCoedge(ce.edge.index, ce.forward, faceIndex));
    for (var i = 0; i < newCoedges.length - 1; i++) {
      _coedge.cycleNext[newCoedges[i]] = newCoedges[i + 1];
    }

    if (next == startC) {
      _coedge.cycleNext[newCoedges.last] = newCoedges.first;
    } else {
      var prev = next;
      while (_coedge.cycleNext[prev] != startC) {
        prev = _coedge.cycleNext[prev];
      }

      _coedge.cycleNext[prev] = newCoedges.first;
      _coedge.cycleNext[newCoedges.last] = next;
    }

    final cycles = _face.boundary[faceIndex];
    final inRun = slots.toSet();
    for (var i = 0; i < cycles.length; i++) {
      if (inRun.contains(cycles[i])) cycles[i] = newCoedges.first;
    }

    for (final c in slots) _removeCoedge(c);
  }

  int _cycleWinding(Cycle cycle, Vec2 p) {
    var winding = 0;

    for (final u in cycle) {
      final w = _edgeCubicWorld(u.edge.index).winding(p);
      winding += u.forward ? w : -w;
    }

    return winding;
  }
}
