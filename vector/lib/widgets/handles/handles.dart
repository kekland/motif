part of '../handles_overlay.dart';

class VertexHandle extends StatelessWidget {
  const VertexHandle({
    super.key,
    this.isSelected = false,
    this.isHovered = false,
    this.onPointerDown,
  });

  static const double size = 10.0;

  final bool isSelected;
  final bool isHovered;
  final PointerDownEventListener? onPointerDown;

  @override
  Widget build(BuildContext context) {
    return BaseHandleWidget(
      size: size,
      borderRadius: .circular(2.0),
      isSelected: isSelected,
      isHovered: isHovered,
      onPointerDown: onPointerDown,
      cursor: onPointerDown != null ? Cursors.toolCursorVertex : null,
    );
  }
}

class KnotHandle extends StatelessWidget {
  const KnotHandle({
    super.key,
    this.isSelected = false,
    this.isHovered = false,
    this.onPointerDown,
  });

  static const double size = 8.0;

  final bool isSelected;
  final bool isHovered;
  final PointerDownEventListener? onPointerDown;

  @override
  Widget build(BuildContext context) {
    return BaseHandleWidget(
      size: size,
      borderRadius: .circular(size / 2),
      isSelected: isSelected,
      isHovered: isHovered,
      rotation: math.pi / 4,
      onPointerDown: onPointerDown,
      cursor: onPointerDown != null ? Cursors.toolCursorKnot : null,
    );
  }
}

class ControlPointHandle extends StatelessWidget {
  const ControlPointHandle({
    super.key,
    this.isSelected = false,
    this.isHovered = false,
    this.onPointerDown,
    this.deltaToOrigin,
  });

  static const double size = 8.0;

  final bool isSelected;
  final bool isHovered;
  final Offset? deltaToOrigin;
  final PointerDownEventListener? onPointerDown;

  @override
  Widget build(BuildContext context) {
    Widget child = BaseHandleWidget(
      size: size,
      borderRadius: .circular(size / 2),
      isSelected: isSelected,
      isHovered: isHovered,
      onPointerDown: onPointerDown,
      cursor: onPointerDown != null ? Cursors.toolCursorControlPoint : null,
    );

    if (deltaToOrigin != null) {
      child = CustomPaint(
        painter: _ControlPointLinePainter(
          deltaToKnot: deltaToOrigin!,
          color: isSelected ? context.colors.accent.primary : context.colors.accent.primary,
        ),
        child: child,
      );
    }

    return child;
  }
}

class _ControlPointLinePainter extends CustomPainter {
  _ControlPointLinePainter({
    required this.deltaToKnot,
    required this.color,
  });

  final Offset deltaToKnot;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      size.center(.zero),
      deltaToKnot + size.center(.zero),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_ControlPointLinePainter oldDelegate) =>
      oldDelegate.deltaToKnot != deltaToKnot || oldDelegate.color != color;
}
