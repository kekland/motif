import 'dart:typed_data';

import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

final class LineMetrics {
  LineMetrics._(gen.line_metrics data)
    : left = data.left,
      baseline = data.baseline,
      ascent = data.ascent,
      descent = data.descent,
      width = data.width,
      height = data.height,
      glyphStart = data.glyph_start,
      glyphEnd = data.glyph_end;

  final double left, baseline, ascent, descent, width, height;
  final int glyphStart, glyphEnd;
}

final class GlyphMetrics {
  GlyphMetrics._(gen.glyph_metrics data)
    : x = data.x,
      y = data.y,
      left = data.left,
      top = data.top,
      right = data.right,
      bottom = data.bottom,
      id = data.id,
      font = data.font;

  final double x, y;
  final double left, top, right, bottom;
  final int id, font;
}

extension type const PathVerb._(int value) {
  static const move = PathVerb._(0);
  static const line = PathVerb._(1);
  static const quad = PathVerb._(2);
  static const conic = PathVerb._(3);
  static const cubic = PathVerb._(4);
  static const close = PathVerb._(5);
}

extension type const PathVerbList._(Uint8List value) implements Uint8List {
  PathVerbList.fromList(List<int> value) : this._(Uint8List.fromList(value));

  int get length => value.length;
  PathVerb operator [](int index) => PathVerb._(value[index]);
}

final class Path {
  Path({required this.verbs, required this.points});

  Path._(gen.glyph_path data)
    : verbs = .fromList(data.verbs.asTypedList(data.verb_count)),
      points = .fromList(data.points.asTypedList(data.point_count * 2));

  static Path join(Iterable<Path> paths, {(double, double) Function(int i)? offset}) {
    final verbCount = paths.fold<int>(0, (s, p) => s + p.verbs.length);
    final pointCount = paths.fold<int>(0, (s, p) => s + p.points.length);

    final verbs = Uint8List(verbCount);
    final points = Float32List(pointCount);

    var verbOffset = 0;
    var pointOffset = 0;
    for (final (i, path) in paths.indexed) {
      verbs.setRange(verbOffset, verbOffset + path.verbs.length, path.verbs);
      verbOffset += path.verbs.length;

      final (x, y) = offset?.call(i) ?? (0, 0);
      for (var j = 0; j < path.points.length; j += 2) {
        points[pointOffset + j] = path.points[j] + x;
        points[pointOffset + j + 1] = path.points[j + 1] + y;
      }

      pointOffset += path.points.length;
    }

    return Path(verbs: ._(verbs), points: points);
  }

  final PathVerbList verbs;
  final Float32List points;
}

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
    return .generate(count, (i) => ._(addr[i]));
  }

  Iterable<GlyphMetrics> get glyphMetrics {
    final count = gen.motif_paragraph_get_glyph_metrics_count(ptr);
    final addr = gen.motif_paragraph_get_glyph_metrics(ptr);
    return .generate(count, (i) => GlyphMetrics._(addr[i]));
  }

  Path getGlyphPath(int index) => ._(gen.motif_paragraph_get_glyph_path(ptr, index).ref);

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
