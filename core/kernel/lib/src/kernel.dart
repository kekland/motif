import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';

part 'id.dart';
part 'handle.dart';
part 'bundle.dart';
part 'view.dart';
part 'delta.dart';
part 'history.dart';
part 'op.dart';
part 'transaction.dart';
part 'queries.dart';
part 'validate.dart';

part 'elements/frame.dart';
part 'elements/vertex.dart';
part 'elements/covertex.dart';
part 'elements/edge.dart';
part 'elements/coedge.dart';
part 'elements/cycle.dart';
part 'elements/face.dart';

part 'utils/arena.dart';
part 'utils/cycle_algebra.dart';
part 'utils/element.dart';
part 'utils/ops_utils.dart';
part 'utils/storage.dart';
part 'utils/utils.dart';

part 'private/tree_methods.dart';
part 'private/frame_methods.dart';
part 'private/vertex_methods.dart';
part 'private/covertex_methods.dart';
part 'private/edge_methods.dart';
part 'private/coedge_methods.dart';
part 'private/cycle_methods.dart';
part 'private/face_methods.dart';

part 'microops/mutate_frame.dart';
part 'microops/mutate_vertex.dart';
part 'microops/mutate_edge.dart';
part 'microops/mutate_face.dart';
part 'microops/repoint_edge.dart';
part 'microops/set_frame_transform.dart';
part 'microops/set_frame_size.dart';
part 'microops/set_vertex_position.dart';
part 'microops/set_edge_tangents.dart';
part 'microops/set_face_boundary.dart';
part 'microops/splice_cycle.dart';
part 'microops/place_cell.dart';
part 'microops/set_frame_clip.dart';

part 'ops/make_face.dart';
part 'ops/collapse_edge.dart';
part 'ops/glue_vertices.dart';
part 'ops/cut_edge.dart';

part 'arrangement/arrangement.dart';

part 'queries/nearest_vertex.dart';
part 'queries/nearest_edge.dart';
part 'queries/faces_at.dart';
part 'queries/frame_bounds.dart';
part 'queries/hit_test.dart';
part 'queries/hit_test_rect.dart';
