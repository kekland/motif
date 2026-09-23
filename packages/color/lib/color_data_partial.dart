part of 'color_data.dart';

extension ColorDataPartialExtension on ColorData {
  ColorDataPartial get partial => switch (this) {
    HsvColorData c => HsvColorDataPartial(h: c.h, s: c.s, v: c.v, alpha: c.alpha),
  };
}

sealed class ColorDataPartial extends Partial<ColorData> {
  const ColorDataPartial({this.type, this.alpha});

  final ColorType? type;
  final double? alpha;
  bool get canConstruct => false;
  ColorData construct() => throw UnimplementedError();

  static const mixed = MixedColorDataPartial();

  factory ColorDataPartial.fromPartialList(Iterable<ColorDataPartial> partials) {
    final type = partials.map((c) => c.type).toSet().singleOrNull;

    if (type == null) {
      return MixedColorDataPartial(
        type: null,
        alpha: partials.map((c) => c.alpha).toSet().singleOrNull,
      );
    }

    return switch (type) {
      .hsv => HsvColorDataPartial.fromPartialList(partials.cast()),
    };
  }

  factory withAlpha(double? alpha) {
    return MixedColorDataPartial(type: null, alpha: alpha);
  }

  factory hsv({double? h, double? s, double? v, double? alpha}) = HsvColorDataPartial;
}

final class MixedColorDataPartial extends ColorDataPartial {
  const MixedColorDataPartial({super.type, super.alpha});

  @override
  ColorData apply(ColorData current) {
    if (type != null) {
      current = current.convertTo(type!);
    }

    return current.withAlpha(alpha ?? current.alpha);
  }
}

final class HsvColorDataPartial extends ColorDataPartial {
  const HsvColorDataPartial({this.h, this.s, this.v, super.alpha}) : super(type: .hsv);

  factory HsvColorDataPartial.fromPartialList(Iterable<HsvColorDataPartial> partials) {
    return HsvColorDataPartial(
      h: partials.map((c) => c.h).toSet().singleOrNull,
      s: partials.map((c) => c.s).toSet().singleOrNull,
      v: partials.map((c) => c.v).toSet().singleOrNull,
      alpha: partials.map((c) => c.alpha).toSet().singleOrNull,
    );
  }

  final double? h;
  final double? s;
  final double? v;

  @override
  bool get canConstruct => h != null && s != null && v != null;

  @override
  ColorData construct() => HsvColorData(h: h!, s: s!, v: v!, alpha: alpha ?? 1.0);

  @override
  HsvColorData apply(ColorData current) => (current as HsvColorData).copyWith(h: h, s: s, v: v, alpha: alpha);
}
