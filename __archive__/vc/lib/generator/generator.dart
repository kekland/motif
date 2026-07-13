import 'package:blueprint/blueprint.dart';
import 'package:flutter/foundation.dart';
import '../vc.dart';

import 'blueprint.dart';

export 'generator_manager.dart';
export 'generator_editor.dart';
export 'blueprint.dart';

class Generator extends Blueprint {
  Generator() : id = shortHash(UniqueKey()) {
    final inputNode = GeometryInputNode();
    addNode(inputNode, position: .new(-160.0, 0.0));

    outputNode = GeometryOutputNode();
    addNode(outputNode, isStatic: true, position: .new(160.0, 0.0));

    connect(inputNode.o.geometry, outputNode.i.geometry);
  }

  final String id;
  late final GeometryOutputNode outputNode;

  PrimitiveBundle execute(Cell cell, VectorComplexContext context) {
    addEnvironment<Cell>(cell);
    addEnvironment<VectorComplexContext>(context);
    return outputNode.execute();
  }
}

class GeneratorBlueprintController extends BlueprintController<Generator> {
  GeneratorBlueprintController(super.blueprint);
}
