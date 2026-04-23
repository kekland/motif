import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:vgc/vgc.dart';
import 'package:vgc/debug/debug_draw.dart';
import 'package:geometry/geometry.dart';

// -
// Test harness
// -

Widget _harness(VectorComplex complex, {Size size = const Size(200, 200)}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox.fromSize(
          size: size,
          child: CustomPaint(
            painter: _TestPainter(complex),
            size: size,
          ),
        ),
      ),
    ),
  );
}

class _TestPainter extends CustomPainter {
  _TestPainter(this.complex);
  final VectorComplex complex;

  @override
  void paint(Canvas canvas, Size size) => drawDebugVectorComplex(canvas, complex);

  @override
  bool shouldRepaint(covariant _TestPainter old) => old.complex != complex;
}

// Note:
// Tests generated via Claude (Opus 4.7)

void main() {
  group('rendering', () {
    testWidgets('single vertex', (tester) async {
      final c = VectorComplex();
      c.createVertex(Vector2(100, 100));
      await tester.pumpWidget(_harness(c));
      await expectLater(
        find.byType(CustomPaint),
        matchesGoldenFile('goldens/single_vertex.png'),
      );
    });

    testWidgets('square', (tester) async {
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(50, 50));
      final v2 = c.createVertex(Vector2(150, 50));
      final v3 = c.createVertex(Vector2(150, 150));
      final v4 = c.createVertex(Vector2(50, 150));
      c.createOpenEdge(v1, v2);
      c.createOpenEdge(v2, v3);
      c.createOpenEdge(v3, v4);
      c.createOpenEdge(v4, v1);
      await tester.pumpWidget(_harness(c));
      await expectLater(
        find.byType(CustomPaint),
        matchesGoldenFile('goldens/square.png'),
      );
    });

    testWidgets('loop open edge with interior knots', (tester) async {
      final c = VectorComplex();
      final v = c.createVertex(Vector2(100, 100));
      // A rough circle using interior knots; start == end == v.
      c.createOpenEdge(
        v,
        v,
        c1: Vector2(140, 60), // outgoing from start: toward upper-right
        c2: Vector2(60, 60), // incoming to end: from upper-left
        interior: [
          CubicKnot2(Vector2(170, 130), c1: Vector2(170, 90), c2: Vector2(170, 170)),
          CubicKnot2(Vector2(100, 170), c1: Vector2(150, 180), c2: Vector2(50, 180)),
          CubicKnot2(Vector2(30, 130), c1: Vector2(30, 170), c2: Vector2(30, 90)),
        ],
      );
      await tester.pumpWidget(_harness(c));
      await expectLater(
        find.byType(CustomPaint),
        matchesGoldenFile('goldens/loop_open_edge.png'),
      );
    });

    testWidgets('closed edge', (tester) async {
      final c = VectorComplex();
      // Four-knot closed spline approximating a circle.
      final k = 0.5522847498; // cubic Bezier circle constant
      const cx = 100.0, cy = 100.0, r = 50.0;
      c.createClosedEdge(
        CubicSpline2([
          CubicKnot2(Vector2(cx + r, cy), c1: Vector2(cx + r, cy + r * k), c2: Vector2(cx + r, cy - r * k)),
          CubicKnot2(Vector2(cx, cy - r), c1: Vector2(cx + r * k, cy - r), c2: Vector2(cx - r * k, cy - r)),
          CubicKnot2(Vector2(cx - r, cy), c1: Vector2(cx - r, cy - r * k), c2: Vector2(cx - r, cy + r * k)),
          CubicKnot2(Vector2(cx, cy + r), c1: Vector2(cx - r * k, cy + r), c2: Vector2(cx + r * k, cy + r)),
          // Seam: matches first knot position
          CubicKnot2(Vector2(cx + r, cy), c1: Vector2(cx + r, cy + r * k), c2: Vector2(cx + r, cy - r * k)),
        ]),
      );
      await tester.pumpWidget(_harness(c));
      await expectLater(
        find.byType(CustomPaint),
        matchesGoldenFile('goldens/closed_edge.png'),
      );
    });

    testWidgets('Y junction (three edges share a vertex)', (tester) async {
      final c = VectorComplex();
      final center = c.createVertex(Vector2(100, 100));
      final a = c.createVertex(Vector2(100, 30));
      final b = c.createVertex(Vector2(40, 150));
      final d = c.createVertex(Vector2(160, 150));
      c.createOpenEdge(center, a);
      c.createOpenEdge(center, b);
      c.createOpenEdge(center, d);
      await tester.pumpWidget(_harness(c));
      await expectLater(
        find.byType(CustomPaint),
        matchesGoldenFile('goldens/y_junction.png'),
      );
    });

    testWidgets('theta (two edges between same endpoints)', (tester) async {
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(50, 100));
      final v2 = c.createVertex(Vector2(150, 100));
      // Upper arc
      c.createOpenEdge(v1, v2, c1: Vector2(50, 40), c2: Vector2(150, 40));
      // Lower arc
      c.createOpenEdge(v1, v2, c1: Vector2(50, 160), c2: Vector2(150, 160));
      await tester.pumpWidget(_harness(c));
      await expectLater(
        find.byType(CustomPaint),
        matchesGoldenFile('goldens/theta.png'),
      );
    });

    testWidgets('straight line open edge (no handles)', (tester) async {
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(30, 100));
      final v2 = c.createVertex(Vector2(170, 100));
      c.createOpenEdge(v1, v2); // c1, c2 null; interior empty
      await tester.pumpWidget(_harness(c));
      await expectLater(
        find.byType(CustomPaint),
        matchesGoldenFile('goldens/straight_line.png'),
      );
    });
  });

  group('face rendering', () {
    testWidgets('filled triangle', (tester) async {
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(100, 40));
      final v2 = c.createVertex(Vector2(160, 160));
      final v3 = c.createVertex(Vector2(40, 160));
      final e1 = c.createOpenEdge(v1, v2);
      final e2 = c.createOpenEdge(v2, v3);
      final e3 = c.createOpenEdge(v3, v1);
      c.createFace([
        RegularCycle([
          HalfEdge(e1, true),
          HalfEdge(e2, true),
          HalfEdge(e3, true),
        ]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_triangle.png'));
    });

    testWidgets('filled square with reversed halfedges', (tester) async {
      // Same square, but with some halfedges traversed backward.
      // Should look identical to an all-forward square — confirms
      // reverse traversal produces the right geometry.
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(50, 50));
      final v2 = c.createVertex(Vector2(150, 50));
      final v3 = c.createVertex(Vector2(150, 150));
      final v4 = c.createVertex(Vector2(50, 150));
      // Deliberately create edges in "wrong" directions for half of them.
      final e1 = c.createOpenEdge(v1, v2); // forward in cycle
      final e2 = c.createOpenEdge(v2, v3); // forward
      final e3 = c.createOpenEdge(v4, v3); // BACKWARD (edge goes v4->v3, cycle needs v3->v4)
      final e4 = c.createOpenEdge(v1, v4); // BACKWARD (edge goes v1->v4, cycle needs v4->v1)
      c.createFace([
        RegularCycle([
          HalfEdge(e1, true),
          HalfEdge(e2, true),
          HalfEdge(e3, false),
          HalfEdge(e4, false),
        ]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_square_mixed_directions.png'));
    });

    testWidgets('disc from a single closed edge', (tester) async {
      final c = VectorComplex();
      final k = 0.5522847498;
      const cx = 100.0, cy = 100.0, r = 60.0;
      final disc = c.createClosedEdge(
        CubicSpline2([
          CubicKnot2(Vector2(cx + r, cy), c1: Vector2(cx + r, cy + r * k), c2: Vector2(cx + r, cy - r * k)),
          CubicKnot2(Vector2(cx, cy - r), c1: Vector2(cx + r * k, cy - r), c2: Vector2(cx - r * k, cy - r)),
          CubicKnot2(Vector2(cx - r, cy), c1: Vector2(cx - r, cy - r * k), c2: Vector2(cx - r, cy + r * k)),
          CubicKnot2(Vector2(cx, cy + r), c1: Vector2(cx - r * k, cy + r), c2: Vector2(cx + r * k, cy + r)),
          CubicKnot2(Vector2(cx + r, cy), c1: Vector2(cx + r, cy + r * k), c2: Vector2(cx + r, cy - r * k)),
        ]),
      );
      c.createFace([
        RegularCycle([HalfEdge(disc, true)]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_disc.png'));
    });

    testWidgets('square with square hole', (tester) async {
      final c = VectorComplex();
      // Outer square
      final v1 = c.createVertex(Vector2(20, 20));
      final v2 = c.createVertex(Vector2(180, 20));
      final v3 = c.createVertex(Vector2(180, 180));
      final v4 = c.createVertex(Vector2(20, 180));
      final o1 = c.createOpenEdge(v1, v2);
      final o2 = c.createOpenEdge(v2, v3);
      final o3 = c.createOpenEdge(v3, v4);
      final o4 = c.createOpenEdge(v4, v1);
      // Inner square (hole)
      final i1 = c.createVertex(Vector2(70, 70));
      final i2 = c.createVertex(Vector2(130, 70));
      final i3 = c.createVertex(Vector2(130, 130));
      final i4 = c.createVertex(Vector2(70, 130));
      final ie1 = c.createOpenEdge(i1, i2);
      final ie2 = c.createOpenEdge(i2, i3);
      final ie3 = c.createOpenEdge(i3, i4);
      final ie4 = c.createOpenEdge(i4, i1);
      c.createFace([
        RegularCycle([
          HalfEdge(o1, true),
          HalfEdge(o2, true),
          HalfEdge(o3, true),
          HalfEdge(o4, true),
        ]),
        RegularCycle([
          HalfEdge(ie1, true),
          HalfEdge(ie2, true),
          HalfEdge(ie3, true),
          HalfEdge(ie4, true),
        ]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_square_with_hole.png'));
    });

    testWidgets('two adjacent triangles sharing an edge', (tester) async {
      // Both faces reference the shared edge — the most basic VGC-specific
      // configuration (impossible in SVG without edge duplication).
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(100, 30));
      final v2 = c.createVertex(Vector2(170, 150));
      final v3 = c.createVertex(Vector2(30, 150));
      final v4 = c.createVertex(Vector2(100, 180)); // bottom point
      // Shared edge: v2 -> v3
      final shared = c.createOpenEdge(v2, v3);
      final eTopL = c.createOpenEdge(v1, v3);
      final eTopR = c.createOpenEdge(v2, v1);
      final eBotL = c.createOpenEdge(v3, v4);
      final eBotR = c.createOpenEdge(v4, v2);
      // Upper triangle: v1 -> v3 -> v2 -> v1
      c.createFace([
        RegularCycle([
          HalfEdge(eTopL, true), // v1 -> v3
          HalfEdge(shared, false), // v3 -> v2
          HalfEdge(eTopR, true), // v2 -> v1
        ]),
      ]);
      // Lower triangle: v2 -> v3 -> v4 -> v2
      c.createFace([
        RegularCycle([
          HalfEdge(shared, true), // v2 -> v3
          HalfEdge(eBotL, true), // v3 -> v4
          HalfEdge(eBotR, true), // v4 -> v2
        ]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_adjacent_triangles.png'));
    });

    testWidgets('two overlapping translucent faces', (tester) async {
      // Disjoint faces (no shared cells) that overlap geometrically.
      // Verifies depth ordering: second-created face should appear on top.
      final c = VectorComplex();
      // Face A: square top-left
      final a1 = c.createVertex(Vector2(30, 30));
      final a2 = c.createVertex(Vector2(130, 30));
      final a3 = c.createVertex(Vector2(130, 130));
      final a4 = c.createVertex(Vector2(30, 130));
      final ae1 = c.createOpenEdge(a1, a2);
      final ae2 = c.createOpenEdge(a2, a3);
      final ae3 = c.createOpenEdge(a3, a4);
      final ae4 = c.createOpenEdge(a4, a1);
      c.createFace([
        RegularCycle([
          HalfEdge(ae1, true),
          HalfEdge(ae2, true),
          HalfEdge(ae3, true),
          HalfEdge(ae4, true),
        ]),
      ]);
      // Face B: square bottom-right, overlapping A
      final b1 = c.createVertex(Vector2(70, 70));
      final b2 = c.createVertex(Vector2(170, 70));
      final b3 = c.createVertex(Vector2(170, 170));
      final b4 = c.createVertex(Vector2(70, 170));
      final be1 = c.createOpenEdge(b1, b2);
      final be2 = c.createOpenEdge(b2, b3);
      final be3 = c.createOpenEdge(b3, b4);
      final be4 = c.createOpenEdge(b4, b1);
      c.createFace([
        RegularCycle([
          HalfEdge(be1, true),
          HalfEdge(be2, true),
          HalfEdge(be3, true),
          HalfEdge(be4, true),
        ]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_overlapping_translucent.png'));
    });

    testWidgets('face with Steiner cycle', (tester) async {
      // Triangle with an isolated vertex inside, referenced as a Steiner cycle.
      // The vertex should render as a blue dot on top of the fill.
      // The Steiner cycle itself contributes nothing to the fill under even-odd.
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(100, 30));
      final v2 = c.createVertex(Vector2(170, 170));
      final v3 = c.createVertex(Vector2(30, 170));
      final inner = c.createVertex(Vector2(100, 130));
      final e1 = c.createOpenEdge(v1, v2);
      final e2 = c.createOpenEdge(v2, v3);
      final e3 = c.createOpenEdge(v3, v1);
      c.createFace([
        RegularCycle([
          HalfEdge(e1, true),
          HalfEdge(e2, true),
          HalfEdge(e3, true),
        ]),
        SteinerCycle(inner),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_with_steiner.png'));
    });

    testWidgets('face with same edge used twice in one cycle', (tester) async {
      // The Möbius-adjacent case. An open edge from v1 to v2, used forward
      // then backward in a single cycle. Geometrically, this encloses zero
      // area — under even-odd, nothing fills. This is the right answer for
      // a degenerate 2D projection of what would be a non-orientable surface
      // in 3D. The test verifies the renderer doesn't crash and produces
      // a visually empty (or near-empty) region.
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(50, 100));
      final v2 = c.createVertex(Vector2(150, 100));
      final e = c.createOpenEdge(v1, v2, c1: Vector2(80, 40), c2: Vector2(120, 40)); // arched up
      c.createFace([
        RegularCycle([HalfEdge(e, true), HalfEdge(e, false)]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_edge_used_twice.png'));
    });

    testWidgets('disc with Steiner hole vs disc with edge hole', (tester) async {
      // Demonstrates that a Steiner cycle does NOT punch a hole (even-odd,
      // the point contributes zero area), whereas an interior closed edge DOES.
      // Two discs side by side: left has a Steiner point, right has an inner
      // closed edge cycle.
      final c = VectorComplex();
      final k = 0.5522847498;
      // Left disc with Steiner point
      {
        const cx = 60.0, cy = 100.0, r = 45.0;
        final disc = c.createClosedEdge(
          CubicSpline2([
            CubicKnot2(Vector2(cx + r, cy), c1: Vector2(cx + r, cy + r * k), c2: Vector2(cx + r, cy - r * k)),
            CubicKnot2(Vector2(cx, cy - r), c1: Vector2(cx + r * k, cy - r), c2: Vector2(cx - r * k, cy - r)),
            CubicKnot2(Vector2(cx - r, cy), c1: Vector2(cx - r, cy - r * k), c2: Vector2(cx - r, cy + r * k)),
            CubicKnot2(Vector2(cx, cy + r), c1: Vector2(cx - r * k, cy + r), c2: Vector2(cx + r * k, cy + r)),
            CubicKnot2(Vector2(cx + r, cy), c1: Vector2(cx + r, cy + r * k), c2: Vector2(cx + r, cy - r * k)),
          ]),
        );
        final steiner = c.createVertex(Vector2(cx, cy));
        c.createFace([
          RegularCycle([HalfEdge(disc, true)]),
          SteinerCycle(steiner),
        ]);
      }
      // Right disc with inner closed edge (real hole)
      {
        const cx = 140.0, cy = 100.0, r = 45.0;
        final outer = c.createClosedEdge(
          CubicSpline2([
            CubicKnot2(Vector2(cx + r, cy), c1: Vector2(cx + r, cy + r * k), c2: Vector2(cx + r, cy - r * k)),
            CubicKnot2(Vector2(cx, cy - r), c1: Vector2(cx + r * k, cy - r), c2: Vector2(cx - r * k, cy - r)),
            CubicKnot2(Vector2(cx - r, cy), c1: Vector2(cx - r, cy - r * k), c2: Vector2(cx - r, cy + r * k)),
            CubicKnot2(Vector2(cx, cy + r), c1: Vector2(cx - r * k, cy + r), c2: Vector2(cx + r * k, cy + r)),
            CubicKnot2(Vector2(cx + r, cy), c1: Vector2(cx + r, cy + r * k), c2: Vector2(cx + r, cy - r * k)),
          ]),
        );
        const ir = 15.0;
        final inner = c.createClosedEdge(
          CubicSpline2([
            CubicKnot2(Vector2(cx + ir, cy), c1: Vector2(cx + ir, cy + ir * k), c2: Vector2(cx + ir, cy - ir * k)),
            CubicKnot2(Vector2(cx, cy - ir), c1: Vector2(cx + ir * k, cy - ir), c2: Vector2(cx - ir * k, cy - ir)),
            CubicKnot2(Vector2(cx - ir, cy), c1: Vector2(cx - ir, cy - ir * k), c2: Vector2(cx - ir, cy + ir * k)),
            CubicKnot2(Vector2(cx, cy + ir), c1: Vector2(cx - ir * k, cy + ir), c2: Vector2(cx + ir * k, cy + ir)),
            CubicKnot2(Vector2(cx + ir, cy), c1: Vector2(cx + ir, cy + ir * k), c2: Vector2(cx + ir, cy - ir * k)),
          ]),
        );
        c.createFace([
          RegularCycle([HalfEdge(outer, true)]),
          RegularCycle([HalfEdge(inner, true)]),
        ]);
      }
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_steiner_vs_edge_hole.png'));
    });

    testWidgets('nested alternating cycles', (tester) async {
      // Three concentric squares as a single face. Under even-odd:
      // outermost ring filled, middle ring empty, innermost ring filled.
      // This is a direct test of "cycles all contribute, no role labels".
      final c = VectorComplex();
      final radii = [90.0, 60.0, 30.0];
      final cycles = <RegularCycle>[];
      for (final r in radii) {
        final v1 = c.createVertex(Vector2(100 - r, 100 - r));
        final v2 = c.createVertex(Vector2(100 + r, 100 - r));
        final v3 = c.createVertex(Vector2(100 + r, 100 + r));
        final v4 = c.createVertex(Vector2(100 - r, 100 + r));
        final e1 = c.createOpenEdge(v1, v2);
        final e2 = c.createOpenEdge(v2, v3);
        final e3 = c.createOpenEdge(v3, v4);
        final e4 = c.createOpenEdge(v4, v1);
        cycles.add(
          RegularCycle([
            HalfEdge(e1, true),
            HalfEdge(e2, true),
            HalfEdge(e3, true),
            HalfEdge(e4, true),
          ]),
        );
      }
      c.createFace(cycles);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_nested_alternating.png'));
    });

    testWidgets('figure-eight via self-crossing geometry', (tester) async {
      // A single closed edge whose geometry crosses itself to form a
      // figure-eight. Under even-odd, each lobe fills; the crossing
      // region fills or doesn't depending on exact geometry. Verifies
      // that self-intersecting splines don't break face rendering.
      final c = VectorComplex();
      final loop = c.createClosedEdge(
        CubicSpline2([
          CubicKnot2(Vector2(100, 100), c2: Vector2(140, 50)),
          CubicKnot2(Vector2(180, 100), c1: Vector2(180, 50), c2: Vector2(180, 150)),
          CubicKnot2(Vector2(100, 100), c1: Vector2(140, 150), c2: Vector2(60, 50)),
          CubicKnot2(Vector2(20, 100), c1: Vector2(20, 50), c2: Vector2(20, 150)),
          CubicKnot2(Vector2(100, 100), c1: Vector2(60, 150)),
        ]),
      );
      c.createFace([
        RegularCycle([HalfEdge(loop, true)]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_figure_eight.png'));
    });

    testWidgets('two faces sharing an edge, different depths', (tester) async {
      // Same as "two adjacent triangles" but we care about depth ordering
      // of the shared edge relative to the faces. Create the faces first,
      // then verify the shared edge (in `directStar` of both faces) is
      // rendered on top because its depth is above both faces.
      // Note: this is implicit in `_insertWithDefaultDepth` — edges are
      // inserted below vertices but above faces once faces exist.
      // Actually — edges are created BEFORE faces in our API, so they end
      // up below. This test confirms the stacking is what you expect.
      final c = VectorComplex();
      final v1 = c.createVertex(Vector2(100, 30));
      final v2 = c.createVertex(Vector2(170, 150));
      final v3 = c.createVertex(Vector2(30, 150));
      final v4 = c.createVertex(Vector2(100, 200));
      final eBotL = c.createOpenEdge(v3, v4);
      final eBotR = c.createOpenEdge(v4, v2);
      final shared = c.createOpenEdge(v2, v3);
      c.createFace([
        RegularCycle([
          HalfEdge(shared, true),
          HalfEdge(eBotL, true),
          HalfEdge(eBotR, true),
        ]),
      ]);

      final eTopL = c.createOpenEdge(v1, v3);
      final eTopR = c.createOpenEdge(v2, v1);
      c.createFace([
        RegularCycle([
          HalfEdge(eTopL, true),
          HalfEdge(shared, false),
          HalfEdge(eTopR, true),
        ]),
      ]);
      await tester.pumpWidget(_harness(c));
      await expectLater(find.byType(CustomPaint), matchesGoldenFile('goldens/face_stacking_single_triangle.png'));
    });
  });
}
