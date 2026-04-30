import 'package:vector/imports.dart';

class FillTool extends Tool {
  const FillTool();

  @override
  String get key => 'fill';

  @override
  LogicalKeySet get shortcut => LogicalKeySet(.keyB);

  @override
  Widget buildIcon(BuildContext context) => Icons.fill();

  @override
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => _FillToolOverlay(info: info);
}

class _FillToolOverlay extends HookWidget {
  const _FillToolOverlay({super.key, required this.info});

  final OverlayChildLayoutInfo info;

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final face = useState<List<RegularCycle>?>(null);

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: Cursors.toolFill,
      child: Listener(
        behavior: .translucent,
        onPointerHover: (e) {
          final globalPosition = e.position;
          final localPosition = controller.globalToArtworkLocal(globalPosition);
          face.value = controller.complex.traceFaceAt(localPosition.asVector2());
        },
        onPointerDown: (e) {},
        child: GestureDetector(
          behavior: .translucent,
          onTapUp: (details) {
            final localPosition = controller.globalToArtworkLocal(details.globalPosition);
            final result = controller.complex.traceFaceAt(localPosition.asVector2());

            if (result != null) {
              controller.complex.createFace(result);
            }
          },
          child: Stack(
            children: [
              if (face.value != null)
                CustomPaint(
                  painter: _CyclePainter(
                    face: face.value!,
                    transform: info.childPaintTransform,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CyclePainter extends CustomPainter {
  _CyclePainter({required this.face, required this.transform});

  final List<RegularCycle> face;
  final Matrix4 transform;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    for (final cycle in face) {
      path.addPath(cycle.getPath(), Offset.zero);
    }

    final transformedPath = path.transform(transform.storage);

    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(transformedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CyclePainter oldDelegate) {
    return oldDelegate.face != face || oldDelegate.transform != transform;
  }
}
