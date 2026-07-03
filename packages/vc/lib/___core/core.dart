import 'dart:collection';

import 'package:flutter/rendering.dart';

import 'package:color/color.dart';
import 'package:flutter/foundation.dart';
import 'package:stack/stack.dart';
import 'package:node/node.dart' as node;
import 'package:geometry/geometry.dart';
import 'package:vc/renderer.dart';

part 'complex/commit_stroke.dart';
part 'complex/cut_edge.dart';
part 'complex/hit_test_utils.dart';
part 'complex/intersections.dart';

part 'geometry/bundle.dart';
part 'geometry/geometry.dart';

part 'complex.dart';
part 'cell.dart';
part 'vertex.dart';
part 'edge.dart';

part 'edge/decoration.dart';
part 'edge/path.dart';
part 'edge/weights.dart';

part 'modifiers/modifier.dart';
part 'modifiers/edge/simplify_modifier.dart';
part 'modifiers/edge/mirror_modifier.dart';
