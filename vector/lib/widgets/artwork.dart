import 'package:vector/imports.dart';
import 'package:vector/widgets/transient_strokes.dart';

class ArtworkWidget extends StatelessWidget {
  const ArtworkWidget({super.key, required this.controller});

  final VectorController controller;

  @override
  Widget build(BuildContext context) {
    final complex = controller.complex;

    return Stack(
      children: [
        Positioned.fill(
          child: TransientStrokesWidget(
            transientStrokes: controller.transientStrokes,
          ),
        ),
        _Artwork(
          key: controller.artworkKey,
          complex: complex,
        ),
      ],
    );
  }
}

class _Artwork extends LeafRenderObjectWidget {
  const _Artwork({super.key, required this.complex});

  final VectorComplex complex;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderVectorComplex(complex: complex);

  @override
  void updateRenderObject(BuildContext context, RenderVectorComplex renderObject) {
    renderObject.complex = complex;
  }
}
