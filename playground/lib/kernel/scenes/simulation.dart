import 'package:renderer/renderer.dart';
import 'package:scene/scene.dart';

export 'package:geometry/geometry.dart';
export 'package:program/program.dart';
export 'package:scene/scene.dart';

abstract class SceneSimulation {
  SceneSimulation() {
    scene = initialize();
    renderer = .new(scene.evaluation);
  }

  late Scene scene;
  late ProgramRenderer renderer;

  Scene initialize();
  void update(Scene scene, double t);

  void dispose() {
    renderer.dispose();
    scene.dispose();
  }
}
