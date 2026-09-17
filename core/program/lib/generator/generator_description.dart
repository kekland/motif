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
final programSlice = SocketDescription(
  name: 'ProgramSlice',
  type: 'ProgramSlice',
  category: 'geometry',
  defaultValue: '.empty()',
);

final programSliceList = SocketDescription(
  name: 'ProgramSliceList',
  type: 'ProgramSlice',
  category: 'geometry',
  defaultValue: '[]',
  multi: true,
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
    .new(name: 'slices', type: programSliceList),
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
    .new(name: 'radius', type: vec2, socketType: .dynamic),
  ],
  outputs: [
    .new(name: 'slice', type: programSlice),
  ],
);
final numberNode = NodeDescription(
  name: 'Number',
  category: 'value',
  inputs: [.new(name: 'value', type: float)],
  outputs: [.new(name: 'value', type: float)],
);

final vectorNode = NodeDescription(
  name: 'Vector',
  category: 'value',
  inputs: [.new(name: 'value', type: vec2)],
  outputs: [.new(name: 'value', type: vec2)],
);

final verticesNode = NodeDescription(
  name: 'Vertices',
  category: 'primitive',
  inputs: [
    .new(name: 'count', type: integer),
    .new(name: 'position', type: vec2, socketType: .dynamic),
  ],
  outputs: [.new(name: 'slice', type: programSlice)],
);

final randomVectorNode = NodeDescription(
  name: 'RandomVector',
  category: 'value',
  inputs: [
    .new(name: 'seed', type: integer),
    .new(name: 'min', type: vec2, socketType: .dynamic),
    .new(name: 'max', type: vec2, socketType: .dynamic),
  ],
  outputs: [
    .new(name: 'value', type: vec2, socketType: .dynamic),
  ],
);

final indexNode = NodeDescription(
  name: 'Index',
  category: 'value',
  outputs: [.new(name: 'value', type: integer, socketType: .dynamic)],
);

final scaleVectorNode = NodeDescription(
  name: 'ScaleVector',
  category: 'value',
  inputs: [
    .new(name: 'vector', type: vec2, socketType: .dynamic),
    .new(name: 'factor', type: float, socketType: .dynamic),
  ],
  outputs: [.new(name: 'value', type: vec2, socketType: .dynamic)],
);

final connectVerticesNode = NodeDescription(
  name: 'ConnectVertices',
  category: 'geometry',
  inputs: [
    .new(name: 'slice', type: programSlice),
    .new(name: 'closed', type: boolean),
  ],
  outputs: [.new(name: 'slice', type: programSlice)],
);

final faceNode = NodeDescription(
  name: 'Face',
  category: 'geometry',
  inputs: [.new(name: 'slice', type: programSlice)],
  outputs: [.new(name: 'slice', type: programSlice)],
);

final polarNode = NodeDescription(
  name: 'Polar',
  category: 'math',
  inputs: [
    .new(name: 'radius', type: float, socketType: .dynamic),
    .new(name: 'angle', type: float, socketType: .dynamic),
  ],
  outputs: [
    .new(name: 'value', type: vec2, socketType: .dynamic),
  ],
);

final piNode = NodeDescription(
  name: 'Pi',
  category: 'math',
  outputs: [.new(name: 'value', type: float, socketType: .constant)],
);

final divideNode = NodeDescription(
  name: 'Divide',
  category: 'math',
  inputs: [
    .new(name: 'numerator', type: float, socketType: .dynamic),
    .new(name: 'denominator', type: float, socketType: .dynamic),
  ],
  outputs: [.new(name: 'value', type: float, socketType: .dynamic)],
);

// ---------------------------------------------------------------------------------------------------------------------
// Generator
// ---------------------------------------------------------------------------------------------------------------------

final sockets = [
  vec2,
  integer,
  float,
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
  numberNode,
  vectorNode,
  verticesNode,
  randomVectorNode,
  indexNode,
  scaleVectorNode,
  connectVerticesNode,
  faceNode,
  polarNode,
  piNode,
  divideNode,
];
