import 'package:debug/kernel/scenes/simulation.dart';

final class SceneSimulationAutoLayout extends SceneSimulation {
  List<StatementId> rectangles = [];

  @override
  Scene initialize() {
    final scene = Scene.empty();
    rectangles = [];

    scene.edit((txn) {
      var container = ContainerStatement(
        layout: .flex(
          direction: .row,
          crossAlign: .center,
          gap: 8.0,
          padding: .all(16.0),
        ),
        size: .contain(),
      );

      // container = container.copyWith(modifiers: [FilletFace(container.face.selector(), radius: .new(8, 8))]);

      txn.insert(container);

      for (var i = 0; i < 20; i++) {
        final rectangle = RectangleStatement(
          size: .fixed(100, 100),
          transform: .translation(0, 0),
          parent: container.frame,
        );

        final fillet = FilletFaceStatement(rectangle.face.selector(), radius: .new(8, 8));

        txn.insert(rectangle);
        txn.attach(rectangle.id, fillet);
        rectangles.add(rectangle.id);
      }
    });

    return scene;
  }

  @override
  void update(Scene scene, double t) {
    scene.edit((txn) {
      for (final (i, rectangle) in rectangles.indexed) {
        // Rotate rectangles based on index
        final angle = (t * 2 * 3.14159) + (i * 0.5);
        final scale = 1.0 + 0.5 * t + (i.isEven ? 1.0 * t : 0.25 * t);
        txn.update<RectangleStatement>(rectangle, (s) => s.copyWith(transform: .rotationZ(angle)..scale(scale, scale)));
      }
    });
  }
}
