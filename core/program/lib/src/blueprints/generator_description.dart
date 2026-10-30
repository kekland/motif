import 'package:blueprint/blueprint_generator.dart';

import 'shared_description.dart';

// ---------------------------------------------------------------------------------------------------------------------
// Sockets
// ---------------------------------------------------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------------------------------------------------
// Generator
// ---------------------------------------------------------------------------------------------------------------------

final sockets = <SocketDescription>[
  programSlice,
  programSliceList,
];

final nodes = <NodeDescription>[
  ...ioNodes,
  ...primitiveNodes,
  ...geometryNodes,
  ...queryNodes,
  ...fieldNodes,
];
