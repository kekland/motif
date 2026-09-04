import 'package:geometry/geometry.dart';
import 'package:scene/program/program.dart';
import 'package:test/test.dart';

void main() {
  group('basic statements', () {
    test('vertices and edges build and bind', () {
      final builder = ProgramBuilder();
      final v1 = builder.vertex(.new(0, 0));
      final v2 = builder.vertex(.new(100, 0));
      final e = builder.edge(v1, v2);

      final program = builder.build();
      final eval = dryExecute(program);
      final bundle = eval.bundle;

      expect(bundle.vertices.length, 2);
      expect(bundle.edges.length, 1);
      expect(bundle.validate(), isEmpty);

      final edge = eval.edge(e)!;
      expect(bundle.vertexPosition(bundle.edgeStart(edge)).equals(.new(0, 0)), isTrue);
      expect(bundle.vertexPosition(bundle.edgeEnd(edge)).equals(.new(100, 0)), isTrue);
    });

    test('frame transform applies to children', () {
      final builder = ProgramBuilder();
      final g = builder.frame(Mat4.translation(100, 200));
      final v = builder.vertex(Vec2(1, 2), parent: g);

      final eval = dryExecute(builder.build());

      final h = eval.vertex(v)!;
      expect(eval.bundle.vertexPositionWorld(h).x, closeTo(101, 1e-9));
      expect(eval.bundle.vertexPositionWorld(h).y, closeTo(202, 1e-9));
    });

    test('unresolved ref suppresses; rest of program intact', () {
      final v1 = VertexStatement(Vec2(0, 0));
      final v2 = VertexStatement(Vec2(10, 0));
      final e = EdgeStatement(v1.vertex, v2.vertex);

      final eval = dryExecute(Program([v1, e, v2]));

      expect(eval.edge(e.edge), isNull, reason: 'edge suppressed');
      expect(eval.bundle.vertices.length, 2);
      expect(eval.bundle.validate(), isEmpty, reason: 'rollback was clean');
    });
  });
}
