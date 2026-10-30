import 'package:blueprint/blueprint_generator.dart';

import 'shared_description.dart';

// ---------------------------------------------------------------------------------------------------------------------
// Sockets
// ---------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------------------
// Nodes
// ---------------------------------------------------------------------------------------------------------------------

// I/O nodes

const _io = 'io';

final ioNodes = <NodeDescription>[
  .new(
    name: 'ShaderInput',
    category: _io,
    outputs: [
      .constant(name: 'worldPosition', type: vec2),
      .constant(name: 'localPosition', type: vec2),
    ],
  ),
  .new(
    name: 'ShaderOutput',
    category: _io,
    inputs: [
      .dynamic(name: 'color', type: color),
    ],
  ),
];

// ---------------------------------------------------------------------------------------------------------------------
// Generator
// ---------------------------------------------------------------------------------------------------------------------

final sockets = <SocketDescription>[
];

final nodes = <NodeDescription>[
  ...ioNodes,
];
