import 'dart:math' as math;

import 'package:geometry/geometry.dart';

import 'package:geometry/ffi/ffi.dart' as ffi;

part 'types/knot.dart';
part 'types/cubic.dart';
part 'types/spline.dart';

part 'algorithms/bernstein.dart';
part 'algorithms/de_casteljau.dart';
part 'algorithms/schneider.dart';

part 'methods/_defaults.dart';
part 'methods/bbox.dart';
part 'methods/closest_point.dart';
part 'methods/evaluate.dart';
part 'methods/arc_length.dart';
part 'methods/flatten.dart';
part 'methods/inflections.dart';
part 'methods/intersection.dart';
part 'methods/quadratic.dart';
part 'methods/spline.dart';
part 'methods/split.dart';

part 'methods_ffi/methods_ffi.dart';

// part 'utils/arc_length_profile.dart';
// part 'utils/parameter_profile.dart';
// part 'utils/profile.dart';
part 'utils/utils.dart';
