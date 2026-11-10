import 'dart:collection';

import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:renderer2/renderer.dart';
import 'package:renderer2/src/cache/decoration_cache.dart';
import 'package:scene/scene.dart';
import 'package:webgpu/webgpu.dart' as webgpu;

import 'buffers/decoration.dart';
import 'buffers/geometry.dart';
import 'buffers/style.dart';
import 'buffers/topology.dart';

import 'shaders/count.g.dart' as count;
import 'shaders/structs.g.dart' as structs;
import 'shaders/scan.g.dart' as scan;
import 'shaders/generate.g.dart' as generate;

enum _DrawEntryKind { vertex, edge, faceFan, faceCover }

class RendererStorage {
  RendererStorage(this.renderer) {
    storageOffsetsUbo = .new(device, label: 'storage-offsets');
    countBuffer = .new(device, length: 30000, label: 'count');
    indirectArgsBuffer = .new(
      device,
      length: 30000,
      label: 'indirect-args',
      usage: .of([.copyDst, .storage, .indirect, .copySrc]),
    );

    renderGeometryBuffer = .new(device, length: 30000, label: 'render-geometry');

    geometry = .new(device, GeometryStorage(), label: 'geometry');
    topology = .new(device, TopologyStorage(), label: 'topology');
    style = .new(device, StyleStorage(), label: 'style');
    decorations = .new(device, DecorationStorage(), label: 'decorations');

    scene.addUpdateListener(_onSceneUpdate);
    bundle.frameStorage.observe(_frameObserver);
    bundle.vertexStorage.observe(_vertexObserver);
    bundle.covertexStorage.observe(_covertexObserver);
    bundle.edgeStorage.observe(_edgeObserver);
    bundle.faceStorage.observe(_faceObserver);
  }

  final SceneRenderer renderer;
  webgpu.Device get device => renderer.device!;
  Scene get scene => renderer.scene;
  DecorationCache get decorationCache => renderer.decorationCache;

  Bundle get bundle => scene.bundle;

  final _frameObserver = CacheArenaObserver<FrameIndex>();
  final _vertexObserver = CacheArenaObserver<VertexIndex>();
  final _covertexObserver = CacheArenaObserver<CovertexIndex>();
  final _edgeObserver = CacheArenaObserver<EdgeIndex>();
  final _faceObserver = CacheArenaObserver<FaceIndex>();

  late final count.StorageOffsetsUniformBuffer storageOffsetsUbo;
  late final GpuStorage<GeometryStorage> geometry;
  late final GpuStorage<TopologyStorage> topology;
  late final GpuStorage<StyleStorage> style;
  late final GpuStorage<DecorationStorage> decorations;

  late final count.U32ArrayStorageBuffer countBuffer;
  late final scan.DrawIndirectArgsArrayStorageBuffer indirectArgsBuffer;
  late final generate.RenderGeometryArrayStorageBuffer renderGeometryBuffer;

  final _updateData = EvalPassData.empty();
  final shaderUpdated = <CellRef>{};
  void _onSceneUpdate(EvalPass pass) {
    _updateData.add(pass);
  }

  void initialUpload() {
    _updateStorage(
      frames: bundle.frameStorage.liveIndices,
      vertices: bundle.vertexStorage.liveIndices,
      covertices: bundle.covertexStorage.liveIndices,
      edges: bundle.edgeStorage.liveIndices,
      faces: bundle.faceStorage.liveIndices,
      restyled: scene.bundle.query.allCells,
    );
  }

  int upload(webgpu.Queue queue, void Function() onRebind) {
    final drawCount = _upload(
      queue,
      onRebind,
      frames: _frameObserver.createdOrTouched,
      vertices: _vertexObserver.createdOrTouched,
      covertices: _covertexObserver.createdOrTouched,
      edges: _edgeObserver.createdOrTouched,
      faces: _faceObserver.createdOrTouched,
      restyled: _updateData.restyled.followedBy(shaderUpdated),
    );

    _frameObserver.clear();
    _vertexObserver.clear();
    _covertexObserver.clear();
    _edgeObserver.clear();
    _faceObserver.clear();
    shaderUpdated.clear();
    _updateData.reset();

    return drawCount;
  }

  void _updateStorage({
    required Iterable<FrameIndex> frames,
    required Iterable<VertexIndex> vertices,
    required Iterable<CovertexIndex> covertices,
    required Iterable<EdgeIndex> edges,
    required Iterable<FaceIndex> faces,
    required Iterable<CellRef> restyled,
  }) {
    final expandedFrames = HashSet<FrameIndex>.from(frames);
    final work = <FrameIndex>[...frames];
    while (work.isNotEmpty) {
      final current = work.removeLast();
      if (!bundle.frameStorage.isLive(current)) continue;
      expandedFrames.add(current);
      final children = bundle.frameChildrenRaw(current);
      for (final c in children) {
        if (c.kind == .frame) work.add(c.asFrame);
      }
    }

    for (final i in expandedFrames) {
      if (!bundle.frameStorage.isLive(i)) continue;
      geometry.storage.frame[i.i] = bundle.frameWorldTransformRaw(i);
      geometry.storage.frameInverse[i.i] = bundle.frameInverseWorldTransformRaw(i);
    }

    for (final i in vertices) {
      if (!bundle.vertexStorage.isLive(i)) continue;
      geometry.storage.vertex[i.i] = bundle.vertexPositionRaw(i);
      topology.storage.vertex[i.i] = .new(
        diskStart: bundle.vertexStorage.diskStart[i].i,
        parent: bundle.vertexStorage.parent[i].i,
      );
    }

    for (final i in covertices) {
      if (!bundle.covertexStorage.isLive(i)) continue;
      geometry.storage.covertex[i.i] = bundle.covertexTangentRaw(i);
      topology.storage.covertex[i.i] = .new(
        edge: bundle.covertexStorage.edge[i].i,
        isStart: bundle.covertexStorage.isStart[i] ? 1 : 0,
        next: bundle.covertexStorage.diskNext[i].i,
      );
    }

    for (final i in edges) {
      if (!bundle.edgeStorage.isLive(i)) continue;
      geometry.storage.edge[i.i] = bundle.edgeCubicRaw(i);
      topology.storage.edge[i.i] = .new(
        vertexStart: bundle.edgeStorage.vStart[i].i,
        vertexEnd: bundle.edgeStorage.vEnd[i].i,
        parent: bundle.edgeStorage.parent[i].i,
      );
    }

    for (final i in faces) {
      if (!bundle.faceStorage.isLive(i)) continue;
      final coedges = bundle.faceBoundaryRaw(i);
      final boundary = coedges
          .map<structs.FaceBoundaryEntry>(
            (e) => .new(
              edge: bundle.coedgeStorage.edge[e].i,
              isForward: bundle.coedgeStorage.direction[e] ? 1 : 0,
            ),
          )
          .toList();

      final previousData = topology.storage.face[i.i];
      final span = topology.storage.faceBoundary.put(
        boundary,
        span: previousData != null ? (offset: previousData.boundaryStart, count: previousData.boundaryCount) : null,
      );

      topology.storage.face[i.i] = .new(
        boundaryStart: span.offset,
        boundaryCount: span.count,
        parent: bundle.faceStorage.parent[i].i,
      );
    }

    // Styles
    for (final ref in restyled) {
      final handle = bundle.handle(ref);
      if (handle == null) continue;

      final styleData = scene.styleOf(ref);
      if (styleData == null) continue;

      if (styleData is VertexStyle) {
        continue;
      } else if (styleData is EdgeStyle) {
        final previousData = style.storage.edge[handle.rawIndex];
        final decorationSpan = decorationCache.spanFor(
          ref,
          styleData.decorations,
          previousSpan: previousData != null
              ? (offset: previousData.decorationStart, count: previousData.decorationCount)
              : null,
        );

        style.storage.edge[handle.rawIndex] = .new(
          width: styleData.width,
          decorationStart: decorationSpan.offset,
          decorationCount: decorationSpan.count,
        );
      } else if (styleData is FaceStyle) {
        final previousData = style.storage.face[handle.rawIndex];
        final decorationSpan = decorationCache.spanFor(
          ref,
          styleData.decorations,
          previousSpan: previousData != null
              ? (offset: previousData.decorationStart, count: previousData.decorationCount)
              : null,
        );

        style.storage.face[handle.rawIndex] = .new(
          decorationStart: decorationSpan.offset,
          decorationCount: decorationSpan.count,
        );
      }
    }
  }

  int _upload(
    webgpu.Queue queue,
    void Function() onRebind, {
    required Iterable<FrameIndex> frames,
    required Iterable<VertexIndex> vertices,
    required Iterable<CovertexIndex> covertices,
    required Iterable<EdgeIndex> edges,
    required Iterable<FaceIndex> faces,
    required Iterable<CellRef> restyled,
  }) {
    _updateStorage(
      frames: frames,
      vertices: vertices,
      covertices: covertices,
      edges: edges,
      faces: faces,
      restyled: restyled,
    );

    // Draw order
    var drawCount = 0;
    void traverse(FrameIndex frameIndex) {
      for (final child in bundle.frameChildrenRaw(frameIndex)) {
        final kind = child.kind;
        if (kind == .frame) {
          traverse(child.asFrame);
        } else if (kind == .vertex) {
          topology.storage.draw[drawCount++] = .new(
            cell: child.value,
            kind: _DrawEntryKind.vertex.index,
            decorationOffset: 0,
          );
        } else if (kind == .edge) {
          final decorationCount = style.storage.edge[child.i]!.decorationCount;
          for (var i = 0; i < decorationCount; i++) {
            topology.storage.draw[drawCount++] = .new(
              cell: child.value,
              kind: _DrawEntryKind.edge.index,
              decorationOffset: i,
            );
          }
        } else if (kind == .face) {
          final decorationCount = style.storage.face[child.i]!.decorationCount;
          for (var i = 0; i < decorationCount; i++) {
            topology.storage.draw[drawCount++] = .new(
              cell: child.value,
              kind: _DrawEntryKind.faceFan.index,
              decorationOffset: 0,
            );

            topology.storage.draw[drawCount++] = .new(
              cell: child.value,
              kind: _DrawEntryKind.faceCover.index,
              decorationOffset: i,
            );
          }
        }
      }
    }

    traverse(.root);

    storageOffsetsUbo.set(
      geometryFrame: geometry.storage.frameOffset ~/ 4,
      geometryFrameInverse: geometry.storage.frameInverseOffset ~/ 4,
      geometryVertex: geometry.storage.vertexOffset ~/ 4,
      geometryCovertex: geometry.storage.covertexOffset ~/ 4,
      geometryEdge: geometry.storage.edgeOffset ~/ 4,
      topologyVertex: topology.storage.vertexOffset ~/ 4,
      topologyEdge: topology.storage.edgeOffset ~/ 4,
      topologyFace: topology.storage.faceOffset ~/ 4,
      topologyCovertex: topology.storage.covertexOffset ~/ 4,
      topologyFaceBoundary: topology.storage.faceBoundaryOffset ~/ 4,
      topologyDraw: topology.storage.drawOffset ~/ 4,
      topologyDrawCount: drawCount,
      styleVertex: style.storage.vertexOffset ~/ 4,
      styleEdge: style.storage.edgeOffset ~/ 4,
      styleFace: style.storage.faceOffset ~/ 4,
      renderGeometryCapacity: 30000,
    );
    storageOffsetsUbo.writeToQueue(queue);

    countBuffer.clear(queue);
    indirectArgsBuffer.clear(queue);
    renderGeometryBuffer.clear(queue);

    var shouldRebind = false;
    shouldRebind |= geometry.upload(queue);
    shouldRebind |= topology.upload(queue);
    shouldRebind |= style.upload(queue);
    shouldRebind |= decorations.upload(queue);

    if (shouldRebind) {
      onRebind();
    }

    return drawCount;
  }

  void dispose() {
    bundle.frameStorage.unobserve(_frameObserver);
    bundle.vertexStorage.unobserve(_vertexObserver);
    bundle.covertexStorage.unobserve(_covertexObserver);
    bundle.edgeStorage.unobserve(_edgeObserver);
    bundle.faceStorage.unobserve(_faceObserver);
    scene.removeUpdateListener(_onSceneUpdate);
    storageOffsetsUbo.destroy();
    geometry.destroy();
    topology.destroy();
    style.destroy();
    decorations.destroy();
  }
}
