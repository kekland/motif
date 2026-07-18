import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:geometry/geometry.dart';
import 'package:stack/stack.dart';

part 'scene.dart';
part 'node.dart';
part 'cell.dart';
part 'object.dart';

part 'cell/vertex.dart';
part 'cell/edge.dart';
part 'cell/edge/edge_knot.dart';
part 'cell/edge/edge_path.dart';

part 'object/transform.dart';
part 'object/size.dart';
part 'object/multi_child_object.dart';
part 'object/topological_object.dart';

part 'objects/container.dart';
part 'objects/rectangle.dart';
part 'objects/root.dart';

part 'scene/scene_layout.dart';
part 'scene/scene_listeners.dart';
part 'scene/scene_topology.dart';

part 'hit_test/hit_test.dart';
part 'hit_test/hit_test_result.dart';
part 'hit_test/hit_test_cell.dart';
part 'hit_test/hit_test_rect.dart';

part 'layout/constraints.dart';
part 'layout/size.dart';
part 'layout/layout.dart';

part 'topology/topology.dart';
part 'topology/interesections.dart';
part 'topology/cut_edge.dart';
part 'topology/commit_stroke.dart';

part 'snapshot/node_snapshot.dart';