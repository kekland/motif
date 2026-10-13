import 'package:program/program.dart';
import 'package:blueprint/core.dart';
import 'package:schema/program.dart' as gen;

final _generatorInputCodec = $codec<GeneratorInputNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    generatorInput: .new(
    ),
  ),
);

final _generatorOutputCodec = $codec<GeneratorOutputNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    generatorOutput: .new(
    ),
  ),
);

final _arrayCodec = $codec<ArrayNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: $opt(v.array.hasSlice, () => v.array.slice.decode()),
    count: $opt(v.array.hasCount, () => v.array.count.decode()),
    offset: $opt(v.array.hasOffset, () => v.array.offset.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    array: .new(
      slice: v.i.slice.inlineValue.encode(),
      count: v.i.count.inlineValue.encode(),
      offset: v.i.offset.inlineValue.encode(),
    ),
  ),
);

final _filletCodec = $codec<FilletNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: $opt(v.fillet.hasSlice, () => v.fillet.slice.decode()),
    radius: $opt(v.fillet.hasRadius, () => v.fillet.radius.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    fillet: .new(
      slice: v.i.slice.inlineValue.encode(),
      radius: v.i.radius.inlineValue.encode(),
    ),
  ),
);

final _numberCodec = $codec<NumberNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.number.hasValue, () => v.number.value),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    number: .new(
      value: v.i.value.inlineValue,
    ),
  ),
);

final _vectorCodec = $codec<VectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.vector.hasValue, () => v.vector.value.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    vector: .new(
      value: v.i.value.inlineValue.encode(),
    ),
  ),
);

final _verticesCodec = $codec<VerticesNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    count: $opt(v.vertices.hasCount, () => v.vertices.count),
    position: $opt(v.vertices.hasPosition, () => v.vertices.position.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    vertices: .new(
      count: v.i.count.inlineValue,
      position: v.i.position.inlineValue.encode(),
    ),
  ),
);

final _randomVectorCodec = $codec<RandomVectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    seed: $opt(v.randomVector.hasSeed, () => v.randomVector.seed),
    min: $opt(v.randomVector.hasMin, () => v.randomVector.min.decode()),
    max: $opt(v.randomVector.hasMax, () => v.randomVector.max.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    randomVector: .new(
      seed: v.i.seed.inlineValue,
      min: v.i.min.inlineValue.encode(),
      max: v.i.max.inlineValue.encode(),
    ),
  ),
);

final _indexCodec = $codec<IndexNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    index: .new(
    ),
  ),
);

final _scaleVectorCodec = $codec<ScaleVectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    vector: $opt(v.scaleVector.hasVector, () => v.scaleVector.vector.decode()),
    factor: $opt(v.scaleVector.hasFactor, () => v.scaleVector.factor),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    scaleVector: .new(
      vector: v.i.vector.inlineValue.encode(),
      factor: v.i.factor.inlineValue,
    ),
  ),
);

final _connectVerticesCodec = $codec<ConnectVerticesNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: $opt(v.connectVertices.hasSlice, () => v.connectVertices.slice.decode()),
    closed: $opt(v.connectVertices.hasClosed, () => v.connectVertices.closed),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    connectVertices: .new(
      slice: v.i.slice.inlineValue.encode(),
      closed: v.i.closed.inlineValue,
    ),
  ),
);

final _faceCodec = $codec<FaceNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: $opt(v.face.hasSlice, () => v.face.slice.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    face: .new(
      slice: v.i.slice.inlineValue.encode(),
    ),
  ),
);

final _polarCodec = $codec<PolarNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    radius: $opt(v.polar.hasRadius, () => v.polar.radius),
    angle: $opt(v.polar.hasAngle, () => v.polar.angle),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    polar: .new(
      radius: v.i.radius.inlineValue,
      angle: v.i.angle.inlineValue,
    ),
  ),
);

final _piCodec = $codec<PiNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    pi: .new(
    ),
  ),
);

final _divideCodec = $codec<DivideNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    numerator: $opt(v.divide.hasNumerator, () => v.divide.numerator),
    denominator: $opt(v.divide.hasDenominator, () => v.divide.denominator),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    divide: .new(
      numerator: v.i.numerator.inlineValue,
      denominator: v.i.denominator.inlineValue,
    ),
  ),
);

extension NodeEncode on Node { gen.Node encode() => _nodeCodec.encode(this); }
extension NodeDecode on gen.Node { Node decode() => _nodeCodec.decode(this); }

final _nodeCodec = $codec<Node, gen.Node>(
  decoder: (v) => switch(v.whichKind()) {
    .generatorInput  => _generatorInputCodec.decode(v),
    .generatorOutput  => _generatorOutputCodec.decode(v),
    .array  => _arrayCodec.decode(v),
    .fillet  => _filletCodec.decode(v),
    .number  => _numberCodec.decode(v),
    .vector  => _vectorCodec.decode(v),
    .vertices  => _verticesCodec.decode(v),
    .randomVector  => _randomVectorCodec.decode(v),
    .index_  => _indexCodec.decode(v),
    .scaleVector  => _scaleVectorCodec.decode(v),
    .connectVertices  => _connectVerticesCodec.decode(v),
    .face  => _faceCodec.decode(v),
    .polar  => _polarCodec.decode(v),
    .pi  => _piCodec.decode(v),
    .divide  => _divideCodec.decode(v),
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    GeneratorInputNode v => _generatorInputCodec.encode(v),
    GeneratorOutputNode v => _generatorOutputCodec.encode(v),
    ArrayNode v => _arrayCodec.encode(v),
    FilletNode v => _filletCodec.encode(v),
    NumberNode v => _numberCodec.encode(v),
    VectorNode v => _vectorCodec.encode(v),
    VerticesNode v => _verticesCodec.encode(v),
    RandomVectorNode v => _randomVectorCodec.encode(v),
    IndexNode v => _indexCodec.encode(v),
    ScaleVectorNode v => _scaleVectorCodec.encode(v),
    ConnectVerticesNode v => _connectVerticesCodec.encode(v),
    FaceNode v => _faceCodec.encode(v),
    PolarNode v => _polarCodec.encode(v),
    PiNode v => _piCodec.encode(v),
    DivideNode v => _divideCodec.encode(v),
    _ => throw ArgumentError(),
  },
);
