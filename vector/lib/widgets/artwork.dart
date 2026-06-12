import 'package:vector/imports.dart';

class ArtworkWidget extends HookWidget {
  const ArtworkWidget({super.key, required this.controller});

  final VectorController controller;

  @override
  Widget build(BuildContext context) {
    final complex = controller.complex;
    final transientStrokes = useListenable(controller.transientStrokes).strokes;

    return Stack(
      children: [
        _Artwork(
          key: controller.artworkKey,
          complex: complex,
          transientStrokes: transientStrokes.toList(),
        ),
      ],
    );
  }
}

class _Artwork extends LeafRenderObjectWidget {
  const _Artwork({
    super.key,
    required this.complex,
    this.transientStrokes = const [],
  });

  final VectorComplex complex;
  final List<TransientStroke> transientStrokes;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderVectorComplex(
    complex: complex,
    transientStrokes: transientStrokes,
  );

  @override
  void updateRenderObject(BuildContext context, RenderVectorComplex renderObject) {
    renderObject.complex = complex;
    renderObject.transientStrokes = transientStrokes;
  }
}
