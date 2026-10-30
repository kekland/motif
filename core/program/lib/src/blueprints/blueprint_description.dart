import 'package:blueprint/generator/blueprint_generator.dart';

import 'shared_description.dart';
import 'shader_description.dart' as shader;
import 'generator_description.dart' as generator;

final sockets = <SocketDescription>[
  ...sharedSockets,
  ...shader.sockets,
  ...generator.sockets,
];

final nodes = <NodeDescription>[
  ...sharedNodes,
  ...shader.nodes,
  ...generator.nodes,
];
