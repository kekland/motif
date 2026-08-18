import 'package:ui/ui.dart';

class Divider extends LeafRenderObjectWidget {
  const Divider({
    super.key,
    this.height = 0.0,
    this.color,
    this.isDashed = false,
  });

  final double height;
  final bool isDashed;
  final Color? color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderDivider(
      direction: .horizontal,
      color: RenderDivider.colorOf(context, color: color),
      crossExtent: height,
      isDashed: isDashed,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderDivider renderObject) {
    renderObject
      ..direction = .horizontal
      ..color = RenderDivider.colorOf(context, color: color)
      ..crossExtent = height
      ..isDashed = isDashed;
  }
}

class VerticalDivider extends LeafRenderObjectWidget {
  const VerticalDivider({
    super.key,
    this.width = 0.0,
    this.color,
    this.isDashed = false,
  });

  final double width;
  final bool isDashed;
  final Color? color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderDivider(
      direction: .vertical,
      color: RenderDivider.colorOf(context, color: color),
      crossExtent: width,
      isDashed: isDashed,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderDivider renderObject) {
    renderObject
      ..direction = .vertical
      ..color = RenderDivider.colorOf(context, color: color)
      ..crossExtent = width
      ..isDashed = isDashed;
  }
}

class RenderDivider extends RenderBox {
  RenderDivider({
    required this._color,
    required this._crossExtent,
    required this._direction,
    required this._isDashed,
  });

  static Color colorOf(BuildContext context, {Color? color}) {
    return color ?? Surface.colorOf(context).divider ?? context.colors.divider;
  }

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  double _crossExtent;
  double get crossExtent => _crossExtent;
  set crossExtent(double value) {
    if (_crossExtent == value) return;
    _crossExtent = value;
    markNeedsLayout();
  }

  Axis _direction;
  Axis get direction => _direction;
  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  bool _isDashed = false;
  bool get isDashed => _isDashed;
  set isDashed(bool value) {
    if (_isDashed == value) return;
    _isDashed = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    var mainExtent = switch (direction) {
      .horizontal => constraints.maxWidth,
      .vertical => constraints.maxHeight,
    };

    if (!mainExtent.isFinite) mainExtent = 0.0;

    size = switch (direction) {
      .horizontal => .new(mainExtent, crossExtent),
      .vertical => .new(crossExtent, mainExtent),
    };
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Offset p0 = switch (direction) {
      .horizontal => .new(0.0, size.height / 2.0),
      .vertical => .new(size.width / 2.0, 0.0),
    };

    final Offset p1 = switch (direction) {
      .horizontal => .new(size.width, size.height / 2.0),
      .vertical => .new(size.width / 2.0, size.height),
    };

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    if (isDashed) {
      context.canvas.drawDashedLine(offset + p0, offset + p1, pattern: [4.0, 4.0], paint: paint);
    } else {
      context.canvas.drawLine(offset + p0, offset + p1, paint);
    }
  }
}
