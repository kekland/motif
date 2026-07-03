import 'package:blueprint/blueprint.dart';
import 'package:flutter/foundation.dart';

import 'blueprint.dart';

export 'generator_manager.dart';
export 'blueprint.dart';

class Generator extends Blueprint {
  Generator() : id = shortHash(UniqueKey()) {
    outputNode = GeometryOutputNode();
    addNode(outputNode, isStatic: true);
  }

  final String id;
  late final GeometryOutputNode outputNode;
}

class GeneratorBlueprintController extends BlueprintController<Generator> {
  GeneratorBlueprintController(super.blueprint);
}
