import 'package:blueprint/generator.dart';

String _nColor(String c) => 'context.colors.blueprint.node.$c';
String _sColor(String c) => 'context.colors.blueprint.data.$c';

/*
  Sockets
*/

final vector = SocketDescription(name: 'Vector', type: 'Vector2', color: _sColor('vector'));
final integer = SocketDescription(name: 'Integer', type: 'int', color: _sColor('int'));
final float = SocketDescription(name: 'Float', type: 'double', color: _sColor('float'));
final geometry = SocketDescription(name: 'Geometry', type: 'PrimitiveBundle', color: _sColor('geometry'));
final geometryList = SocketDescription(
  name: 'GeometryList',
  type: 'PrimitiveBundle',
  isList: true,
  color: _sColor('geometry'),
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

final shiftVerticesNode = NodeDescription(
  name: 'ShiftVertices',
  inputs: [
    .new(name: 'vertices', type: geometry),
    .new(name: 'shift', type: vector, socketType: .dynamic),
  ],
  outputs: [
    .new(name: 'geometry', type: geometry),
  ],
  color: _nColor('geometry'),
);

final nodes = [
  primitiveVertexNode,
  connectVerticesNode,
  joinGeometryNode,
  geometryOutputNode,
  randomVectorNode,
  shiftVerticesNode,
];

final sockets = [
  vector,
  integer,
  float,
  geometry,
  geometryList,
];
