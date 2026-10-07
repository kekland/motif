import 'package:kernel/kernel.dart';
import 'package:scene/scene.dart';

export 'query/hit_test.dart';

final class SceneQuery {
  SceneQuery(this.scene);

  final Scene scene;
  Bundle get bundle => scene.bundle;
}
