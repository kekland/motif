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

final mathCompareType = SocketDescription(
  name: 'MathCompareType',
  type: 'MathCompareType',
  category: 'math',
  defaultValue: '.equal',
  enum_: true,
  enumValues: ['equal', 'notEqual', 'less', 'lessOrEqual', 'greater', 'greaterOrEqual'],
);

final interpolationType = SocketDescription(
  name: 'InterpolationType',
  type: 'InterpolationType',
  category: 'math',
  defaultValue: '.linear',
  enum_: true,
  enumValues: ['linear', 'step', 'smoothstep'],
);

// ---------------------------------------------------------------------------------------------------------------------
// Nodes
// ---------------------------------------------------------------------------------------------------------------------

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
    name: 'Wrap',
    category: _math,
    inputs: [
      .dynamic(name: 'value', type: float),
      .constant(name: 'min', type: float),
      .constant(name: 'max', type: float, defaultValue: '1.0'),
    ],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'WrapVector',
    category: _math,
    inputs: [
      .dynamic(name: 'value', type: vec2),
      .constant(name: 'min', type: vec2),
      .constant(name: 'max', type: vec2, defaultValue: '.new(1.0, 1.0)'),
    ],
    outputs: [.dynamic(name: 'value', type: vec2)],
  ),
  .new(
    name: 'Abs',
    category: _math,
    inputs: [.dynamic(name: 'value', type: float)],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'AbsVector',
    category: _math,
    inputs: [.dynamic(name: 'value', type: vec2)],
    outputs: [.dynamic(name: 'value', type: vec2)],
  ),
  .new(
    name: 'Sign',
    category: _math,
    inputs: [.dynamic(name: 'value', type: float)],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'SignVector',
    category: _math,
    inputs: [.dynamic(name: 'value', type: vec2)],
    outputs: [.dynamic(name: 'value', type: vec2)],
  ),
  .new(
    name: 'RotateVector',
    category: _math,
    inputs: [
      .dynamic(name: 'vector', type: vec2),
      .dynamic(name: 'angle', type: float),
      .dynamic(name: 'pivot', type: vec2),
    ],
    outputs: [.dynamic(name: 'value', type: vec2)],
  ),
  .new(
    name: 'VectorMagnitude',
    category: _math,
    inputs: [.dynamic(name: 'vector', type: vec2)],
    outputs: [.dynamic(name: 'value', type: float)],
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
  .new(
    name: 'Compare',
    category: _math,
    inputs: [
      .dynamic(name: 'a', type: float),
      .dynamic(name: 'b', type: float),
      .constant(name: 'epsilon', type: float, defaultValue: '1e-6'),
      .constant(name: 'type', type: mathCompareType),
    ],
    outputs: [.dynamic(name: 'result', type: boolean)],
  ),
  .new(
    name: 'BooleanToFloat',
    category: _math,
    inputs: [.dynamic(name: 'value', type: boolean)],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'MapRange',
    category: _math,
    inputs: [
      .dynamic(name: 'value', type: float),
      .dynamic(name: 'fromMin', type: float),
      .dynamic(name: 'fromMax', type: float),
      .dynamic(name: 'outMin', type: float),
      .dynamic(name: 'outMax', type: float),
      .constant(name: 'clamp', type: boolean, defaultValue: 'true'),
      .constant(name: 'interpolation', type: interpolationType),
    ],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'Deg2Rad',
    category: _math,
    inputs: [.dynamic(name: 'value', type: float)],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
  .new(
    name: 'Rad2Deg',
    category: _math,
    inputs: [.dynamic(name: 'value', type: float)],
    outputs: [.dynamic(name: 'value', type: float)],
  ),
];

// Color nodes

const _color = 'color';

final colorNodes = <NodeDescription>[
  .new(
    name: 'ColorFromRGBA',
    category: _color,
    inputs: [
      .dynamic(name: 'r', type: float),
      .dynamic(name: 'g', type: float),
      .dynamic(name: 'b', type: float),
      .dynamic(name: 'a', type: float),
    ],
    outputs: [.dynamic(name: 'value', type: color)],
  ),
  .new(
    name: 'ColorToRGBA',
    category: _color,
    inputs: [.dynamic(name: 'value', type: color)],
    outputs: [
      .dynamic(name: 'r', type: float),
      .dynamic(name: 'g', type: float),
      .dynamic(name: 'b', type: float),
      .dynamic(name: 'a', type: float),
    ],
  ),
  .new(
    name: 'ColorMix',
    category: _color,
    inputs: [
      .dynamic(name: 'a', type: color),
      .dynamic(name: 'b', type: color),
      .dynamic(name: 't', type: float, defaultValue: '0.5'),
    ],
    outputs: [.dynamic(name: 'value', type: color)],
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
// Output
// ---------------------------------------------------------------------------------------------------------------------

final sharedSockets = <SocketDescription>[
  any,
  anyList,
  vec2,
  integer,
  float,
  boolean,
  color,
  aabb,
  mathOperatorType,
  vectorMathOperatorType,
  trigMathOperatorType,
  mathConstantType,
  mathRoundType,
  mathCompareType,
  interpolationType,
];

final sharedNodes = <NodeDescription>[
  ...mathNodes,
  ...colorNodes,
  ...utilityNodes,
];
