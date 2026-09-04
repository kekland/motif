part of 'kernel.dart';

final class ValidationIssue {
  ValidationIssue(this.message);

  final String message;

  @override
  String toString() => message;
}

extension TopologyBundleValidation on TopologyBundle {
  List<ValidationIssue> _validateBundle() {
    final issues = <ValidationIssue>[];
    void _fail(String message) => issues.add(ValidationIssue(message));

    // Arena and identifier consistency
    {
      void checkIds<I extends ElementIndex, H, T extends ArenaStorage<I, H, T>>(
        ArenaStorage<I, H, T> arena,
        IdTable table,
        String kind,
      ) {
        for (final i in arena.liveIndices) {
          final id = table.maybeOf(i);
          if (id == null) {
            _fail('$kind slot $i alive but has no id');
          } else if (table.indexOf(id) != i) {
            _fail('$kind slot $i maps to ${table.indexOf(id)}, expected $i');
          }
        }
      }

      checkIds(_vertex, _vertex.id, 'vertex');
      checkIds(_edge, _edge.id, 'edge');
      checkIds(_face, _face.id, 'face');
    }

    {
      for (final e in _edge.liveIndices) {
        final name = _edge.id.maybeOf(e) ?? '#$e';
        void fail(message) => _fail('edge $name: $message');

        final v0 = _edge.vStart[e], v1 = _edge.vEnd[e];
        if (!_vertex.isAliveAt(v0)) fail('start vertex $v0 is not alive');
        if (!_vertex.isAliveAt(v1)) fail('end vertex $v1 is not alive');

        final cv0 = _edge.cvStart[e], cv1 = _edge.cvEnd[e];
        for (final (cv, label, isStart) in [(cv0, 'start', true), (cv1, 'end', false)]) {
          if (!_covertex.isAliveAt(cv)) {
            fail('covertex $label $cv is not alive');
            continue;
          }

          if (_covertex.edge[cv] != e) fail('covertex $label $cv does not point to edge $e');
          if (_covertex.isStart[cv] != isStart) fail('covertex $label $cv has wrong isStart value');
        }

        if (cv0 == cv1) fail('start and end covertex are the same: $cv0');
        if (_covertex.isAliveAt(cv0) && _covertex.vertex[cv0] != v0) {
          fail('cached vertex $v0 doesn\'t match covertex start vertex ${_covertex.vertex[cv0]}');
        }
        if (_covertex.isAliveAt(cv1) && _covertex.vertex[cv1] != v1) {
          fail('cached vertex $v1 doesn\'t match covertex end vertex ${_covertex.vertex[cv1]}');
        }
      }
    }

    // Covertex checks
    {
      if (_covertex.liveCount != _edge.liveCount * 2) {
        _fail('covertex live count mismatch: expected ${_edge.liveCount * 2}, found ${_covertex.liveCount}');
      }

      for (final cv in _covertex.liveIndices) {
        if (!_edge.isAliveAt(_covertex.edge[cv])) {
          _fail('covertex $cv points to dead edge ${_covertex.edge[cv]}');
        }
        if (!_vertex.isAliveAt(_covertex.vertex[cv])) {
          _fail('covertex $cv points to dead vertex ${_covertex.vertex[cv]}');
        }
      }
    }

    // Covertex list checks
    {
      final cvSeen = <CovertexIndex>{};
      for (final v in _vertex.liveIndices) {
        var cv = _vertex.diskStart[v];
        var guard = 0;

        while (cv != kNone) {
          if (guard++ > _covertex.top + 1) {
            _fail('covertex list for vertex $v does not terminate');
            break;
          }

          if (!_covertex.isAliveAt(cv)) {
            _fail('covertex list for vertex $v contains dead covertex $cv');
            break;
          }

          if (_covertex.vertex[cv] != v) {
            _fail('covertex list for vertex $v contains covertex $cv pointing to vertex ${_covertex.vertex[cv]}');
            break;
          }

          if (!cvSeen.add(cv)) {
            _fail('vertex $v revisits covertex $cv');
            break;
          }

          cv = _covertex.diskNext[cv];
        }
      }

      for (final cv in _covertex.liveIndices) {
        if (!cvSeen.contains(cv)) {
          _fail('covertex $cv is not reachable from its vertex ${_covertex.vertex[cv]}');
        }
      }
    }

    // Coedge checks
    {
      for (final c in _coedge.liveIndices) {
        if (!_edge.isAliveAt(_coedge.edge[c])) {
          _fail('coedge $c points to dead edge ${_coedge.edge[c]}');
        }
        if (!_face.isAliveAt(_coedge.face[c])) {
          _fail('coedge $c points to dead face ${_coedge.face[c]}');
        }
      }
    }

    // Cycle lists
    {
      final cycleSeen = <CoedgeIndex>{};
      for (final e in _edge.liveIndices) {
        final name = _edge.id.maybeOf(e) ?? '#$e';
        void fail(message) => _fail('edge $name: $message');

        final seenLocal = <CoedgeIndex>{};
        var c = _edge.radialStart[e];
        var guard = 0;

        while (c != kNone) {
          if (guard++ > _coedge.top + 1) {
            fail('coedge list does not terminate');
            break;
          }

          if (!_coedge.isAliveAt(c)) {
            fail('coedge list contains dead coedge $c');
            break;
          }

          if (_coedge.edge[c] != e) {
            fail('coedge list contains coedge $c pointing to edge ${_coedge.edge[c]}');
            break;
          }

          if (!seenLocal.add(c)) {
            fail('coedge list revisits coedge $c');
            break;
          }

          c = _coedge.radialNext[c];
        }

        cycleSeen.addAll(seenLocal);
      }

      for (final c in _coedge.liveIndices) {
        if (!cycleSeen.contains(c)) {
          _fail('coedge $c is not reachable from its edge ${_coedge.edge[c]}');
        }
      }
    }

    // Face checks
    {
      final coedgeSeen = <CoedgeIndex>{};
      for (final f in _face.liveIndices) {
        final name = _face.id.maybeOf(f) ?? '#$f';
        void fail(message) => _fail('face $name: $message');
        final cycles = _face.boundary[f];
        if (cycles.isEmpty) {
          fail('face has no cycles');
          continue;
        }

        for (final head in cycles) {
          var c = head;
          var guard = 0;
          var prevEnd = VertexIndex.none;
          var firstStart = VertexIndex.none;
          var closed = true;

          do {
            if (guard++ > _coedge.top + 1) {
              fail('cycle at $head does not terminate');
              closed = false;
              break;
            }

            if (!_coedge.isAliveAt(c)) {
              fail('cycle at $head contains dead coedge $c');
              closed = false;
              break;
            }

            if (_coedge.face[c] != f) {
              fail('cycle at $head contains coedge $c pointing to face ${_coedge.face[c]}');
            }

            if (!coedgeSeen.add(c)) {
              fail('cycle at $head revisits coedge $c');
            }

            final e = _coedge.edge[c];
            if (_edge.isAliveAt(e)) {
              final fwd = _coedge.direction[c];
              final vStart = fwd ? _edge.vStart[e] : _edge.vEnd[e];
              final vEnd = fwd ? _edge.vEnd[e] : _edge.vStart[e];
              if (firstStart == kNone) firstStart = vStart;
              if (prevEnd != kNone && vStart != prevEnd) {
                fail('cycle at $head has non-contiguous edges: $prevEnd -> $vStart');
              }
              prevEnd = vEnd;
            }

            c = _coedge.cycleNext[c];
          } while (c != head);

          if (closed && prevEnd != kNone && prevEnd != firstStart) {
            fail('cycle at $head is not closed: $prevEnd -> $firstStart');
          }
        }
      }

      for (final c in _coedge.liveIndices) {
        if (!coedgeSeen.contains(c)) {
          _fail('coedge $c is not reachable from its face ${_coedge.face[c]}');
        }
      }
    }

    return issues;
  }
}
