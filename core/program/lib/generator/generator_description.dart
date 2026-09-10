import 'package:blueprint/generator.dart';

// ---------------------------------------------------------------------------------------------------------------------
// Sockets
// ---------------------------------------------------------------------------------------------------------------------

final vec2 = SocketDescription(
  name: 'Vector',
  type: 'Vec2',
  category: 'vector',
  defaultValue: '.zero()',
);

final integer = SocketDescription(
  name: 'Integer',
  type: 'int',
  category: 'int',
  defaultValue: '0',
);

final float = SocketDescription(
  name: 'Float',
  type: 'double',
  category: 'float',
  defaultValue: '0.0',
);

final rotation = SocketDescription(
  name: 'Rotation',
  type: 'Angle2',
  category: 'float',
  defaultValue: '.zero',
);

final programSlice = SocketDescription(
  name: 'ProgramSlice',
  type: 'ProgramSlice',
  category: 'geometry',
  defaultValue: '.empty()',
);

final boolean = SocketDescription(
  name: 'Boolean',
  type: 'bool',
  category: 'boolean',
  defaultValue: 'false',
);

final color = SocketDescription(
  name: 'Color',
  type: 'ColorData',
  category: 'color',
  defaultValue: '.white',
);

final aabb = SocketDescription(
  name: 'Bounds',
  type: 'Aabb2',
  category: 'geometry',
  defaultValue: '.invertedInfinity()',
);

// final statementKind = SocketDescription(
//   name: 'StatementKind',
//   type: 'StatementKind',
//   category: 'statement',
//   defaultValue: '.any',
// );

// ---------------------------------------------------------------------------------------------------------------------
// Nodes
// ---------------------------------------------------------------------------------------------------------------------

final inputNode = NodeDescription(
  name: 'GeneratorInput',
  category: 'geometry',
  outputs: [
    .new(name: 'slice', type: programSlice),
  ],
);

final outputNode = NodeDescription(
  name: 'GeneratorOutput',
  category: 'geometry',
  inputs: [
    .new(name: 'slice', type: programSlice),
  ],
);

final arrayNode = NodeDescription(
  name: 'Array',
  category: 'geometry',
  inputs: [
    .new(name: 'slice', type: programSlice),
    .new(name: 'count', type: vec2),
    .new(name: 'offset', type: vec2),
  ],
  outputs: [
    .new(name: 'slice', type: programSlice),
  ],
);

final filletNode = NodeDescription(
  name: 'Fillet',
  category: 'geometry',
  inputs: [
    .new(name: 'slice', type: programSlice),
    .new(name: 'radius', type: vec2),
  ],
  outputs: [
    .new(name: 'slice', type: programSlice),
  ],
);

final vertexNode = NodeDescription(
  name: 'Vertex',
  category: 'primitive',
  inputs: [
    .new(name: 'position', type: vec2),
  ],
  outputs: [
    .new(name: 'slice', type: programSlice),
  ],
);

// ---------------------------------------------------------------------------------------------------------------------
// Generator
// ---------------------------------------------------------------------------------------------------------------------

final sockets = [
  vec2,
  integer,
  float,
  rotation,
  programSlice,
  boolean,
  color,
  aabb,
  // statementKind,
];

final nodes = [
  inputNode,
  outputNode,
  arrayNode,
  filletNode,
  vertexNode,
];
