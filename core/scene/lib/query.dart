import 'package:scene/scene.dart';

export 'query/statement_at.dart';
export 'query/hit_test.dart';

final class SceneQuery {
  SceneQuery(this.scene);

  final Scene scene;
}
