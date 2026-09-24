import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:listen/listen.dart';
import 'package:shared/shared.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:color/color.dart';

import 'package:schema/codec.dart' as codec;
import 'package:schema/program.dart' as gen;

import 'generator/generator.dart';
export 'generator/generator.dart';

part 'errors.dart';
part 'program.dart';
part 'id.dart';
part 'selector.dart';
part 'statement.dart';
part 'modifier.dart';
part 'evaluation.dart';
part 'slice.dart';
part 'delta.dart';
part 'remap.dart';
part 'edit.dart';
part 'serializer.dart';

part 'style/style.dart';
part 'style/style_table.dart';
part 'style/vertex_style.dart';
part 'style/edge_style.dart';
part 'style/face_style.dart';

part 'zorder/zorder.dart';
part 'zorder/zorder_table.dart';

part 'evaluation/context.dart';
part 'evaluation/commit.dart';
part 'evaluation/tree.dart';
part 'evaluation/pass.dart';
part 'evaluation/evaluator.dart';
part 'evaluation/indexes/graph.dart';
part 'evaluation/indexes/lineage.dart';
part 'evaluation/indexes/live.dart';
part 'evaluation/indexes/style.dart';
part 'evaluation/indexes/zorder.dart';
part 'evaluation/indexes/transient_transform.dart';

part 'layout/shape.dart';
part 'layout/size.dart';
part 'layout/insets.dart';
part 'layout/align.dart';
part 'layout/layout.dart';
part 'layout/tree.dart';
part 'layout/layouts/stack.dart';
part 'layout/layouts/flex.dart';
part 'layout/shapes/rectangle_shape.dart';
part 'layout/shapes/ellipse_shape.dart';
part 'layout/shapes/polygon_shape.dart';

part 'selectors/cell_selector.dart';
part 'selectors/parent_selector.dart';
part 'selectors/chain_selector.dart';
part 'selectors/fragment_selector.dart';

part 'statements/base/placed_statement.dart';
part 'statements/base/generating_statement.dart';
part 'statements/base/layout_box_statement.dart';
part 'statements/base/shape_statement.dart';
part 'statements/base/faced_statement.dart';
part 'statements/base/framed_statement.dart';

part 'statements/shapes/container_statement.dart';
part 'statements/shapes/rectangle_statement.dart';
part 'statements/shapes/polygon_statement.dart';
part 'statements/shapes/ellipse_statement.dart';

part 'statements/vertex_statement.dart';
part 'statements/edge_statement.dart';
part 'statements/face_statement.dart';

part 'statements/group_statement.dart';
part 'statements/cut_edge_statement.dart';
part 'statements/multi_cut_edge_statement.dart';
part 'statements/glue_vertices_statement.dart';
part 'statements/fillet_face_statement.dart';
part 'statements/generator_statement.dart';

part 'modifiers/fillet_modifier.dart';

part 'delta/anchor.dart';
part 'delta/change.dart';

part 'routers/transform_router.dart';
part 'routers/zorder_router.dart';
part 'routers/bake_router.dart';
part 'routers/dissolve_router.dart';
part 'routers/delete_router.dart';
part 'routers/flatten_router.dart';
part 'routers/reparent_router.dart';
part 'routers/slice_router.dart';
part 'routers/generator_router.dart';

final _log = Logger('program');
