part of '../renderer.dart';

final class StyleManager {
  new(this.renderer);

  final Renderer renderer;
  Scene get scene => renderer.scene;
  Bundle get bundle => scene.bundle;

  late final buffer = GpuStorageBuffer(renderer.device!, storage, label: 'geometry');
  late final storage = StyleStorage();

  late final _cache = <CellIndex, (List<PreparedDecoration>, DataSpan)>{};
  Iterable<PreparedDecoration> decorationsOf(CellIndex index) => _cache[index]?.$1 ?? const [];

  void update(CellRef ref, CellHandle handle) {
    final i = handle.rawIndex;

    final style = scene.styleOf(ref);

    if (style is VertexStyle) {
      final incident = bundle.vertexEdges(handle.asVertex).map(bundle.edgeRef).firstOrNull;
      if (incident == null) return;

      final edgeStyle = scene.styleOf(incident)?.asEdge;
      if (edgeStyle == null) return;

      final previousSpan = storage.vertex[i]?.decorationSpan;
      final (decorations, span) = renderer.decoration.put(
        edgeStyle.decorations,
        span: .maybeFrom(previousSpan),
        ref: ref,
      );
      storage.vertex[i] = .new(decorationSpan: span);
      _cache[handle.cellIndex] = (decorations, span);
    } else if (style is EdgeStyle) {
      final previousSpan = storage.edge[i]?.decorationSpan;
      final (decorations, span) = renderer.decoration.put(style.decorations, span: .maybeFrom(previousSpan), ref: ref);
      storage.edge[i] = .new(decorationSpan: span, width: style.width);
      _cache[handle.cellIndex] = (decorations, span);

      // Update adjacent vertices
      final vertexHandles = bundle.edgeVertices(handle.asEdge);
      for (final h in vertexHandles) update(bundle.vertexRef(h), h);
    } else if (style is FaceStyle) {
      final previousSpan = storage.face[i]?.decorationSpan;
      final (decorations, span) = renderer.decoration.put(style.decorations, span: .maybeFrom(previousSpan), ref: ref);
      storage.face[i] = .new(decorationSpan: span);
      _cache[handle.cellIndex] = (decorations, span);
    }
  }

  void release(CellIndex index) {
    final value = _cache.remove(index);
    if (value == null) return;

    final (_, span) = value;
    renderer.decoration.release(span);
  }

  bool upload() => buffer.upload(renderer.queue);
}

final class StyleStorage extends CompositeStorage {
  new() : super([VertexStyleUnitStorage(), EdgeStyleUnitStorage(), FaceStyleUnitStorage()]);

  late final vertex = storages[0] as VertexStyleUnitStorage;
  late final edge = storages[1] as EdgeStyleUnitStorage;
  late final face = storages[2] as FaceStyleUnitStorage;

  int get vertexOffsetInBytes => offsetFor(0);
  int get edgeOffsetInBytes => offsetFor(1);
  int get faceOffsetInBytes => offsetFor(2);
}

// dart format off
final class VertexStyleUnitStorage extends UnitStorage<gen.VertexStyle> {
  @override int get elementSizeInBytes => gen.VertexStyle.unpaddedSizeInBytes;
  @override gen.VertexStyle get(int offset) => .read(data, offset);
  @override void set(int offset, gen.VertexStyle value) => value.write(data, offset);
}

final class EdgeStyleUnitStorage extends UnitStorage<gen.EdgeStyle> {
  @override int get elementSizeInBytes => gen.EdgeStyle.unpaddedSizeInBytes;
  @override gen.EdgeStyle get(int offset) => .read(data, offset);
  @override void set(int offset, gen.EdgeStyle value) => value.write(data, offset);
}

final class FaceStyleUnitStorage extends UnitStorage<gen.FaceStyle> {
  @override int get elementSizeInBytes => gen.FaceStyle.unpaddedSizeInBytes;
  @override gen.FaceStyle get(int offset) => .read(data, offset);
  @override void set(int offset, gen.FaceStyle value) => value.write(data, offset);
}
// dart format on
