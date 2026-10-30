import 'package:renderer2/renderer.dart';
import 'package:renderer2/src/shaders/structs.g.dart' as gen;

// dart format off

final class VertexStyleStorage extends UnitStorage<gen.VertexStyle> {
  @override int get elementSizeInBytes => gen.VertexStyle.unpaddedSizeInBytes;
  @override gen.VertexStyle get(int offset) => .read(data, offset);
  @override void set(int offset, gen.VertexStyle value) => value.write(data, offset);
}

final class EdgeStyleStorage extends UnitStorage<gen.EdgeStyle> {
  @override int get elementSizeInBytes => gen.EdgeStyle.unpaddedSizeInBytes;
  @override gen.EdgeStyle get(int offset) => .read(data, offset);
  @override void set(int offset, gen.EdgeStyle value) => value.write(data, offset);
}

final class FaceStyleStorage extends UnitStorage<gen.FaceStyle> {
  @override int get elementSizeInBytes => gen.FaceStyle.unpaddedSizeInBytes;
  @override gen.FaceStyle get(int offset) => .read(data, offset);
  @override void set(int offset, gen.FaceStyle value) => value.write(data, offset);
}

// dart format on

final class StyleStorage extends CompositeStorage {
  new() : super([VertexStyleStorage(), EdgeStyleStorage(), FaceStyleStorage()]);

  late final vertex = storages[0] as VertexStyleStorage;
  late final edge = storages[1] as EdgeStyleStorage;
  late final face = storages[2] as FaceStyleStorage;

  int get vertexOffset => offsetFor(0);
  int get edgeOffset => offsetFor(1);
  int get faceOffset => offsetFor(2);
}
