import 'package:blueprint/blueprint_generator.dart';

// ---------------------------------------------------------------------------------------------------------------------
// Sockets
// ---------------------------------------------------------------------------------------------------------------------

final any = SocketDescription(
  name: 'Any',
  type: 'Object?',
  category: 'any',
  defaultValue: 'null',
);

final anyList = SocketDescription(
  name: 'AnyList',
  type: 'Object?',
  category: 'any',
  defaultValue: '[]',
  multi: true,
);

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

final string = SocketDescription(
  name: 'String',
  type: 'String',
  category: 'string',
  defaultValue: "''",
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

final mathOperatorType = SocketDescription(
  name: 'MathOperatorType',
  type: 'MathOperatorType',
  category: 'math',
  defaultValue: '.add',
  enum_: true,
  enumValues: ['add', 'subtract', 'multiply', 'divide'],
);

final vectorMathOperatorType = SocketDescription(
  name: 'VectorMathOperatorType',
  type: 'VectorMathOperatorType',
  category: 'math',
  defaultValue: '.add',
  enum_: true,
  enumValues: ['add', 'subtract'],
);

final trigMathOperatorType = SocketDescription(
  name: 'TrigMathOperatorType',
  type: 'TrigMathOperatorType',
  category: 'math',
  defaultValue: '.sin',
  enum_: true,
  enumValues: ['sin', 'cos', 'tan', 'arcsin', 'arccos', 'arctan'],
);

final mathConstantType = SocketDescription(
  name: 'MathConstantType',
  type: 'MathConstantType',
  category: 'math',
  defaultValue: '.pi',
  enum_: true,
  enumValues: ['pi', 'e'],
);

final mathRoundType = SocketDescription(
  name: 'MathRoundType',
  type: 'MathRoundType',
  category: 'math',
  defaultValue: '.round',
  enum_: true,
  enumValues: ['floor', 'ceil', 'round'],
);

// ---------------------------------------------------------------------------------------------------------------------
// Nodes
// ---------------------------------------------------------------------------------------------------------------------

// I/O nodes

const _io = 'io';

final ioNodes = <NodeDescription>[
  .new(
    name: 'GeneratorInput',
    category: _io,
    outputs: [
      .constant(name: 'slice', type: programSlice),
    ],
  ),
  .new(
    name: 'GeneratorOutput',
    category: _io,
    inputs: [
      .dynamic(name: 'slices', type: programSliceList),
    ],
  ),
  .new(
    name: 'Merge',
    category: 'geometry',
    inputs: [
      .new(name: 'slices', type: programSliceList),
    ],
    outputs: [
      .new(name: 'slice', type: programSlice),
    ],
  ),
];

// Primitive nodes

const _primitive = 'primitive';

final primitiveNodes = <NodeDescription>[
  .new(
    name: 'Vertex',
    category: _primitive,
    inputs: [.dynamic(name: 'position', type: vec2)],
    outputs: [.dynamic(name: 'slice', type: programSlice)],
  ),
  .new(
    name: 'Rectangle',
    category: _primitive,
    inputs: [
      .dynamic(name: 'center', type: vec2),
      .dynamic(name: 'size', type: vec2, defaultValue: '.new(100.0, 100.0)'),
    ],
    outputs: [
      .dynamic(name: 'slice', type: programSlice),
    ],
  ),
];

const _geometry = 'geometry';

final geometryNodes = <NodeDescription>[
  .new(
    name: 'Array',
    category: _geometry,
    inputs: [
      .dynamic(name: 'slice', type: programSlice),
      .dynamic(name: 'offset', type: vec2),
      .dynamic(name: 'count', type: vec2, defaultValue: '.new(1, 1)'),
    ],
    outputs: [
      .dynamic(name: 'slice', type: programSlice),
    ],
  ),
  .new(
    name: 'Transform',
    category: _geometry,
    inputs: [
      .dynamic(name: 'slice', type: programSlice),
      .dynamic(name: 'translation', type: vec2),
      .dynamic(name: 'scale', type: vec2, defaultValue: '.new(1.0, 1.0)'),
      .dynamic(name: 'rotation', type: float, defaultValue: '0.0'),
    ],
    outputs: [
      .dynamic(name: 'slice', type: programSlice),
    ],
  ),
  .new(
    name: 'ConnectVertices',
    category: _geometry,
    inputs: [
      .constant(name: 'closed', type: boolean),
      .dynamic(name: 'slice', type: programSlice),
    ],
    outputs: [.dynamic(name: 'slice', type: programSlice)],
  ),
  .new(
    name: 'MakeFace',
    category: _geometry,
    inputs: [.dynamic(name: 'slice', type: programSlice)],
    outputs: [.dynamic(name: 'slice', type: programSlice)],
  ),
];

const _query = 'query';

final queryNodes = <NodeDescription>[
  .new(
    name: 'BoundingBox',
    category: _query,
    inputs: [
      .dynamic(name: 'slice', type: programSlice),
    ],
    outputs: [
      .dynamic(name: 'bbox', type: aabb),
      .dynamic(name: 'min', type: vec2),
      .dynamic(name: 'max', type: vec2),
      .dynamic(name: 'center', type: vec2),
      .dynamic(name: 'size', type: vec2),
    ],
  ),
];

// Field access nodes

const _field = 'field';

final fieldNodes = <NodeDescription>[
  .new(
    name: 'Index',
    category: _field,
    outputs: [.dynamic(name: 'index', type: integer)],
  ),
];

// Math nodes

const _math = 'math';

final mathNodes = <NodeDescription>[
  .new(
    name: 'Math',
    category: _math,
    inputs: [
      .dynamic(name: 'a', type: float),
      .dynamic(name: 'b', type: float),
      .constant(name: 'operator', type: mathOperatorType),
    ],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'VectorMath',
    category: _math,
    inputs: [
      .dynamic(name: 'a', type: vec2),
      .dynamic(name: 'b', type: vec2),
      .constant(name: 'operator', type: vectorMathOperatorType),
    ],
    outputs: [.dynamic(name: 'value', type: vec2)],
  ),
  .new(
    name: 'TrigMath',
    category: _math,
    inputs: [
      .dynamic(name: 'input', type: float),
      .constant(name: 'operator', type: trigMathOperatorType),
    ],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'Expression',
    category: _math,
    inputs: [
      .dynamic(name: 'args', type: anyList),
      .constant(name: 'expression', type: string),
    ],
    outputs: [.dynamic(name: 'value', type: any)],
  ),
  .new(
    name: 'MathConstant',
    category: _math,
    inputs: [.constant(name: 'constant', type: mathConstantType)],
    outputs: [.constant(name: 'value', type: float)],
  ),
  .new(
    name: 'MathRound',
    category: _math,
    inputs: [
      .dynamic(name: 'value', type: float),
      .constant(name: 'mode', type: mathRoundType),
    ],
    outputs: [.dynamic(name: 'value', type: integer)],
  ),
  .new(
    name: 'CombineXY',
    category: _math,
    inputs: [
      .dynamic(name: 'x', type: float),
      .dynamic(name: 'y', type: float),
    ],
    outputs: [.dynamic(name: 'value', type: vec2)],
  ),
  .new(
    name: 'SeparateXY',
    category: _math,
    inputs: [
      .dynamic(name: 'value', type: vec2),
    ],
    outputs: [
      .dynamic(name: 'x', type: float),
      .dynamic(name: 'y', type: float),
    ],
  ),
  .new(
    name: 'Polar',
    category: _math,
    inputs: [
      .dynamic(name: 'radius', type: float),
      .dynamic(name: 'angle', type: float),
    ],
    outputs: [.dynamic(name: 'value', type: vec2)],
  ),
  .new(
    name: 'RandomFloat',
    category: _math,
    inputs: [
      .constant(name: 'seed', type: integer),
      .constant(name: 'min', type: float, defaultValue: '0.0'),
      .constant(name: 'max', type: float, defaultValue: '1.0'),
    ],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'RandomVector',
    category: _math,
    inputs: [
      .constant(name: 'seed', type: integer),
      .constant(name: 'min', type: vec2, defaultValue: '.new(0.0, 0.0)'),
      .constant(name: 'max', type: vec2, defaultValue: '.new(1.0, 1.0)'),
    ],
    outputs: [.dynamic(name: 'value', type: vec2)],
  ),
];

// Utility nodes

// const _utility = 'utility';

final utilityNodes = <NodeDescription>[
  // .new(
  //   name: 'Repeat',
  //   category: _utility,
  //   inputs: [
  //     .dynamic(name: 'slice', type: programSlice),
  //     .constant(name: 'count', type: integer),
  //   ],
  //   outputs: [
  //     .dynamic(name: 'slice', type: programSlice),
  //   ],
  // ),
  // .new(
  //   name: 'Filter',
  //   category: _utility,
  //   inputs: [
  //     .dynamic(name: 'slice', type: programSlice),
  //     .constant(name: 'condition', type: boolean),
  //   ],
  //   outputs: [
  //     .dynamic(name: 'slice', type: programSlice),
  //   ],
  // ),
];

// ---------------------------------------------------------------------------------------------------------------------
// Generator
// ---------------------------------------------------------------------------------------------------------------------

final sockets = [
  any,
  anyList,
  vec2,
  integer,
  float,
  string,
  programSlice,
  boolean,
  color,
  aabb,
  mathOperatorType,
  vectorMathOperatorType,
  trigMathOperatorType,
  mathConstantType,
  mathRoundType,
];

final nodes = [
  ...ioNodes,
  ...primitiveNodes,
  ...geometryNodes,
  ...queryNodes,
  ...fieldNodes,
  ...mathNodes,
  ...utilityNodes,
];
