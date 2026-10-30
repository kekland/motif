import 'package:renderer2/renderer.dart';

final class GeometryStorage extends CompositeStorage {
  new()
    : super([
        Mat4UnitStorage(),
        Mat4UnitStorage(),
        Vec2UnitStorage(),
        Vec2UnitStorage(),
        Cubic2UnitStorage(),
      ]);

  late final frame = storages[0] as Mat4UnitStorage;
  late final frameInverse = storages[1] as Mat4UnitStorage;
  late final vertex = storages[2] as Vec2UnitStorage;
  late final covertex = storages[3] as Vec2UnitStorage;
  late final edge = storages[4] as Cubic2UnitStorage;

  int get frameOffset => offsetFor(0);
  int get frameInverseOffset => offsetFor(1);
  int get vertexOffset => offsetFor(2);
  int get covertexOffset => offsetFor(3);
  int get edgeOffset => offsetFor(4);
}
