import 'package:blueprint/core.dart';
import 'package:geometry/geometry.dart';
import 'package:program/program.dart';

final class ShaderWgslGenerator {
  ShaderWgslGenerator(this.shader);

  final ShaderBlueprint shader;
  late final List<Node> order;

  String _var(Socket n) => 'v_${order.indexOf(n.node)}_${n.index}';
  String _type(Socket s) => switch (s) {
    VectorSocket() => 'vec2f',
    IntegerSocket() => 'i32',
    FloatSocket() => 'f32',
    BooleanSocket() => 'bool',
    ColorSocket() => 'vec4f',
    BoundsSocket() => 'vec4f',
    _ => throw UnimplementedError('type ${s.type} is not supported'),
  };

  String _value(InputSocket s) => switch (s) {
    VectorInputSocket s => 'vec2f(${s.inlineValue.x}, ${s.inlineValue.y})',
    IntegerInputSocket s => '${s.inlineValue}',
    FloatInputSocket s => '${s.inlineValue}',
    BooleanInputSocket s => '${s.inlineValue}',
    ColorInputSocket s =>
      'vec4f(${s.inlineValue.v1}, ${s.inlineValue.v2}, ${s.inlineValue.v3}, ${s.inlineValue.alpha})',
    BoundsInputSocket s =>
      'vec4f(${s.inlineValue.min.x}, ${s.inlineValue.min.y}, ${s.inlineValue.max.x}, ${s.inlineValue.max.y})',
    _ => throw UnimplementedError('value for ${s.runtimeType} is not supported'),
  };

  String _input(InputSocket s) {
    final incoming = shader.incoming(s).singleOrNull;
    if (incoming != null) return _var(incoming);
    return _value(s);
  }

  String _decl(OutputSocket s, [String? value]) {
    var out = 'let ${_var(s)}: ${_type(s)}';
    if (value != null) out += ' = $value';
    out += ';';

    return out;
  }

  String _tmp(Node node, String name) => 'v_${order.indexOf(node)}_tmp_$name';

  void _populateOrder() {
    final order = <Node>{};

    void traverse(Node node) {
      for (final i in node.inputs) {
        final incoming = shader.incoming(i).singleOrNull;
        if (incoming != null) traverse(incoming.node);
      }

      order.add(node);
    }

    traverse(shader.outputNode);
    this.order = order.toList();
  }

  List<String> generate(String name) {
    _populateOrder();

    final impl = <String>[];
    for (final node in order) {
      impl.addAll(generateNode(node));
    }

    final code = <String>[];
    code.add('fn $name(in: VtxOut) -> vec4f {');
    code.addAll(impl.map((e) => '  $e'));
    code.add('}');
    return code;
  }

  List<String> generateNode(Node node) {
    return switch (node) {
      ShaderInputNode n => _genShaderInputNode(n),
      ShaderOutputNode n => _genShaderOutputNode(n),

      MathNode n => _genMathNode(n),
      VectorMathNode n => _genVectorMathNode(n),
      TrigMathNode n => _genTrigMathNode(n),
      MathConstantNode n => _genMathConstant(n),
      MathRoundNode n => _genMathRoundNode(n),
      CombineXYNode n => _genCombineXYNode(n),
      SeparateXYNode n => _genSeparateXYNode(n),
      PolarNode n => _genPolarNode(n),
      AbsNode n => _genAbsNode(n),
      AbsVectorNode n => _genAbsVectorNode(n),
      WrapNode n => _genWrapNode(n),
      WrapVectorNode n => _genWrapVectorNode(n),
      SignNode n => _genSignNode(n),
      SignVectorNode n => _genSignVectorNode(n),
      RotateVectorNode n => _genRotateVectorNode(n),
      CompareNode n => _genCompareNode(n),
      BooleanToFloatNode n => _genBooleanToFloatNode(n),
      MapRangeNode n => _genMapRangeNode(n),
      VectorMagnitudeNode n => _genVectorMagnitudeNode(n),
      Deg2RadNode n => _genDeg2RadNode(n),
      Rad2DegNode n => _genRad2DegNode(n),

      ColorFromRGBANode n => _genColorFromRGBANode(n),
      ColorToRGBANode n => _genColorToRGBANode(n),
      ColorMixNode n => _genColorMixNode(n),
      _ => throw UnimplementedError('node ${node.runtimeType} is not supported'),
    };
  }

  List<String> _genShaderInputNode(ShaderInputNode node) {
    return [
      _decl(node.o.worldPosition, 'in.world_position'),
      _decl(node.o.localPosition, 'in.local_position'),
    ];
  }

  List<String> _genShaderOutputNode(ShaderOutputNode node) {
    final input = _input(node.i.color);
    return ['return $input;'];
  }

  List<String> _genMathNode(MathNode node) {
    final op = switch (node.operator) {
      .add => '+',
      .subtract => '-',
      .multiply => '*',
      .divide => '/',
    };

    final left = _input(node.i.a);
    final right = _input(node.i.b);

    return [_decl(node.o.value, '$left $op $right')];
  }

  List<String> _genVectorMathNode(VectorMathNode node) {
    final op = switch (node.operator) {
      .add => '+',
      .subtract => '-',
    };

    final left = _input(node.i.a);
    final right = _input(node.i.b);

    return [_decl(node.o.value, '$left $op $right')];
  }

  List<String> _genTrigMathNode(TrigMathNode node) {
    final op = switch (node.operator) {
      .sin => 'sin',
      .cos => 'cos',
      .tan => 'tan',
      .arcsin => 'asin',
      .arccos => 'acos',
      .arctan => 'atan',
    };

    final input = _input(node.i.input);
    return [_decl(node.o.value, '$op($input)')];
  }

  List<String> _genMathConstant(MathConstantNode node) {
    final value = switch (node.constant) {
      .e => '2.718281828459045',
      .pi => '3.141592653589793',
    };

    return [_decl(node.o.value, value)];
  }

  List<String> _genMathRoundNode(MathRoundNode node) {
    final op = switch (node.mode) {
      .floor => 'floor',
      .ceil => 'ceil',
      .round => 'round',
    };

    final input = _input(node.i.value);
    return [_decl(node.o.value, '$op($input)')];
  }

  List<String> _genCombineXYNode(CombineXYNode node) {
    final x = _input(node.i.x);
    final y = _input(node.i.y);
    return [_decl(node.o.value, 'vec2f($x, $y)')];
  }

  List<String> _genSeparateXYNode(SeparateXYNode node) {
    final input = _input(node.i.value);
    return [
      _decl(node.o.x, '$input.x'),
      _decl(node.o.y, '$input.y'),
    ];
  }

  List<String> _genPolarNode(PolarNode node) {
    final r = _input(node.i.radius);
    final angle = _input(node.i.angle);
    return [_decl(node.o.value, 'vec2f($r * cos($angle), $r * sin($angle))')];
  }

  List<String> _genColorFromRGBANode(ColorFromRGBANode node) {
    final r = _input(node.i.r);
    final g = _input(node.i.g);
    final b = _input(node.i.b);
    final a = _input(node.i.a);
    return [_decl(node.o.value, 'vec4f($r, $g, $b, $a)')];
  }

  List<String> _genAbsNode(AbsNode node) {
    final input = _input(node.i.value);
    return [_decl(node.o.value, 'abs($input)')];
  }

  List<String> _genAbsVectorNode(AbsVectorNode node) {
    final input = _input(node.i.value);
    return [_decl(node.o.value, 'abs($input)')];
  }

  String _wrap(String value, String min, String max, String range) {
    return 'select($min, $value - $range * floor(($value - $min) / $range), $range != 0.0)';
  }

  List<String> _genWrapNode(WrapNode node) {
    final value = _input(node.i.value);
    final min = _input(node.i.min);
    final max = _input(node.i.max);
    final range = _tmp(node, 'range');
    return [
      'let $range = $max - $min;',
      _decl(node.o.value, _wrap(value, min, max, range)),
    ];
  }

  List<String> _genWrapVectorNode(WrapVectorNode node) {
    final value = _input(node.i.value);
    final min = _input(node.i.min);
    final max = _input(node.i.max);
    final range = _tmp(node, 'range');
    return [
      'let $range = $max - $min;',
      _decl(node.o.value, 'vec2f(${_wrap('$value.x', '$min.x', '$max.x', '$range.x')}, ${_wrap('$value.y', '$min.y', '$max.y', '$range.y')})'),
    ];
  }

  List<String> _genRotateVectorNode(RotateVectorNode node) {
    final vector = _input(node.i.vector);
    final angle = _input(node.i.angle);
    final pivot = _input(node.i.pivot);

    final c = _tmp(node, 'c');
    final s = _tmp(node, 's');
    final d = _tmp(node, 'd');

    return [
      'let $c = cos($angle);',
      'let $s = sin($angle);',
      'let $d = $vector - $pivot;',
      _decl(
        node.o.value,
        'vec2f($c * $d.x - $s * $d.y, $s * $d.x + $c * $d.y) + $pivot',
      ),
    ];
  }

  List<String> _genSignNode(SignNode node) {
    final input = _input(node.i.value);
    return [_decl(node.o.value, 'sign($input)')];
  }

  List<String> _genSignVectorNode(SignVectorNode node) {
    final input = _input(node.i.value);
    return [_decl(node.o.value, 'sign($input)')];
  }

  List<String> _genCompareNode(CompareNode node) {
    final a = _input(node.i.a);
    final b = _input(node.i.b);
    final epsilon = _input(node.i.epsilon);
    final op = switch (node.type) {
      .equal => 'abs($a - $b) <= $epsilon',
      .notEqual => 'abs($a - $b) > $epsilon',
      .less => '$a < $b',
      .lessOrEqual => '$a <= $b',
      .greater => '$a > $b',
      .greaterOrEqual => '$a >= $b',
    };

    return [
      _decl(node.o.result, op),
    ];
  }

  List<String> _genBooleanToFloatNode(BooleanToFloatNode node) {
    final input = _input(node.i.value);
    return [_decl(node.o.value, 'f32($input)')];
  }

  List<String> _genColorToRGBANode(ColorToRGBANode node) {
    final input = _input(node.i.value);
    return [
      _decl(node.o.r, '$input.r'),
      _decl(node.o.g, '$input.g'),
      _decl(node.o.b, '$input.b'),
      _decl(node.o.a, '$input.a'),
    ];
  }

  List<String> _genColorMixNode(ColorMixNode node) {
    final a = _input(node.i.a);
    final b = _input(node.i.b);
    final t = _input(node.i.t);
    return [
      _decl(node.o.value, 'mix($a, $b, $t)'),
    ];
  }

  List<String> _genMapRangeNode(MapRangeNode node) {
    final v = _input(node.i.value);
    final a = _input(node.i.fromMin);
    final b = _input(node.i.fromMax);
    final lo = _input(node.i.outMin);
    final hi = _input(node.i.outMax);
    final clamp = _input(node.i.clamp);
    final range = _tmp(node, 'range');
    final t = _tmp(node, 't');

    final clamper = 'select($t, clamp($t, 0.0, 1.0), $clamp)';
    final tMapper = switch(node.interpolation) {
      .linear => clamper,
      .step => 'step(0.5, $clamper)',
      .smoothstep => 'smoothstep(0.0, 1.0, $clamper)'
    };

    return [
      'let $range = $b - $a;',
      'let $t = select(0.0, ($v - $a) / $range, $range != 0.0);',
      _decl(node.o.value, 'mix($lo, $hi, $tMapper)')
    ];
  }

  List<String> _genVectorMagnitudeNode(VectorMagnitudeNode node) {
    final vector = _input(node.i.vector);
    return [
      _decl(node.o.value, 'length($vector)'),
    ];
  }

  List<String> _genDeg2RadNode(Deg2RadNode node) {
    final input = _input(node.i.value);
    return [_decl(node.o.value, '$input * ${deg2Rad}f')];
  }

  List<String> _genRad2DegNode(Rad2DegNode node) {
    final input = _input(node.i.value);
    return [_decl(node.o.value, '$input * ${rad2Deg}f')];
  }
}
