part of '../renderer.dart';

final class DecorationManager {
  new(this.renderer);
  final Renderer renderer;

  late final buffer = GpuStorageBuffer(renderer.device!, storage, label: 'decoration');
  late final storage = DecorationStorage();

  late final image = ImageDecorationManager(renderer);
  late final shader = ShaderDecorationManager(renderer);

  (List<PreparedDecoration>, DataSpan) put(Decorations decorations, {DataSpan? span, CellRef? ref}) {
    final preparedDecorations = <PreparedDecoration>[];

    for (final entry in decorations.entries) {
      if (entry is ColorDecoration) {
        preparedDecorations.add(.color(color: entry.color.cssColor));
      } else if (entry is ImageDecoration) {
        if (entry.image == null) continue;
        final texture = image.resolve(entry.image!, ref: ref);
        if (texture != null) preparedDecorations.add(.image(hash: entry.image!));
      } else if (entry is ShaderDecoration) {
        final data = shader.resolve(entry.id, entry.shader, ref: ref);
        if (data != null) preparedDecorations.add(.shader(key: data));
      }
    }

    final newSpan = storage.put(preparedDecorations, span: span);
    return (preparedDecorations, newSpan);
  }

  void release(DataSpan span) {
    storage.release(span);
  }

  bool upload() => buffer.upload(renderer.queue);
}

extension type const DecorationKind._(int value) implements int {
  static const color = DecorationKind._(1);
  static const image = DecorationKind._(2);
  static const shader = DecorationKind._(3);
}

sealed class PreparedDecoration() {
  factory color({required css.ColorData color}) = ColorPreparedDecoration;
  factory image({required Hash hash}) = ImagePreparedDecoration;
  factory shader({required int key}) = ShaderPreparedDecoration;
}

final class ColorPreparedDecoration({required final css.ColorData color}) extends PreparedDecoration;
final class ImagePreparedDecoration({required final Hash hash}) extends PreparedDecoration;
final class ShaderPreparedDecoration({required final int key}) extends PreparedDecoration;

// dart format off
final class DecorationStorage extends UnitStorage<PreparedDecoration> with SpanStorage<PreparedDecoration> {
  @override int get elementSizeInBytes => gen.Decoration.unpaddedSizeInBytes;
  @override void set(int offset, PreparedDecoration value) {
    // print('decoration at ${offset ~/ elementSizeInBytes}');
    if (value is ColorPreparedDecoration) {
      // print('- color ${value.color.toString()}');
      data.setU32(offset + 0, DecorationKind.color);
      final color = value.color.convert<css.SrgbColorData>();
      data.setF32(offset + 4, color.r);
      data.setF32(offset + 8, color.g);
      data.setF32(offset + 12, color.b);
      data.setF32(offset + 16, color.alpha);
    }
    else if (value is ImagePreparedDecoration) {
      // print('- image ${value.hash}');
      data.setU32(offset + 0, DecorationKind.image);
      data.setU32(offset + 4, 0);
      data.setU32(offset + 8, 0);
      data.setU32(offset + 12, 0);
      data.setU32(offset + 16, 0);
    } else if (value is ShaderPreparedDecoration) {
      // print('- shader ${value.key}');
      data.setU32(offset + 0, DecorationKind.shader);
      data.setU32(offset + 4, value.key);
      data.setF32(offset + 8, 0.0);
      data.setF32(offset + 12, 0.0);
      data.setF32(offset + 16, 0.0);
    }
  }
}
