import 'package:blueprint/generator.dart';

String _nColor(String c) => 'context.colors.blueprint.node.$c';
String _sColor(String c) => 'context.colors.blueprint.data.$c';

/*
  Sockets
*/

final vector = SocketDescription(
  name: 'Vector',
  type: 'Vector2',
  color: _sColor('vector'),
  defaultValue: 'Vector2.zero()',
);

final integer = SocketDescription(
  name: 'Integer',
  type: 'int',
  color: _sColor('int'),
  defaultValue: '0',
);

final float = SocketDescription(
  name: 'Float',
  type: 'double',
  color: _sColor('float'),
  defaultValue: '0.0',
);

final rotation = SocketDescription(
  name: 'Rotation',
  type: 'Angle2',
  color: _sColor('float'),
  defaultValue: 'Angle2.zero',
);

final geometry = SocketDescription(
  name: 'Geometry',
  type: 'PrimitiveBundle',
  color: _sColor('geometry'),
  defaultValue: 'PrimitiveBundle.empty()',
);

final geometryList = SocketDescription(
  name: 'GeometryList',
  type: 'PrimitiveBundle',
  isList: true,
  color: _sColor('geometry'),
  defaultValue: '',
);

final symbolId = SocketDescription(
  name: 'SymbolId',
  type: 'SymbolId?',
  color: _sColor('symbol'),
  defaultValue: 'null',
);

final scale = SocketDescription(
  name: 'Scale',
  type: 'Vector2',
  color: _sColor('vector'),
  defaultValue: '.new(1.0, 1.0)',
);

/*
  Nodes
*/

final primitiveVertexNode = NodeDescription(
  name: 'PrimitiveVertex',
  outputs: [
    .new(name: 'vertex', type: geometry),
  ],
  color: _nColor('primitive'),
);

final connectVerticesNode = NodeDescription(
  name: 'ConnectVertices',
  inputs: [
    .new(name: 'vertices', type: geometry),
  ],
  outputs: [
    .new(name: 'geometry', type: geometry),
  ],
  color: _nColor('geometry'),
);

final joinGeometryNode = NodeDescription(
  name: 'JoinGeometry',
  inputs: [
    .new(name: 'geometry', type: geometryList),
  ],
  outputs: [
    .new(name: 'geometry', type: geometry),
  ],
  color: _nColor('geometry'),
);

final geometryInputNode = NodeDescription(
  name: 'GeometryInput',
  outputs: [
    .new(name: 'geometry', type: geometry),
  ],
  color: _nColor('geometry'),
);

final geometryOutputNode = NodeDescription(
  name: 'GeometryOutput',
  inputs: [
    .new(name: 'geometry', type: geometry),
  ],
  color: _nColor('geometry'),
);

final randomVectorNode = NodeDescription(
  name: 'RandomVector',
  outputs: [
    .new(name: 'vector', type: vector, socketType: .dynamic),
  ],
  color: _nColor('math'),
);

final shiftGeometryNode = NodeDescription(
  name: 'ShiftGeometry',
  inputs: [
    .new(name: 'geometry', type: geometry),
    .new(name: 'shift', type: vector, socketType: .dynamic),
  ],
  outputs: [
    .new(name: 'geometry', type: geometry),
  ],
  color: _nColor('geometry'),
);

final instanceOnVerticesNode = NodeDescription(
  name: 'InstanceOnVertices',
  inputs: [
    .new(name: 'geometry', type: geometry),
    .new(name: 'instance', type: geometry),
    .new(name: 'rotation', type: rotation, socketType: .dynamic),
    .new(name: 'scale', type: scale, socketType: .dynamic),
  ],
  outputs: [
    .new(name: 'instances', type: geometry),
  ],
  color: _nColor('instance'),
);

final instanceOnKnotsNode = NodeDescription(
  name: 'InstanceOnKnots',
  inputs: [
    .new(name: 'geometry', type: geometry),
    .new(name: 'instance', type: geometry),
    .new(name: 'rotation', type: rotation, socketType: .dynamic),
    .new(name: 'scale', type: scale, socketType: .dynamic),
  ],
  outputs: [
    .new(name: 'instances', type: geometry),
  ],
  color: _nColor('instance'),
);

final symbolNode = NodeDescription(
  name: 'Symbol',
  inputs: [
    .new(name: 'symbolId', type: symbolId),
  ],
  outputs: [
    .new(name: 'geometry', type: geometry),
  ],
);

final nodes = [
  primitiveVertexNode,
  connectVerticesNode,
  joinGeometryNode,
  geometryOutputNode,
  randomVectorNode,
  shiftGeometryNode,
  instanceOnVerticesNode,
  instanceOnKnotsNode,
  symbolNode,
  geometryInputNode,
];

final sockets = [
  vector,
  integer,
  float,
  geometry,
  geometryList,
];
