part of '../shader.dart';

final class ShaderInputNode extends ShaderInputNodeBase with NoOpNode {
  ShaderInputNode({NodeId? id}) : super(id: id ?? .generate());
}

final class ShaderOutputNode extends ShaderOutputNodeBase with NoOpNode {
  ShaderOutputNode({NodeId? id, super.color}) : super(id: id ?? .generate());
}
