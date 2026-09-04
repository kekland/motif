import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';

part 'key/index.dart';
part 'key/handle.dart';
part 'key/id.dart';

part 'utils/arena.dart';
part 'utils/storage.dart';
part 'utils/utils.dart';
part 'utils/mutation_utils.dart';
part 'utils/ops_utils.dart';
part 'utils/change_tracker.dart';
part 'utils/cycle_algebra.dart';

part 'elements/frame.dart';
part 'elements/vertex.dart';
part 'elements/covertex.dart';
part 'elements/edge.dart';
part 'elements/coedge.dart';
part 'elements/cycle.dart';
part 'elements/face.dart';

part 'bundle.dart';
part 'transaction.dart';

part 'methods/utility_methods.dart';
part 'methods/getter_methods.dart';
part 'methods/topology_methods.dart';
part 'methods/geometry_methods.dart';

part 'transaction/lineage.dart';
part 'transaction/delta.dart';
part 'transaction/mutation.dart';
part 'transaction/snapshot.dart';
part 'transaction/op.dart';

part 'mutations/frame_mutations.dart';
part 'mutations/vertex_mutations.dart';
part 'mutations/edge_mutations.dart';
part 'mutations/face_mutations.dart';

part 'ops/add_cell_ops.dart';
part 'ops/delete_cell_ops.dart';
part 'ops/cut_edge.dart';
part 'ops/fillet_vertex.dart';
part 'ops/fillet_face.dart';
part 'ops/make_face.dart';
