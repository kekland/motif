part of '../color_picker_window.dart';

class _HueSlider extends StatelessWidget {
  const _HueSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ColorData value;
  final ValueChanged<ColorData>? onChanged;

  @override
  Widget build(BuildContext context) {
    final value = this.value as HsvColorData;

    const colors = <Color>[
      .new(0xFFFF0000),
      .new(0xFFFFFF00),
      .new(0xFF00FF00),
      .new(0xFF00FFFF),
      .new(0xFF0000FF),
      .new(0xFFFF00FF),
      .new(0xFFFF0000),
    ];

    return _Slider(
      leading: Icons.h(),
      stops: colors.length,
      stopsGenerator: (v) => colors[(v * (colors.length - 1)).round()],
      onChanged: (v) => onChanged?.call(value.copyWith(h: v * 360.0)),
      value: value.h / 360.0,
      isCircular: true,
      color: value.copyWith(s: 1.0, v: 1.0).toUiColor(),
    );
  }
}

class _SaturationSlider extends StatelessWidget {
  const _SaturationSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ColorData value;
  final ValueChanged<ColorData>? onChanged;

  @override
  Widget build(BuildContext context) {
    final value = this.value as HsvColorData;

    return _Slider(
      leading: Icons.s(),
      stopsGenerator: (s) => value.copyWith(s: s, alpha: 1.0).toUiColor(),
      onChanged: (s) => onChanged?.call(value.copyWith(s: s)),
      value: value.s,
      color: value.toUiColor(),
    );
  }
}

class _ValueSlider extends StatelessWidget {
  const _ValueSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ColorData value;
  final ValueChanged<ColorData>? onChanged;

  @override
  Widget build(BuildContext context) {
    final value = this.value as HsvColorData;

    return _Slider(
      leading: Icons.v(),
      stopsGenerator: (v) => value.copyWith(v: v, alpha: 1.0).toUiColor(),
      onChanged: (v) => onChanged?.call(value.copyWith(v: v)),
      value: value.v,
      color: value.toUiColor(),
    );
  }
}

class _AlphaSlider extends StatelessWidget {
  const _AlphaSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ColorData value;
  final ValueChanged<ColorData>? onChanged;

  @override
  Widget build(BuildContext context) {
    final value = this.value as HsvColorData;

    final transparencyColors = switch (context.brightness) {
      .light => const (Color(0xFFCCCCCC), Color(0xFFFFFFFF)),
      .dark => const (Color(0xFF333333), Color(0xFF000000)),
    };

    final background = CustomPaint(
      willChange: false,
      isComplex: true,
      painter: _TransparencyPainter(
        tileSize: 4.0,
        grayColor: transparencyColors.$1,
        whiteColor: transparencyColors.$2,
      ),
    );

    return _Slider(
      leading: Icons.a(),
      background: background,
      stops: 2,
      stopsGenerator: (a) => value.copyWith(alpha: a).toUiColor(),
      onChanged: (a) => onChanged?.call(value.copyWith(alpha: a)),
      value: value.alpha,
      color: value.toUiColor(),
    );
  }
}

class _TransparencyPainter extends CustomPainter {
  _TransparencyPainter({required this.tileSize, required this.grayColor, required this.whiteColor});

  final double tileSize;
  final Color grayColor;
  final Color whiteColor;

  @override
  void paint(Canvas canvas, Size size) {
    final grayPaint = Paint()..color = grayColor;
    final whitePaint = Paint()..color = whiteColor;

    for (var i = 0; i < size.width / tileSize; i++) {
      for (var j = 0; j < size.height / tileSize; j++) {
        final index = i + j;
        final paint = index % 2 == 0 ? grayPaint : whitePaint;

        final x = i * tileSize;
        final y = j * tileSize;
        final rect = Rect.fromLTWH(x, y, tileSize, tileSize);

        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TransparencyPainter oldDelegate) => tileSize != oldDelegate.tileSize;
}
