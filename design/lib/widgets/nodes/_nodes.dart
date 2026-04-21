import 'dart:async';

import 'package:design/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:tree/widgets.dart' as tree;

part 'core/node_layout_transform.dart';
part 'core/node_builder.dart';

part 'root_node.dart';
part 'container_node.dart';
part 'text_node.dart';

typedef SelectionController = tree.SelectionController<Node>;
typedef NodeHitTestResult = tree.NodeHitTestResult<RenderNode>;
typedef NodeHitTestEntry = tree.NodeHitTestEntry<RenderNode>;

class NodeWidget extends StatelessWidget {
  const NodeWidget({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context) {
    return switch (node) {
      ContainerNode() => ContainerNodeWidget(node: node as ContainerNode),
      TextNode() => TextNodeWidget(node: node as TextNode),
      _ => throw UnimplementedError('Unsupported node type: ${node.runtimeType}'),
    };
  }
}
