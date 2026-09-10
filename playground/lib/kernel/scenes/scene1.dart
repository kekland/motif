import 'package:debug/kernel/scenes/simulation.dart';

final class SceneSimulationStarsFillets extends SceneSimulation {
  var frames = <StatementId>[];
  var fillets = <StatementId>[];
  var origins = <Vec2>[];

  @override
  Scene initialize() {
    final scene = Scene(program: Program([]));
    frames = [];
    origins = [];
    fillets = [];
    scene.edit((txn) {
      const n = 3;
      for (var xi = -n; xi <= n; xi++) {
        for (var yi = -n; yi <= n; yi++) {
          const points = [
            (250.0, 50.0),
            (284.4, 166.9),
            (391.4, 108.6),
            (333.1, 215.6),
            (450.0, 250.0),
            (333.1, 284.4),
            (391.4, 391.4),
            (284.4, 333.1),
            (250.0, 450.0),
            (215.6, 333.1),
            (108.6, 391.4),
            (166.9, 284.4),
            (50.0, 250.0),
            (166.9, 215.6),
            (108.6, 108.6),
            (215.6, 166.9),
          ];

          final xo = xi * 300.0, yo = yi * 300.0;

          final frame = txn.insert(FrameStatement(transform: .translation(xo, yo)));
          origins.add(.new(xo, yo));
          frames.add(frame.id);

          final vs = [for (final (x, y) in points) txn.insert(VertexStatement(.new(x, y), parent: frame.ref))];
          final es = [
            for (var i = 0; i < vs.length; i++)
              txn.insert(
                EdgeStatement(vs[i].ref.selector(), vs[(i + 1) % vs.length].ref.selector(), parent: frame.ref),
              ),
          ];
          final f = txn.insert(FaceStatement(.new([for (final e in es) e.ref]), parent: frame.ref));

          final fillet = txn.insert(FilletFaceStatement(f.ref.selector(), radius: .new(10, 10)));
          fillets.add(fillet.id);
          // txn.dissolve([vs.first.ref]);
        }
      }
    });

    return scene;
  }

  @override
  void update(Scene scene, double t) {
    // scene.edit((txn) {
    //   for (var i = 0; i < frames.length; i++) {
    //     final origin = origins[i];
    //     final rotation = 2 * 3.141592653589793 * t;
    //     final scale = 1.0 + 2.5 * t;
    //     txn.update<Frame>(frames[i], (s) {
    //       final t = Mat4.identity()
    //         ..translate(225, 225)
    //         ..rotateZ(rotation)
    //         ..scale(scale, scale)
    //         ..translate(-225, -225)
    //         ..translate2(origin);
    //       return s.copyWith(transform: t);
    //     });
    //   }
    // });

    scene.edit((txn) {
      for (final f in fillets) {
        final radius = 27.0 * t;
        txn.update<FilletFaceStatement>(f, (s) => s.copyWith(radius: .new(radius, radius)));
      }
    });
  }
}
