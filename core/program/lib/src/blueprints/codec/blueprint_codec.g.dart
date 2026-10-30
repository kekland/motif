import 'package:program/program.dart';
import 'package:blueprint/core.dart';
import 'package:schema/program.dart' as gen;

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

final _wrapCodec = $codec<WrapNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.wrap.hasValue, () => v.wrap.value),
    min: $opt(v.wrap.hasMin, () => v.wrap.min),
    max: $opt(v.wrap.hasMax, () => v.wrap.max),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    wrap: .new(
      value: v.i.value.inlineValue,
      min: v.i.min.inlineValue,
      max: v.i.max.inlineValue,
    ),
  ),
);

final _wrapVectorCodec = $codec<WrapVectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.wrapVector.hasValue, () => v.wrapVector.value.decode()),
    min: $opt(v.wrapVector.hasMin, () => v.wrapVector.min.decode()),
    max: $opt(v.wrapVector.hasMax, () => v.wrapVector.max.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    wrapVector: .new(
      value: v.i.value.inlineValue.encode(),
      min: v.i.min.inlineValue.encode(),
      max: v.i.max.inlineValue.encode(),
    ),
  ),
);

final _absCodec = $codec<AbsNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.abs.hasValue, () => v.abs.value),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    abs: .new(
      value: v.i.value.inlineValue,
    ),
  ),
);

final _absVectorCodec = $codec<AbsVectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.absVector.hasValue, () => v.absVector.value.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    absVector: .new(
      value: v.i.value.inlineValue.encode(),
    ),
  ),
);

final _signCodec = $codec<SignNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.sign.hasValue, () => v.sign.value),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    sign: .new(
      value: v.i.value.inlineValue,
    ),
  ),
);

final _signVectorCodec = $codec<SignVectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.signVector.hasValue, () => v.signVector.value.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    signVector: .new(
      value: v.i.value.inlineValue.encode(),
    ),
  ),
);

final _rotateVectorCodec = $codec<RotateVectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    vector: $opt(v.rotateVector.hasVector, () => v.rotateVector.vector.decode()),
    angle: $opt(v.rotateVector.hasAngle, () => v.rotateVector.angle),
    pivot: $opt(v.rotateVector.hasPivot, () => v.rotateVector.pivot.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    rotateVector: .new(
      vector: v.i.vector.inlineValue.encode(),
      angle: v.i.angle.inlineValue,
      pivot: v.i.pivot.inlineValue.encode(),
    ),
  ),
);

final _vectorMagnitudeCodec = $codec<VectorMagnitudeNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    vector: $opt(v.vectorMagnitude.hasVector, () => v.vectorMagnitude.vector.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    vectorMagnitude: .new(
      vector: v.i.vector.inlineValue.encode(),
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

final _compareCodec = $codec<CompareNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    a: $opt(v.compare.hasA, () => v.compare.a),
    b: $opt(v.compare.hasB, () => v.compare.b),
    epsilon: $opt(v.compare.hasEpsilon, () => v.compare.epsilon),
    type: v.compare.type.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    compare: .new(
      a: v.i.a.inlineValue,
      b: v.i.b.inlineValue,
      epsilon: v.i.epsilon.inlineValue,
      type: v.type.encode(),
    ),
  ),
);

final _booleanToFloatCodec = $codec<BooleanToFloatNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.booleanToFloat.hasValue, () => v.booleanToFloat.value),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    booleanToFloat: .new(
      value: v.i.value.inlineValue,
    ),
  ),
);

final _mapRangeCodec = $codec<MapRangeNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.mapRange.hasValue, () => v.mapRange.value),
    fromMin: $opt(v.mapRange.hasFromMin, () => v.mapRange.fromMin),
    fromMax: $opt(v.mapRange.hasFromMax, () => v.mapRange.fromMax),
    outMin: $opt(v.mapRange.hasOutMin, () => v.mapRange.outMin),
    outMax: $opt(v.mapRange.hasOutMax, () => v.mapRange.outMax),
    clamp: $opt(v.mapRange.hasClamp, () => v.mapRange.clamp),
    interpolation: v.mapRange.interpolation.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    mapRange: .new(
      value: v.i.value.inlineValue,
      fromMin: v.i.fromMin.inlineValue,
      fromMax: v.i.fromMax.inlineValue,
      outMin: v.i.outMin.inlineValue,
      outMax: v.i.outMax.inlineValue,
      clamp: v.i.clamp.inlineValue,
      interpolation: v.interpolation.encode(),
    ),
  ),
);

final _deg2RadCodec = $codec<Deg2RadNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.deg2Rad.hasValue, () => v.deg2Rad.value),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    deg2Rad: .new(
      value: v.i.value.inlineValue,
    ),
  ),
);

final _rad2DegCodec = $codec<Rad2DegNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.rad2Deg.hasValue, () => v.rad2Deg.value),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    rad2Deg: .new(
      value: v.i.value.inlineValue,
    ),
  ),
);

final _colorFromRGBACodec = $codec<ColorFromRGBANode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    r: $opt(v.colorFromRGBA.hasR, () => v.colorFromRGBA.r),
    g: $opt(v.colorFromRGBA.hasG, () => v.colorFromRGBA.g),
    b: $opt(v.colorFromRGBA.hasB, () => v.colorFromRGBA.b),
    a: $opt(v.colorFromRGBA.hasA, () => v.colorFromRGBA.a),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    colorFromRGBA: .new(
      r: v.i.r.inlineValue,
      g: v.i.g.inlineValue,
      b: v.i.b.inlineValue,
      a: v.i.a.inlineValue,
    ),
  ),
);

final _colorToRGBACodec = $codec<ColorToRGBANode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: $opt(v.colorToRGBA.hasValue, () => v.colorToRGBA.value.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    colorToRGBA: .new(
      value: v.i.value.inlineValue.encode(),
    ),
  ),
);

final _colorMixCodec = $codec<ColorMixNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    a: $opt(v.colorMix.hasA, () => v.colorMix.a.decode()),
    b: $opt(v.colorMix.hasB, () => v.colorMix.b.decode()),
    t: $opt(v.colorMix.hasT, () => v.colorMix.t),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    colorMix: .new(
      a: v.i.a.inlineValue.encode(),
      b: v.i.b.inlineValue.encode(),
      t: v.i.t.inlineValue,
    ),
  ),
);

final _shaderInputCodec = $codec<ShaderInputNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    shaderInput: .new(
    ),
  ),
);

final _shaderOutputCodec = $codec<ShaderOutputNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    color: $opt(v.shaderOutput.hasColor, () => v.shaderOutput.color.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    shaderOutput: .new(
      color: v.i.color.inlineValue.encode(),
    ),
  ),
);

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

extension NodeEncode on Node { gen.Node encode() => _nodeCodec.encode(this); }
extension NodeDecode on gen.Node { Node decode() => _nodeCodec.decode(this); }

final _nodeCodec = $codec<Node, gen.Node>(
  decoder: (v) => switch(v.whichKind()) {
    .math  => _mathCodec.decode(v),
    .vectorMath  => _vectorMathCodec.decode(v),
    .trigMath  => _trigMathCodec.decode(v),
    .expression  => _expressionCodec.decode(v),
    .mathConstant  => _mathConstantCodec.decode(v),
    .mathRound  => _mathRoundCodec.decode(v),
    .combineXY  => _combineXYCodec.decode(v),
    .separateXY  => _separateXYCodec.decode(v),
    .polar  => _polarCodec.decode(v),
    .wrap  => _wrapCodec.decode(v),
    .wrapVector  => _wrapVectorCodec.decode(v),
    .abs  => _absCodec.decode(v),
    .absVector  => _absVectorCodec.decode(v),
    .sign  => _signCodec.decode(v),
    .signVector  => _signVectorCodec.decode(v),
    .rotateVector  => _rotateVectorCodec.decode(v),
    .vectorMagnitude  => _vectorMagnitudeCodec.decode(v),
    .randomFloat  => _randomFloatCodec.decode(v),
    .randomVector  => _randomVectorCodec.decode(v),
    .compare  => _compareCodec.decode(v),
    .booleanToFloat  => _booleanToFloatCodec.decode(v),
    .mapRange  => _mapRangeCodec.decode(v),
    .deg2Rad  => _deg2RadCodec.decode(v),
    .rad2Deg  => _rad2DegCodec.decode(v),
    .colorFromRGBA  => _colorFromRGBACodec.decode(v),
    .colorToRGBA  => _colorToRGBACodec.decode(v),
    .colorMix  => _colorMixCodec.decode(v),
    .shaderInput  => _shaderInputCodec.decode(v),
    .shaderOutput  => _shaderOutputCodec.decode(v),
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
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    MathNode v => _mathCodec.encode(v),
    VectorMathNode v => _vectorMathCodec.encode(v),
    TrigMathNode v => _trigMathCodec.encode(v),
    ExpressionNode v => _expressionCodec.encode(v),
    MathConstantNode v => _mathConstantCodec.encode(v),
    MathRoundNode v => _mathRoundCodec.encode(v),
    CombineXYNode v => _combineXYCodec.encode(v),
    SeparateXYNode v => _separateXYCodec.encode(v),
    PolarNode v => _polarCodec.encode(v),
    WrapNode v => _wrapCodec.encode(v),
    WrapVectorNode v => _wrapVectorCodec.encode(v),
    AbsNode v => _absCodec.encode(v),
    AbsVectorNode v => _absVectorCodec.encode(v),
    SignNode v => _signCodec.encode(v),
    SignVectorNode v => _signVectorCodec.encode(v),
    RotateVectorNode v => _rotateVectorCodec.encode(v),
    VectorMagnitudeNode v => _vectorMagnitudeCodec.encode(v),
    RandomFloatNode v => _randomFloatCodec.encode(v),
    RandomVectorNode v => _randomVectorCodec.encode(v),
    CompareNode v => _compareCodec.encode(v),
    BooleanToFloatNode v => _booleanToFloatCodec.encode(v),
    MapRangeNode v => _mapRangeCodec.encode(v),
    Deg2RadNode v => _deg2RadCodec.encode(v),
    Rad2DegNode v => _rad2DegCodec.encode(v),
    ColorFromRGBANode v => _colorFromRGBACodec.encode(v),
    ColorToRGBANode v => _colorToRGBACodec.encode(v),
    ColorMixNode v => _colorMixCodec.encode(v),
    ShaderInputNode v => _shaderInputCodec.encode(v),
    ShaderOutputNode v => _shaderOutputCodec.encode(v),
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

extension MathCompareTypeEncode on MathCompareType { gen.MathCompareType encode() => _mathCompareTypeCodec.encode(this); }
extension MathCompareTypeDecode on gen.MathCompareType { MathCompareType decode() => _mathCompareTypeCodec.decode(this); }

final _mathCompareTypeCodec = $codec<MathCompareType, gen.MathCompareType>(
  decoder: (v) => switch(v) {
    .MATH_COMPARE_TYPE_EQUAL => .equal,
    .MATH_COMPARE_TYPE_NOT_EQUAL => .notEqual,
    .MATH_COMPARE_TYPE_LESS => .less,
    .MATH_COMPARE_TYPE_LESS_OR_EQUAL => .lessOrEqual,
    .MATH_COMPARE_TYPE_GREATER => .greater,
    .MATH_COMPARE_TYPE_GREATER_OR_EQUAL => .greaterOrEqual,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .equal => .MATH_COMPARE_TYPE_EQUAL,
    .notEqual => .MATH_COMPARE_TYPE_NOT_EQUAL,
    .less => .MATH_COMPARE_TYPE_LESS,
    .lessOrEqual => .MATH_COMPARE_TYPE_LESS_OR_EQUAL,
    .greater => .MATH_COMPARE_TYPE_GREATER,
    .greaterOrEqual => .MATH_COMPARE_TYPE_GREATER_OR_EQUAL,
  },
);

extension InterpolationTypeEncode on InterpolationType { gen.InterpolationType encode() => _interpolationTypeCodec.encode(this); }
extension InterpolationTypeDecode on gen.InterpolationType { InterpolationType decode() => _interpolationTypeCodec.decode(this); }

final _interpolationTypeCodec = $codec<InterpolationType, gen.InterpolationType>(
  decoder: (v) => switch(v) {
    .INTERPOLATION_TYPE_LINEAR => .linear,
    .INTERPOLATION_TYPE_STEP => .step,
    .INTERPOLATION_TYPE_SMOOTHSTEP => .smoothstep,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .linear => .INTERPOLATION_TYPE_LINEAR,
    .step => .INTERPOLATION_TYPE_STEP,
    .smoothstep => .INTERPOLATION_TYPE_SMOOTHSTEP,
  },
);
