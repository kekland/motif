import 'package:vector/imports.dart';
import 'package:vector/tools/weight/edge_weight_drag_activity.dart';
import 'package:vector/widgets/handles_overlay.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class WeightTool extends Tool {
  const WeightTool();

  @override
  String get key => 'weight';

  @override
  Widget buildIcon(BuildContext context) => Icons.weight();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _WeightToolOverlay(info: info);
}

class _WeightToolOverlay extends HookWidget {
  const _WeightToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);

    final weightDragRecognizer = useManagedResource(
      create: () => DragActivityWithArgumentGestureRecognizer<EdgeWeightDragActivity, (Edge, double, bool)>(
        activityFactory: (v) => EdgeWeightDragActivity(
          controller: controller,
          edge: v.$1,
          initialT: v.$2,
          canMove: v.$3,
        ),
      ),
      dispose: (v) => v.dispose(),
    );

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: .defer,
      child: Stack(
        children: [
          Listener(
            behavior: .translucent,
            onPointerDown: (e) {
              final hitTest = controller.hitTestCell(e.position);
              if (hitTest is EdgeHitTestEntry) {
                weightDragRecognizer.addPointer(e, argument: (hitTest.edge, hitTest.t, true));
              }
            },
          ),

          for (final edge in controller.complex.edges)
            _EdgeWeightSamples(
              controller: controller,
              edge: edge,
              info: info,
              onSamplePointerDown: (e, t, canMove) {
                weightDragRecognizer.addPointer(e, argument: (edge, t, canMove));
              },
            ),
        ],
      ),
    );
  }
}

class _EdgeWeightSamples extends HookWidget {
  const _EdgeWeightSamples({
    super.key,
    required this.controller,
    required this.edge,
    required this.info,
    this.onSamplePointerDown,
  });

  final VectorController controller;
  final OverlayChildLayoutInfo info;
  final Edge edge;
  final void Function(PointerDownEvent, double t, bool)? onSamplePointerDown;

  Widget _listener(double t, bool isBoundary, Widget child) => Listener(
    behavior: .opaque,
    onPointerDown: (e) => onSamplePointerDown?.call(e, t, !isBoundary),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    useStream(edge.updateStream);

    final samples = edge.strokeWeight.samples;
    final children = <Widget>[];

    for (final sample in samples) {
      final t = sample.x;
      final weight = sample.v;

      final position = edge.spline.point(t);
      final tangent = edge.spline.tangent(t).normalized();
      final normal = Vector2(-tangent.y, tangent.x);

      final center = position.asOffset();
      final offset = (normal * weight * edge.strokeWidth * 0.5).asOffset();
      final leftPosition = center - offset;
      final rightPosition = center + offset;

      // Central handle
      children.add(
        HandleWidget(
          position: position.asOffset(),
          child: _listener(
            t,
            false,
            CustomPaint(
              painter: _EdgeWeightSamplePainter(
                left: -offset,
                right: offset,
                transform: info.childPaintTransform,
              ),
              child: _EdgeWeightSampleHandle(),
            ),
          ),
        ),
      );

      // Boundary handles
      children.addAll([
        HandleWidget(
          position: leftPosition,
          child: _listener(t, true, const _EdgeWeightSampleBoundaryHandle()),
        ),
        HandleWidget(
          position: rightPosition,
          child: _listener(t, true, const _EdgeWeightSampleBoundaryHandle()),
        ),
      ]);
    }

    return HandlesLayout(
      childPaintTransform: info.childPaintTransform,
      children: children,
    );
  }
}

class _EdgeWeightSamplePainter extends CustomPainter {
  _EdgeWeightSamplePainter({
    super.repaint,
    required this.left,
    required this.right,
    required this.transform,
  });

  final Offset left;
  final Offset right;
  final Matrix4 transform;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    final center = size.center(Offset.zero);
    final transformWithoutTranslation = transform.clone()..setTranslation(Vector3.zero());

    final _left = MatrixUtils.transformPoint(transformWithoutTranslation, left) + center;
    final _right = MatrixUtils.transformPoint(transformWithoutTranslation, right) + center;

    canvas.drawLine(_left, _right, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _EdgeWeightSampleHandle extends StatelessWidget {
  const _EdgeWeightSampleHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseHandleWidget(
      isSelected: false,
      isHovered: false,
      size: 8.0,
      borderRadius: .circular(4.0),
      accentColor: Colors.green,
    );
  }
}

class _EdgeWeightSampleBoundaryHandle extends StatelessWidget {
  const _EdgeWeightSampleBoundaryHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseHandleWidget(
      isSelected: false,
      isHovered: false,
      size: 6.0,
      borderRadius: .circular(4.0),
      accentColor: Colors.green,
    );
  }
}
