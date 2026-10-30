part of '../generator.dart';

final class ColorFromRGBANode extends ColorFromRGBANodeBase {
  new({NodeId? id, super.r, super.g, super.b, super.a}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final r = execution.resolve(i.r);
    final g = execution.resolve(i.g);
    final b = execution.resolve(i.b);
    final a = execution.resolve(i.a);

    execution.set(
      o.value,
      .zip4(execution.scalar, r, g, b, a, (context, r, g, b, a) => ColorData.rgb(r: r, g: g, b: b, alpha: a)),
    );
  }
}

final class ColorToRGBANode extends ColorToRGBANodeBase {
  new({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);

    execution.set(o.r, value.map((c) => c.v1));
    execution.set(o.g, value.map((c) => c.v2));
    execution.set(o.b, value.map((c) => c.v3));
    execution.set(o.a, value.map((c) => c.alpha));
  }
}

final class ColorMixNode extends ColorMixNodeBase {
  new({NodeId? id, super.a, super.b, super.t}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final a = execution.resolve(i.a);
    final b = execution.resolve(i.b);
    final t = execution.resolve(i.t);

    execution.set(
      o.value,
      .zip3(execution.scalar, a, b, t, (context, c1, c2, mix) {
        final d1 = c1.cssColor;
        final d2 = c2.cssColor;
        final mixed = d1.mix(d2, mix);
        return ColorData.fromCss(mixed.convertTo(.srgb));
      }),
    );
  }
}
