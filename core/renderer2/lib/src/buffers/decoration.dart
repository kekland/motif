import 'package:program/program.dart';
import 'package:renderer2/renderer.dart';
import 'package:shared/shared.dart';

final class DecorationStorage extends SpanStorage<Decoration> {
  @override
  int get elementSizeInBytes => 4 + 4 * 4;

  @override
  void set(int offset, Decoration value) {
    if (value.kind == .color) {
      final color = (value as ColorDecoration).color;
      final rgb = color.cssColor.convertTo(.srgb);

      data.setU32(offset, 1);
      data.setF32(offset + 4, rgb.storage.$1);
      data.setF32(offset + 8, rgb.storage.$2);
      data.setF32(offset + 12, rgb.storage.$3);
      data.setF32(offset + 16, rgb.alpha);
    } else if (value.kind == .shader) {
      data.setU32(offset, 2);
      data.setU32(offset + 4, Mix64.hashInt(value.id.hashCode));
    } else {
      data.setU32(offset, 0);
    }
  }
}
