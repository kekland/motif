import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

LineMetrics _lineMetricsFromNative(gen.line_metrics data) => .new(
  left: data.left,
  baseline: data.baseline,
  ascent: data.ascent,
  descent: data.descent,
  width: data.width,
  height: data.height,
  glyphStart: data.glyph_start,
  glyphEnd: data.glyph_end,
);

GlyphMetrics _glyphMetricsFromNative(gen.glyph_metrics data) => .new(
  x: data.x,
  y: data.y,
  left: data.left,
  top: data.top,
  right: data.right,
  bottom: data.bottom,
  id: data.id,
  font: data.font,
);

Path _pathFromNative(gen.glyph_path data) => Path(
  verbs: .new(data.verbs.asTypedList(data.verb_count)),
  points: .fromList(data.points.asTypedList(data.point_count * 2)),
);

final class Paragraph extends NativeObject<gen.paragraph> {
  Paragraph(super._ptr);
  static final _finalizer = NativeFinalizer(gen.addresses.motif_paragraph_destroy.cast());

  void layout(double width) => gen.motif_paragraph_layout(ptr, width);

  double get longestLine => gen.motif_paragraph_get_longest_line(ptr);
  double get height => gen.motif_paragraph_get_height(ptr);
  double get minIntrinsicWidth => gen.motif_paragraph_get_min_intrinsic_width(ptr);
  double get maxIntrinsicWidth => gen.motif_paragraph_get_max_intrinsic_width(ptr);

  Iterable<LineMetrics> get lineMetrics {
    final count = gen.motif_paragraph_get_line_metrics_count(ptr);
    final addr = gen.motif_paragraph_get_line_metrics(ptr);
    return .generate(count, (i) => _lineMetricsFromNative(addr[i]));
  }

  Iterable<GlyphMetrics> get glyphMetrics {
    final count = gen.motif_paragraph_get_glyph_metrics_count(ptr);
    final addr = gen.motif_paragraph_get_glyph_metrics(ptr);
    return .generate(count, (i) => _glyphMetricsFromNative(addr[i]));
  }

  Path getGlyphPath(int index) => _pathFromNative(gen.motif_paragraph_get_glyph_path(ptr, index).ref);

  Path getPath() {
    final metrics = glyphMetrics.toList();
    final paths = metrics.map((m) => getGlyphPath(metrics.indexOf(m))).toList();
    (double, double) offset(int i) => (metrics[i].x, metrics[i].y);
    return Path.join(paths, offset: offset);
  }

  @override
  void attachFinalizer(Pointer<Void> ptr) => _finalizer.attach(this, ptr, detach: this);

  @override
  void detachFinalizer() => _finalizer.detach(this);

  @override
  void destroy() => gen.motif_paragraph_destroy(ptr);
}
