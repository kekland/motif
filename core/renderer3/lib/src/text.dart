part of '../renderer.dart';

final class TextManager {
  new(this.renderer);

  final Renderer renderer;
  Scene get scene => renderer.scene;
  Evaluation get evaluation => scene.evaluation;

  late final glyph = GlyphManager(renderer);
  late final style = TextStyleManager(renderer);

  late final instanceBuffer = GpuStorageBuffer(renderer.device!, instanceStorage, label: 'text-instance-buffer');
  late final instanceStorage = GlyphInstanceStorage();

  final _statements = <StatementId, TextStatement>{};
  final _spans = <StatementId, DataSpan>{};
  final _bboxes = <StatementId, geom32.Aabb2>{};

  void process(TextStatement statement) {
    _statements[statement.id] = statement;
    final styleIndex = style.process(statement);

    final size = evaluation.layout.placementOf(statement.id)!.size;
    final paragraph = statement.buildParagraph(evaluation);
    paragraph.layout(size.width);

    final metrics = paragraph.glyphMetrics.toList();
    final data = ByteData(metrics.length * gen.GlyphInstance.unpaddedSizeInBytes);
    final scale = statement.textFormat.fontSize;

    var bbox = geom32.Aabb2.invertedInfinity();

    for (final (i, metrics) in metrics.indexed) {
      final id = (metrics.typefaceId, metrics.synthetic, metrics.id);
      final glyphIndex = glyph.indexOf(id) ?? glyph.put(id, scale, paragraph.getGlyphPathByIndex(i));

      final offset = i * gen.GlyphInstance.unpaddedSizeInBytes;
      gen.GlyphInstance(
        glyphIndex: glyphIndex,
        styleIndex: styleIndex,
        offset: .new(metrics.x, metrics.y),
        parentIndex: renderer.bundle.frame(statement.frame)!.rawIndex,
        scale: scale,
      ).write(data, offset);

      final glyphBboxRaw = glyph.bounds[id]!;
      final glyphBbox = geom32.Aabb2(
        glyphBboxRaw.left * scale + metrics.x,
        glyphBboxRaw.top * scale + metrics.y,
        glyphBboxRaw.right * scale + metrics.x,
        glyphBboxRaw.bottom * scale + metrics.y,
      );

      bbox.hull(glyphBbox);
    }

    final span = instanceStorage.putRaw(data, span: _spans[statement.id]);
    _spans[statement.id] = span;
    _bboxes[statement.id] = bbox;
    print("[text] process text: ${metrics.length} ($span)");
  }

  void release(StatementId id) {
    if (!_statements.containsKey(id)) return;
    _statements.remove(id);

    final span = _spans.remove(id);
    if (span != null) instanceStorage.release(span);

    style.release(id);
  }

  bool upload() {
    var rebind = false;
    rebind |= glyph.upload();
    rebind |= instanceBuffer.upload(renderer.queue);
    rebind |= style.upload();
    return rebind;
  }

  bool isTextFrame(FrameRef ref) => _statements.containsKey(ref.statementId);
  TextStatement getTextStatement(FrameRef ref) => _statements[ref.statementId]!;
  DataSpan getInstanceSpan(FrameRef ref) => _spans[ref.statementId]!;
  geom32.Aabb2 getBbox(FrameRef ref) => _bboxes[ref.statementId]!;
}

typedef GlyphId = (int, int, int);
typedef GlyphIndex = int;

final class GlyphManager {
  new(this.renderer);

  final Renderer renderer;

  late final buffer = GpuStorageBuffer(renderer.device!, storage, label: 'glyph');
  late final storage = GlyphStorage();
  final mapping = <GlyphId, GlyphIndex>{};
  final bounds = <GlyphId, geom32.Aabb2>{};

  var dataTop = 0;
  var boundaryTop = 0;
  var geometryTop = 0;

  bool contains(GlyphId id) => mapping.containsKey(id);
  int? indexOf(GlyphId id) => mapping[id];

  int put(GlyphId id, double fontSize, skia.Path path) {
    final existingIndex = indexOf(id);
    if (existingIndex != null) return existingIndex;

    final scale = 1.0 / fontSize;

    final index = dataTop++;
    mapping[id] = index;

    final boundaries = <(int, int)>[];
    final quadCount = List.filled(path.verbs.length, 0);
    final verbs = path.verbs;
    final points = geom32.Vec2List.fromBuffer(path.points);

    var totalCount = 0;
    var start = 0;
    var count = 0;
    var pi = 0;
    var startPi = 0;

    for (var i = 0; i < verbs.length; i++) {
      switch (verbs[i]) {
        case .move when count > 0:
          boundaries.add((start, count));
          totalCount += count;
          start = totalCount;
          startPi = pi;
          count = 0;
          pi += 1;
        case .move:
          startPi = pi;
          pi += 1;
        case .line:
          count += 1;
          quadCount[i] = 1;
          pi += 1;
        case .quad:
          count += 1;
          quadCount[i] = 1;
          pi += 2;
        case .cubic:
          final c = geom32.Cubic2.view(points.sublistView(pi - 1, pi + 3));
          final n = c.toQuadraticCount(1.0);
          quadCount[i] = n;
          count += n;
          pi += 3;
        case .conic:
          unreachable();
        case .close:
          final gap = (points[pi - 1] - points[startPi]).length;
          if (gap > fontSize * 1e-5) {
            count += 1;
            quadCount[i] = 1;
          }
          if (count > 0) boundaries.add((start, count));
          totalCount += count;
          count = 0;
          start = totalCount;
      }
    }

    if (count > 0) {
      boundaries.add((start, count));
      totalCount += count;
    }

    final quadratics = geom32.Vec2List(totalCount * 3);
    final bbox = geom32.Aabb2.invertedInfinity();

    pi = 0;
    startPi = 0;
    count = 0;
    for (var i = 0; i < verbs.length; i++) {
      switch (verbs[i]) {
        case .move:
          startPi = pi;
          pi += 1;
        case .line:
          final p0 = points[pi - 1], p1 = points[pi];
          quadratics[count * 3] = p0 * scale;
          quadratics[count * 3 + 1] = (p0 + p1) * 0.5 * scale;
          quadratics[count * 3 + 2] = p1 * scale;
          count += 1;
          pi += 1;
        case .quad:
          quadratics[count * 3] = points[pi - 1] * scale;
          quadratics[count * 3 + 1] = points[pi] * scale;
          quadratics[count * 3 + 2] = points[pi + 1] * scale;
          count += 1;
          pi += 2;
        case .cubic:
          final c = geom32.Cubic2.view(points.sublistView(pi - 1, pi + 3));
          final n = quadCount[i];
          var current = points[pi - 1];
          c.toQuadraticsRaw(n, (p1, p2) {
            quadratics[count * 3] = current * scale;
            quadratics[count * 3 + 1] = p1 * scale;
            quadratics[count * 3 + 2] = p2 * scale;
            current = p2;
            count += 1;
          });
          pi += 3;
        case .close:
          if (quadCount[i] == 1) {
            final p0 = points[pi - 1];
            final p1 = points[startPi];
            quadratics[count * 3] = p0 * scale;
            quadratics[count * 3 + 1] = (p0 + p1) * 0.5 * scale;
            quadratics[count * 3 + 2] = p1 * scale;
            count += 1;
          }
        default:
          break;
      }
    }

    for (var i = 0; i < count; i++) {
      final q = geom32.Quadratic2.view(quadratics.sublistView(i * 3, i * 3 + 3));
      bbox.hull(q.bboxTight);
    }

    storage.data[index] = .new(boundarySpan: .new(boundaryTop, boundaries.length));
    // print('data ${index}: b span ${boundaryTop}-${boundaryTop + boundaries.length}');

    for (final b in boundaries) {
      // print('boundary ${boundaryTop}: g span ${b.$1 + geometryTop}-${b.$1 + geometryTop + b.$2}');
      storage.boundary[boundaryTop++] = .new(geometrySpan: .new(b.$1 + geometryTop, b.$2));
    }

    final geometryStart = geometryTop;
    final geometryEnd = geometryTop + totalCount;

    storage.geometry.grow(geometryEnd);
    storage.geometry.data.buffer.asFloat32List().setRange(
      geometryStart * 6,
      geometryEnd * 6,
      quadratics.buffer,
    );
    storage.geometry.markRangeDirty(geometryStart, geometryEnd);

    geometryTop += totalCount;

    bounds[id] = bbox;

    // print('geometry: ${geometryTop - totalCount}-${geometryTop}');
    return index;
  }

  bool upload() => buffer.upload(renderer.queue);
}

final class GlyphInstanceStorage extends UnitStorage<gen.GlyphInstance> with SpanStorage<gen.GlyphInstance> {
  @override
  int get elementSizeInBytes => gen.GlyphInstance.unpaddedSizeInBytes;

  @override
  void set(int offset, gen.GlyphInstance value) => value.write(data, offset);
}

final class GlyphStorage extends CompositeStorage {
  GlyphStorage() : super([GlyphDataStorage(), GlyphBoundaryStorage(), GlyphGeometryStorage()]);

  late final data = storages[0] as GlyphDataStorage;
  late final boundary = storages[1] as GlyphBoundaryStorage;
  late final geometry = storages[2] as GlyphGeometryStorage;

  int get dataOffsetInBytes => offsetFor(0);
  int get boundaryOffsetInBytes => offsetFor(1);
  int get geometryOffsetInBytes => offsetFor(2);
}

final class GlyphDataStorage extends UnitStorage<gen.GlyphData> {
  @override
  int get elementSizeInBytes => gen.GlyphData.unpaddedSizeInBytes;

  @override
  void set(int offset, gen.GlyphData value) => value.write(data, offset);
}

final class GlyphBoundaryStorage extends UnitStorage<gen.GlyphBoundary> {
  @override
  int get elementSizeInBytes => gen.GlyphBoundary.unpaddedSizeInBytes;

  @override
  void set(int offset, gen.GlyphBoundary value) => value.write(data, offset);
}

final class GlyphGeometryStorage() extends Quadratic2UnitStorage;

final class TextStyleManager {
  new(this.renderer);
  final Renderer renderer;

  late final buffer = GpuStorageBuffer(renderer.device!, storage, label: 'text-style');
  late final storage = TextStyleStorage();

  late final _indices = <StatementId, int>{};
  late final _edgeCache = <StatementId, (List<PreparedDecoration>, DataSpan)>{};
  late final _faceCache = <StatementId, (List<PreparedDecoration>, DataSpan)>{};

  DataSpan edgeDecorationSpanOf(FrameRef ref) => _edgeCache[ref.statementId]!.$2;
  DataSpan faceDecorationSpanOf(FrameRef ref) => _faceCache[ref.statementId]!.$2;

  Iterable<PreparedDecoration> edgeDecorationsOf(FrameRef ref) => _edgeCache[ref.statementId]?.$1 ?? const [];
  Iterable<PreparedDecoration> faceDecorationsOf(FrameRef ref) => _faceCache[ref.statementId]?.$1 ?? const [];

  int process(TextStatement statement) {
    final existingIndex = _indices[statement.id];
    final edgeDecorationData = renderer.decoration.put(
      statement.edgeStyle.decorations,
      span: .maybeFrom(_edgeCache[statement.id]?.$2),
      ref: statement.frame,
    );

    final faceDecorationData = renderer.decoration.put(
      statement.faceStyle.decorations,
      span: .maybeFrom(_faceCache[statement.id]?.$2),
      ref: statement.frame,
    );

    final index = storage.put(
      .new(
        edgeDecorationSpan: edgeDecorationData.$2,
        faceDecorationSpan: faceDecorationData.$2,
        edgeWidth: statement.edgeStyle.width,
      ),
      index: existingIndex,
    );

    _indices[statement.id] = index;
    _edgeCache[statement.id] = edgeDecorationData;
    _faceCache[statement.id] = faceDecorationData;

    return index;
  }

  void release(StatementId id) {
    final existingIndex = _indices[id];
    if (existingIndex == null) return;

    renderer.decoration.release(.from(_edgeCache[id]!.$2));
    renderer.decoration.release(.from(_faceCache[id]!.$2));
    storage.release(existingIndex);

    _indices.remove(id);
    _edgeCache.remove(id);
    _faceCache.remove(id);
  }

  bool upload() => buffer.upload(renderer.queue);
}

final class TextStyleStorage extends UnitStorage<gen.TextStyle> with AllocatorStorage<gen.TextStyle> {
  @override
  int get elementSizeInBytes => gen.TextStyle.unpaddedSizeInBytes;

  @override
  void set(int offset, gen.TextStyle value) => value.write(data, offset);
}
