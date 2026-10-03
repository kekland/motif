import '_base.dart';

import 'package:schema/skia.dart' as gen;
import 'package:skia/skia.dart' as skia;

// dart format off

extension PathDecode on gen.Path { skia.Path decode() => _glyphPathCodec.decode(this); }
extension PathEncode on skia.Path { gen.Path encode() => _glyphPathCodec.encode(this); }

final _glyphPathCodec = $codec<skia.Path, gen.Path>(
  decoder: (v) => .new(verbs: .fromList(v.verbs), points: .fromList(v.points)),
  encoder: (v) => .new(verbs: v.verbs.toList(), points: v.points.toList()),
);