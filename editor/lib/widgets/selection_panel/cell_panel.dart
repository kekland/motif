import 'package:editor/imports.dart';

import 'cells/frame_panel.dart';
import 'cells/vertex_panel.dart';
import 'cells/edge_panel.dart';
import 'cells/face_panel.dart';

class const CellPanel({
  super.key,
  required final CellKey cellKey,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => switch (cellKey.kind) {
    .frame => FramePanel(cellKey: cellKey.asFrame),
    .vertex => VertexPanel(cellKey: cellKey.asVertex),
    .edge => EdgePanel(cellKey: cellKey.asEdge),
    .face => FacePanel(cellKey: cellKey.asFace),
  };
}
