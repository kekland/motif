part of '../renderer.dart';

enum RenderPipelineKind { direct, stencil, coverKeep, coverZero }

final class RenderPipelineState({
  required final RenderPipelineKind kind,
  final Hash? imageBinding,
}) {
  RenderPipelineState copyWith({
    RenderPipelineKind? kind,
    Hash? imageBinding,
  }) => .new(
    kind: kind ?? this.kind,
    imageBinding: imageBinding ?? this.imageBinding,
  );

  bool isCompatible(RenderPipelineState prev) {
    if (!isKindCompatible(prev)) return false;
    if (!isBindingsCompatible(prev)) return false;
    return true;
  }

  bool isKindCompatible(RenderPipelineState prev) => kind == prev.kind;
  bool isBindingsCompatible(RenderPipelineState prev) {
    if (imageBinding != null && imageBinding != prev.imageBinding) return false;
    return true;
  }
}

final class DrawManager {
  new(this.renderer);

  final Renderer renderer;
  Bundle get bundle => renderer.bundle;

  late final buffer = GpuStorageBuffer(renderer.device!, storage, label: 'draw');
  late final storage = DrawStorage();

  late final entry = DrawEntryManager(renderer);
  late final order = DrawOrderManager(renderer);

  bool upload() {
    var rebind = false;
    rebind |= buffer.upload(renderer.queue);
    return rebind;
  }

  void updateCell(CellHandle h) => entry._processCell(h);
  void updateText(TextStatement s, FrameHandle h) => entry._processText(s.frame, h);
  void release(CellIndex i) => entry._release(i);
  void releaseRef(CellRef ref) => entry._releaseRef(ref);

  void updateOrder() {
    order.update();
  }

  void _traverse(FrameHandle f) {
    final ref = bundle.frameRef(f);
    if (renderer.text.isTextFrame(ref)) {
      entry._processText(ref, f);
      return;
    }

    for (final child in bundle.frameChildren(f)) {
      switch (child.kind) {
        case .frame:
          _traverse(child.asFrame);
        case .vertex || .edge || .face:
          entry._processCell(child);
      }
    }
  }

  void initialUpdate() {
    _traverse(.root);
    order.update();
  }
}

final class DrawStorage extends CompositeStorage {
  DrawStorage() : super([DrawEntryStorage(), DrawEdgeStorage(), DrawOrderStorage()]);

  late final DrawEntryStorage entry = storages[0] as DrawEntryStorage;
  late final DrawEdgeStorage edge = storages[1] as DrawEdgeStorage;
  late final DrawOrderStorage order = storages[2] as DrawOrderStorage;

  int get entryOffsetInBytes => offsetFor(0);
  int get edgeOffsetInBytes => offsetFor(1);
  int get orderOffsetInBytes => offsetFor(2);
}

// dart format off
final class DrawEntryStorage extends UnitStorage<gen.DrawEntry> with SpanStorage<gen.DrawEntry> {
  @override int get elementSizeInBytes => gen.DrawEntry.unpaddedSizeInBytes;
  @override void set(int offset, gen.DrawEntry value) => value.write(data, offset);
  @override gen.DrawEntry get(int offset) => gen.DrawEntry.read(data, offset);
}

final class DrawEdgeStorage extends UnitStorage<int> {
  @override int get elementSizeInBytes => 4;
  @override void set(int offset, int value) => data.setU32(offset, value);
}

final class DrawOrderStorage extends UnitStorage<int> {
  @override int get elementSizeInBytes => 4;
  @override void set(int offset, int value) => data.setU32(offset, value);
}
// dart format on

final class DrawEntryManager {
  new(this.renderer);

  final Renderer renderer;
  Bundle get bundle => renderer.bundle;
  DrawEntryStorage get storage => renderer.draw.storage.entry;

  RenderPipelineState _producePipelineState(RenderPipelineKind kind, PreparedDecoration? d) {
    if (d is ImagePreparedDecoration) return .new(kind: kind, imageBinding: d.hash);
    return .new(kind: kind);
  }

  final _cache = <CellIndex, (DataSpan, List<int>, List<RenderPipelineState>)>{};
  final _refCache = <CellRef, CellIndex>{};

  late CellIndex _key;
  var _cell = -1;
  var _instanceSpan = DataSpan(0, 0);
  late CellKind _cellKind;
  late int _decorationStart;
  late int _decorationCount;
  var _decorationOffset = 0;
  var _pipelines = <RenderPipelineState>[];
  var _drawCounts = <int>[];
  var _entries = <gen.DrawEntry>[];
  var _isText = false;

  void _begin(CellIndex key, int cell, CellKind kind, int decorationStart, int decorationCount) {
    _key = key;
    _cell = cell;
    _cellKind = kind;
    _decorationStart = decorationStart;
    _decorationCount = decorationCount;
    _decorationOffset = 0;
    _pipelines = [];
    _entries = [];
    _drawCounts = [];
    _hasState = false;
    _isText = false;
  }

  void _beginText(CellIndex key, DataSpan instanceSpan, int decorationStart, int decorationCount) {
    _begin(key, -1, .frame, decorationStart, decorationCount);
    _instanceSpan = instanceSpan;
    _isText = true;
  }

  void _push(RenderPipelineKind kind, PreparedDecoration? d) {
    final state = _producePipelineState(kind, d);
    if (!_hasState) {
      _state = state;
      _hasState = true;
    } else if (!state.isCompatible(_state)) {
      _flush(_state);
      _state = state;
    }

    if (d != null) _decorationOffset++;
  }

  late RenderPipelineState _state;
  var _hasState = false;

  void _flush(RenderPipelineState state) {
    if (_isText) {
      _flushText(state);
    } else {
      _flushCell(state);
    }
  }

  void _flushCell(RenderPipelineState state) {
    // print('flush: ${_cell} ${_cellKind}, decoration span: $_decorationStart:$_decorationOffset');
    final entry = gen.DrawEntry(
      cell: _cell,
      decorationSpan: .new(_decorationStart, _decorationOffset),
      kind: switch (state.kind) {
        .direct when _cellKind == .vertex => 1,
        .direct when _cellKind == .edge => 2,
        .stencil => 3,
        .coverKeep || .coverZero => 4,
        _ => unreachable(),
      },
    );

    _entries.add(entry);
    _pipelines.add(state);
    _drawCounts.add(_decorationOffset);
    _decorationStart += _decorationOffset;
    _decorationCount -= _decorationOffset;
    _decorationOffset = 0;
  }

  void _flushText(RenderPipelineState state) {
    final decorationSpan = DataSpan(_decorationStart, _decorationOffset);
    final kind = switch (state.kind) {
      .direct => 5,
      .stencil => 6,
      .coverKeep || .coverZero => 7,
    };

    final offsetCount = switch (state.kind) {
      .stencil => 1,
      _ => _decorationOffset,
    };

    for (var i = _instanceSpan.start; i < _instanceSpan.end; i++) {
      final entry = gen.DrawEntry(cell: i, decorationSpan: decorationSpan, kind: kind);
      _entries.add(entry);
    }

    _pipelines.add(state);
    _drawCounts.add(offsetCount * _instanceSpan.count);
    _decorationStart += _decorationOffset;
    _decorationCount -= _decorationOffset;
    _decorationOffset = 0;
  }

  void _end() {
    if (_hasState) _flush(_state);
    assert(_decorationOffset == 0 && _decorationCount == 0);

    final span = storage.put(_entries, span: _cache[_key]?.$1);
    // print('end: $_cell ($_cellKind), span: $span, counts: $_drawCounts, pipelines: ${_pipelines.map((p) => p.kind)}');
    _cache[_key] = (span, _drawCounts, _pipelines);
  }

  void _processCell(CellHandle h) {
    final ref = bundle.ref(h);
    renderer.style.update(ref, h);

    final i = h.cellIndex;

    if (i.kind == .vertex) {
      final style = renderer.style.storage.vertex[i.i]!;
      final decorations = renderer.style.decorationsOf(i);
      if (decorations.isEmpty) return;

      _begin(i, i.value, .vertex, style.decorationSpan.x, style.decorationSpan.y);
      for (final d in decorations) _push(.direct, d);
      _end();
    } else if (i.kind == .edge) {
      final style = renderer.style.storage.edge[i.i]!;
      final decorations = renderer.style.decorationsOf(i);
      if (decorations.isEmpty) return;

      _begin(i, i.value, .edge, style.decorationSpan.x, style.decorationSpan.y);
      for (final d in decorations) _push(.direct, d);
      _end();
    } else if (i.kind == .face) {
      final style = renderer.style.storage.face[i.i]!;
      final decorations = renderer.style.decorationsOf(i);
      if (decorations.isEmpty) return;

      _begin(i, i.value, .face, style.decorationSpan.x, style.decorationSpan.y);
      _push(.stencil, null);
      for (final d in decorations.take(decorations.length - 1)) _push(.coverKeep, d);
      _push(.coverZero, decorations.last);
      _end();
    }
  }

  void _processText(FrameRef ref, FrameHandle h) {
    final i = h.index;

    assert(renderer.text.isTextFrame(ref));
    final instanceSpan = renderer.text.getInstanceSpan(ref);
    // print('== process text $ref (${i.i}) span: ${instanceSpan}');

    final edgeDecorationSpan = renderer.text.style.edgeDecorationSpanOf(ref);
    final edgeDecorations = renderer.text.style.edgeDecorationsOf(ref);
    if (edgeDecorationSpan.isNotEmpty) {
      _beginText(i.cell, instanceSpan, edgeDecorationSpan.x, edgeDecorationSpan.y);
      for (final d in edgeDecorations) _push(.direct, d);
      _end();
    }

    final faceDecorationSpan = renderer.text.style.faceDecorationSpanOf(ref);
    final faceDecorations = renderer.text.style.faceDecorationsOf(ref);
    if (faceDecorationSpan.isNotEmpty) {
      _beginText(i.cell, instanceSpan, faceDecorationSpan.x, faceDecorationSpan.y);
      _push(.stencil, null);
      for (final d in faceDecorations.take(faceDecorations.length - 1)) _push(.coverKeep, d);
      _push(.coverZero, faceDecorations.last);
      _end();
    }

    _refCache[ref] = i.cell;
  }

  void _release(CellIndex c) {
    final data = _cache.remove(c);
    if (data == null) return;
    storage.release(data.$1);
  }

  void _releaseRef(CellRef ref) {
    final c = _refCache.remove(ref);
    if (c == null) return;
    _release(c);
  }
}

final class DrawOrderManager {
  new(this.renderer);

  final Renderer renderer;
  Bundle get bundle => renderer.bundle;
  DrawOrderStorage get storage => renderer.draw.storage.order;
  DrawEdgeStorage get edgeStorage => renderer.draw.storage.edge;
  DrawEntryManager get entry => renderer.draw.entry;

  final _cache = <CellIndex>[];

  int get count => _top;
  int get edgeCount => _edgeTop;

  var _top = 0;
  var _edgeTop = 0;

  void _push(CellIndex c) {
    final span = entry._cache[c]?.$1;
    if (span == null) return;
    // print('  push cell ${c.index} (${c.kind}): ${_top}=$span');
    for (var i = span.start; i < span.end; i++) storage[_top++] = i;
    _cache.add(c);
  }

  void _pushEdge(EdgeIndex c) {
    edgeStorage[_edgeTop++] = c.i;
  }

  void _traverse(FrameIndex f) {
    final ref = bundle.frameRef(bundle.frameStorage.handleFor(f));
    if (renderer.text.isTextFrame(ref)) {
      _push(f.cell);
      return;
    }

    for (final child in bundle.frameChildrenRaw(f)) {
      switch (child.kind) {
        case .frame:
          _traverse(child.asFrame);
        case .edge:
          _pushEdge(child.asEdge);
          _push(child);
        case .face:
          for (final ce in bundle.faceBoundaryRaw(child.asFace)) _pushEdge(bundle.coedgeStorage.edge[ce]);
          _push(child);
        case .vertex:
          _push(child);
      }
    }
  }

  void update() {
    // print('== begin draw order update');
    _top = 0;
    _edgeTop = 0;
    _cache.clear();
    _traverse(.root);
  }
}
