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

final _mergeCodec = $codec<MergeNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    merge: .new(
    ),
  ),
);

final _vertexCodec = $codec<VertexNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    position: $opt(v.vertex.hasPosition, () => v.vertex.position.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    vertex: .new(
      position: v.i.position.inlineValue.encode(),
    ),
  ),
);

final _rectangleCodec = $codec<RectangleNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    center: $opt(v.rectangle.hasCenter, () => v.rectangle.center.decode()),
    size: $opt(v.rectangle.hasSize, () => v.rectangle.size.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    rectangle: .new(
      center: v.i.center.inlineValue.encode(),
      size: v.i.size.inlineValue.encode(),
    ),
  ),
);

final _arrayCodec = $codec<ArrayNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: $opt(v.array.hasSlice, () => v.array.slice.decode()),
    offset: $opt(v.array.hasOffset, () => v.array.offset.decode()),
    count: $opt(v.array.hasCount, () => v.array.count.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    array: .new(
      slice: v.i.slice.inlineValue.encode(),
      offset: v.i.offset.inlineValue.encode(),
      count: v.i.count.inlineValue.encode(),
    ),
  ),
);

final _transformCodec = $codec<TransformNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: $opt(v.transform.hasSlice, () => v.transform.slice.decode()),
    translation: $opt(v.transform.hasTranslation, () => v.transform.translation.decode()),
    scale: $opt(v.transform.hasScale, () => v.transform.scale.decode()),
    rotation: $opt(v.transform.hasRotation, () => v.transform.rotation),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    transform: .new(
      slice: v.i.slice.inlineValue.encode(),
      translation: v.i.translation.inlineValue.encode(),
      scale: v.i.scale.inlineValue.encode(),
      rotation: v.i.rotation.inlineValue,
    ),
  ),
);

final _connectVerticesCodec = $codec<ConnectVerticesNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    closed: $opt(v.connectVertices.hasClosed, () => v.connectVertices.closed),
    slice: $opt(v.connectVertices.hasSlice, () => v.connectVertices.slice.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    connectVertices: .new(
      closed: v.i.closed.inlineValue,
      slice: v.i.slice.inlineValue.encode(),
    ),
  ),
);

final _makeFaceCodec = $codec<MakeFaceNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: $opt(v.makeFace.hasSlice, () => v.makeFace.slice.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    makeFace: .new(
      slice: v.i.slice.inlineValue.encode(),
    ),
  ),
);

final _boundingBoxCodec = $codec<BoundingBoxNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: $opt(v.boundingBox.hasSlice, () => v.boundingBox.slice.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    boundingBox: .new(
      slice: v.i.slice.inlineValue.encode(),
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

final _mathCodec = $codec<MathNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    a: $opt(v.math.hasA, () => v.math.a),
    b: $opt(v.math.hasB, () => v.math.b),
    operator: v.math.operator.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    math: .new(
      a: v.i.a.inlineValue,
      b: v.i.b.inlineValue,
      operator: v.operator.encode(),
    ),
  ),
);

final _vectorMathCodec = $codec<VectorMathNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    a: $opt(v.vectorMath.hasA, () => v.vectorMath.a.decode()),
    b: $opt(v.vectorMath.hasB, () => v.vectorMath.b.decode()),
    operator: v.vectorMath.operator.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    vectorMath: .new(
      a: v.i.a.inlineValue.encode(),
      b: v.i.b.inlineValue.encode(),
      operator: v.operator.encode(),
    ),
  ),
);

final _trigMathCodec = $codec<TrigMathNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    input: $opt(v.trigMath.hasInput, () => v.trigMath.input),
    operator: v.trigMath.operator.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    trigMath: .new(
      input: v.i.input.inlineValue,
      operator: v.operator.encode(),
    ),
  ),
);

final _expressionCodec = $codec<ExpressionNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    expression: $opt(v.expression.hasExpression, () => v.expression.expression),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    expression: .new(
      expression: v.i.expression.inlineValue,
    ),
  ),
);

final _mathConstantCodec = $codec<MathConstantNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    constant: v.mathConstant.constant.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    mathConstant: .new(
      constant: v.constant.encode(),
    ),
  ),
);

final _mathRoundCodec = $codec<MathRoundNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.mathRound.hasValue, () => v.mathRound.value),
    mode: v.mathRound.mode.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    mathRound: .new(
      value: v.i.value.inlineValue,
      mode: v.mode.encode(),
    ),
  ),
);

final _combineXYCodec = $codec<CombineXYNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    x: $opt(v.combineXY.hasX, () => v.combineXY.x),
    y: $opt(v.combineXY.hasY, () => v.combineXY.y),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    combineXY: .new(
      x: v.i.x.inlineValue,
      y: v.i.y.inlineValue,
    ),
  ),
);

final _separateXYCodec = $codec<SeparateXYNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.separateXY.hasValue, () => v.separateXY.value.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    separateXY: .new(
      value: v.i.value.inlineValue.encode(),
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

final _randomFloatCodec = $codec<RandomFloatNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    seed: $opt(v.randomFloat.hasSeed, () => v.randomFloat.seed),
    min: $opt(v.randomFloat.hasMin, () => v.randomFloat.min),
    max: $opt(v.randomFloat.hasMax, () => v.randomFloat.max),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    randomFloat: .new(
      seed: v.i.seed.inlineValue,
      min: v.i.min.inlineValue,
      max: v.i.max.inlineValue,
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

extension NodeEncode on Node { gen.Node encode() => _nodeCodec.encode(this); }
extension NodeDecode on gen.Node { Node decode() => _nodeCodec.decode(this); }

final _nodeCodec = $codec<Node, gen.Node>(
  decoder: (v) => switch(v.whichKind()) {
    .generatorInput  => _generatorInputCodec.decode(v),
    .generatorOutput  => _generatorOutputCodec.decode(v),
    .merge  => _mergeCodec.decode(v),
    .vertex  => _vertexCodec.decode(v),
    .rectangle  => _rectangleCodec.decode(v),
    .array  => _arrayCodec.decode(v),
    .transform  => _transformCodec.decode(v),
    .connectVertices  => _connectVerticesCodec.decode(v),
    .makeFace  => _makeFaceCodec.decode(v),
    .boundingBox  => _boundingBoxCodec.decode(v),
    .index_  => _indexCodec.decode(v),
    .math  => _mathCodec.decode(v),
    .vectorMath  => _vectorMathCodec.decode(v),
    .trigMath  => _trigMathCodec.decode(v),
    .expression  => _expressionCodec.decode(v),
    .mathConstant  => _mathConstantCodec.decode(v),
    .mathRound  => _mathRoundCodec.decode(v),
    .combineXY  => _combineXYCodec.decode(v),
    .separateXY  => _separateXYCodec.decode(v),
    .polar  => _polarCodec.decode(v),
    .randomFloat  => _randomFloatCodec.decode(v),
    .randomVector  => _randomVectorCodec.decode(v),
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    GeneratorInputNode v => _generatorInputCodec.encode(v),
    GeneratorOutputNode v => _generatorOutputCodec.encode(v),
    MergeNode v => _mergeCodec.encode(v),
    VertexNode v => _vertexCodec.encode(v),
    RectangleNode v => _rectangleCodec.encode(v),
    ArrayNode v => _arrayCodec.encode(v),
    TransformNode v => _transformCodec.encode(v),
    ConnectVerticesNode v => _connectVerticesCodec.encode(v),
    MakeFaceNode v => _makeFaceCodec.encode(v),
    BoundingBoxNode v => _boundingBoxCodec.encode(v),
    IndexNode v => _indexCodec.encode(v),
    MathNode v => _mathCodec.encode(v),
    VectorMathNode v => _vectorMathCodec.encode(v),
    TrigMathNode v => _trigMathCodec.encode(v),
    ExpressionNode v => _expressionCodec.encode(v),
    MathConstantNode v => _mathConstantCodec.encode(v),
    MathRoundNode v => _mathRoundCodec.encode(v),
    CombineXYNode v => _combineXYCodec.encode(v),
    SeparateXYNode v => _separateXYCodec.encode(v),
    PolarNode v => _polarCodec.encode(v),
    RandomFloatNode v => _randomFloatCodec.encode(v),
    RandomVectorNode v => _randomVectorCodec.encode(v),
    _ => throw ArgumentError(),
  },
);

extension MathOperatorTypeEncode on MathOperatorType { gen.MathOperatorType encode() => _mathOperatorTypeCodec.encode(this); }
extension MathOperatorTypeDecode on gen.MathOperatorType { MathOperatorType decode() => _mathOperatorTypeCodec.decode(this); }

final _mathOperatorTypeCodec = $codec<MathOperatorType, gen.MathOperatorType>(
  decoder: (v) => switch(v) {
    .MATH_OPERATOR_TYPE_ADD => .add,
    .MATH_OPERATOR_TYPE_SUBTRACT => .subtract,
    .MATH_OPERATOR_TYPE_MULTIPLY => .multiply,
    .MATH_OPERATOR_TYPE_DIVIDE => .divide,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .add => .MATH_OPERATOR_TYPE_ADD,
    .subtract => .MATH_OPERATOR_TYPE_SUBTRACT,
    .multiply => .MATH_OPERATOR_TYPE_MULTIPLY,
    .divide => .MATH_OPERATOR_TYPE_DIVIDE,
  },
);

extension VectorMathOperatorTypeEncode on VectorMathOperatorType { gen.VectorMathOperatorType encode() => _vectorMathOperatorTypeCodec.encode(this); }
extension VectorMathOperatorTypeDecode on gen.VectorMathOperatorType { VectorMathOperatorType decode() => _vectorMathOperatorTypeCodec.decode(this); }

final _vectorMathOperatorTypeCodec = $codec<VectorMathOperatorType, gen.VectorMathOperatorType>(
  decoder: (v) => switch(v) {
    .VECTOR_MATH_OPERATOR_TYPE_ADD => .add,
    .VECTOR_MATH_OPERATOR_TYPE_SUBTRACT => .subtract,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .add => .VECTOR_MATH_OPERATOR_TYPE_ADD,
    .subtract => .VECTOR_MATH_OPERATOR_TYPE_SUBTRACT,
  },
);

extension TrigMathOperatorTypeEncode on TrigMathOperatorType { gen.TrigMathOperatorType encode() => _trigMathOperatorTypeCodec.encode(this); }
extension TrigMathOperatorTypeDecode on gen.TrigMathOperatorType { TrigMathOperatorType decode() => _trigMathOperatorTypeCodec.decode(this); }

final _trigMathOperatorTypeCodec = $codec<TrigMathOperatorType, gen.TrigMathOperatorType>(
  decoder: (v) => switch(v) {
    .TRIG_MATH_OPERATOR_TYPE_SIN => .sin,
    .TRIG_MATH_OPERATOR_TYPE_COS => .cos,
    .TRIG_MATH_OPERATOR_TYPE_TAN => .tan,
    .TRIG_MATH_OPERATOR_TYPE_ARCSIN => .arcsin,
    .TRIG_MATH_OPERATOR_TYPE_ARCCOS => .arccos,
    .TRIG_MATH_OPERATOR_TYPE_ARCTAN => .arctan,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .sin => .TRIG_MATH_OPERATOR_TYPE_SIN,
    .cos => .TRIG_MATH_OPERATOR_TYPE_COS,
    .tan => .TRIG_MATH_OPERATOR_TYPE_TAN,
    .arcsin => .TRIG_MATH_OPERATOR_TYPE_ARCSIN,
    .arccos => .TRIG_MATH_OPERATOR_TYPE_ARCCOS,
    .arctan => .TRIG_MATH_OPERATOR_TYPE_ARCTAN,
  },
);

extension MathConstantTypeEncode on MathConstantType { gen.MathConstantType encode() => _mathConstantTypeCodec.encode(this); }
extension MathConstantTypeDecode on gen.MathConstantType { MathConstantType decode() => _mathConstantTypeCodec.decode(this); }

final _mathConstantTypeCodec = $codec<MathConstantType, gen.MathConstantType>(
  decoder: (v) => switch(v) {
    .MATH_CONSTANT_TYPE_PI => .pi,
    .MATH_CONSTANT_TYPE_E => .e,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .pi => .MATH_CONSTANT_TYPE_PI,
    .e => .MATH_CONSTANT_TYPE_E,
  },
);

extension MathRoundTypeEncode on MathRoundType { gen.MathRoundType encode() => _mathRoundTypeCodec.encode(this); }
extension MathRoundTypeDecode on gen.MathRoundType { MathRoundType decode() => _mathRoundTypeCodec.decode(this); }

final _mathRoundTypeCodec = $codec<MathRoundType, gen.MathRoundType>(
  decoder: (v) => switch(v) {
    .MATH_ROUND_TYPE_FLOOR => .floor,
    .MATH_ROUND_TYPE_CEIL => .ceil,
    .MATH_ROUND_TYPE_ROUND => .round,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .floor => .MATH_ROUND_TYPE_FLOOR,
    .ceil => .MATH_ROUND_TYPE_CEIL,
    .round => .MATH_ROUND_TYPE_ROUND,
  },
);
