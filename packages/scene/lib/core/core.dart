import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:geometry/geometry.dart';
import 'package:stack/stack.dart';

part 'scene.dart';
part 'node.dart';
part 'cell.dart';
part 'object.dart';

part 'node/node_id.dart';
part 'node/node_base.dart';
part 'node/node_snapshot.dart';
part 'node/node_type.dart';
part 'node/node_update_aspect.dart';
part 'node/node_notifier.dart';

part 'cell/vertex.dart';
part 'cell/edge.dart';
part 'cell/edge/edge_knot.dart';
part 'cell/edge/edge_path.dart';

part 'object/object_transform.dart';
part 'object/object_size.dart';
part 'object/multi_child_object.dart';
part 'object/topological_object.dart';

part 'objects/container.dart';
part 'objects/container/child_layout.dart';
part 'objects/container/flex.dart';
part 'objects/container/stack.dart';
part 'objects/rectangle.dart';
part 'objects/root.dart';

part 'scene/scene_update.dart';
part 'scene/scene_topology.dart';
part 'scene/scene_scheduler.dart';
part 'scene/scene_transient_transform.dart';

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
