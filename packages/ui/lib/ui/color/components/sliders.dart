part of '../color_input_window.dart';

class _HueSlider extends StatelessWidget {
  const _HueSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  final double? value;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
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
      onChanged: (v) => onChanged?.call(v * 360.0),
      value: value != null ? value! / 360.0 : null,
      color: value != null ? HsvColorData(h: value!, s: 1.0, v: 1.0).toUiColor() : null,
    );
  }
}

class _SaturationSlider extends StatelessWidget {
  const _SaturationSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.color,
  });

  final double? value;
  final ValueChanged<double>? onChanged;
  final HsvColorData? color;

  @override
  Widget build(BuildContext context) {
    final stopsColor = color?.copyWith(alpha: 1.0) ?? HsvColorData(h: 0.0, s: 0.0, v: 1.0);

    return _Slider(
      leading: Icons.s(),
      stopsGenerator: (s) => stopsColor.copyWith(s: s).toUiColor(),
      onChanged: (s) => onChanged?.call(s),
      value: value,
      color: stopsColor.copyWith(s: value).toUiColor(),
    );
  }
}

class _ValueSlider extends StatelessWidget {
  const _ValueSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.color,
  });

  final double? value;
  final ValueChanged<double>? onChanged;
  final HsvColorData? color;

  @override
  Widget build(BuildContext context) {
    final stopsColor = color?.copyWith(alpha: 1.0) ?? HsvColorData(h: 0.0, s: 1.0, v: 0.0);

    return _Slider(
      leading: Icons.v(),
      stopsGenerator: (v) => stopsColor.copyWith(v: v).toUiColor(),
      onChanged: (v) => onChanged?.call(v),
      value: value,
      color: stopsColor.copyWith(v: value).toUiColor(),
    );
  }
}

class _AlphaSlider extends StatelessWidget {
  const _AlphaSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.color,
  });

  final double? value;
  final ValueChanged<double>? onChanged;
  final HsvColorData? color;

  @override
  Widget build(BuildContext context) {
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

    final stopsColor = color?.copyWith(alpha: 1.0) ?? HsvColorData(h: 0.0, s: 1.0, v: 1.0);

    return _Slider(
      leading: Icons.a(),
      background: background,
      stops: 2,
      stopsGenerator: (a) => stopsColor.copyWith(alpha: a).toUiColor(),
      onChanged: (a) => onChanged?.call(a),
      value: value,
      color: stopsColor.copyWith(alpha: value).toUiColor(),
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
