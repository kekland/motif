import 'package:debug/kernel/scenes/simulation.dart';

final class SceneSimulationShapes extends SceneSimulation {
  List<StatementId> rectangles = [];

  @override
  Scene initialize() {
    final scene = Scene.empty();
    rectangles = [];

    scene.edit((txn) {
      const n = 2;
      for (var xi = -n; xi <= n; xi++) {
        for (var yi = -n; yi <= n; yi++) {
          final xo = xi * 200.0, yo = yi * 100.0;

          final rectangle = RectangleStatement(size: .fixed(200, 100), transform: .translation(xo, yo));
          final modifier = FilletFaceStatement(rectangle.face.selector(), radius: .new(8, 8));
          txn.insert(rectangle);
          txn.attach(rectangle.id, modifier);
          rectangles.add(rectangle.id);
        }
      }
    });

    return scene;
  }

  @override
  void update(Scene scene, double t) {
    scene.edit((txn) {
      for (final rectangle in rectangles) {
        // var fillet = scene.program.statement(rectangle)!.modifiers.first as FilletFaceStatement;
        // fillet = fillet.copyWith(radius: .new(50.0 * t, 50.0 * t));

        // txn.update<RectangleStatement>(rectangle, (s) => s.copyWith(modifiers: [fillet]));
      }
    });
  }
}
