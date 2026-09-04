import 'package:program/program.dart';
import 'package:scene3/scene.dart';
import 'package:test/test.dart';

void main() {
  test('can be created', () {
    final program = Program([], .empty());
    final scene = Scene(program: program);

    scene.edit((txn) {
      final v0 = txn.insert(VertexStatement(.zero()));
      final v1 = txn.insert(VertexStatement(.new(1, 0)));
      final v2 = txn.insert(VertexStatement(.new(1, 1)));

      final e0 = txn.insert(EdgeStatement(v0.key.selector(), v1.key.selector()));
      final e1 = txn.insert(EdgeStatement(v1.key.selector(), v2.key.selector()));
      final e2 = txn.insert(EdgeStatement(v2.key.selector(), v0.key.selector()));

      final f0 = txn.insert(FaceStatement(.new([e0.key, e1.key, e2.key])));

      txn.insert(CutEdgeStatement(e0.key.selector(), t: 0.5), anchor: .after(e0.id));
      txn.insert(FilletFaceStatement(f0.key.selector(), radius: .new(0.1, 0.1)));
    });

    print(scene.program.statements);
    final face = scene.program.statements.whereType<FaceStatement>().first;
    print(face.outer.edges);
  });
}
