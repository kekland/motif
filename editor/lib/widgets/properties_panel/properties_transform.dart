part of 'properties_panel.dart';

class PropertiesTransformSection extends HookWidget {
  const PropertiesTransformSection({
    super.key,
    required this.nodes,
  });

  final Set<SceneNode> nodes;

  @override
  Widget build(BuildContext context) {
    final nodes = useNodeList(this.nodes, aspect: .transform);
    final node = nodes.first;

    final translation = switch (node) {
      SceneObject o => o.transform.translation,
      Vertex v => v.position,
      _ => null,
    };

    void applyTranslation({double? x, double? y}) {
      final newTranslation = translation!.clone();
      if (x != null) newTranslation.x = x;
      if (y != null) newTranslation.y = y;

      final _ = switch (node) {
        SceneObject o => o.transform = o.transform.copyWithTranslation(newTranslation),
        Vertex v => v.position = newTranslation,
        _ => null,
      };
    }

    var anchor = switch (node) {
      SceneObject o => o.bbox.center,
      _ => null,
    };

    if (anchor != null) {
      final parentTransform = node.getTransformTo(node.parent);
      anchor = parentTransform.transform2(anchor);
    }

    final rotation = switch (node) {
      SceneObject o => o.transform.rotation,
      _ => null,
    };

    void applyRotation(double r) {
      final _ = switch (node) {
        SceneObject o => o.transform = o.transform.copyWithRotation(r, anchor: anchor),
        _ => null,
      };
    }

    void applyRotateCw() {
      final _ = switch (node) {
        SceneObject o => o.transform = o.transform.rotatedCw(anchor: anchor),
        _ => null,
      };
    }

    return PropertiesSection(
      key: ValueKey(node),
      title: Text('Transform'),
      children: [
        Row(
          children: [
            Expanded(
              child: DoubleExpressionInputField(
                options: .new(leading: Icons.x()),
                value: translation?.x,
                onChanged: translation != null ? (v) => applyTranslation(x: v) : null,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: DoubleExpressionInputField(
                options: .new(leading: Icons.y()),
                value: translation?.y,
                onChanged: translation != null ? (v) => applyTranslation(y: v) : null,
              ),
            ),
          ],
        ),
        if (rotation != null)
          Row(
            children: [
              Expanded(
                child: DoubleExpressionInputField(
                  options: .new(leading: Icons.angle()),
                  value: rotation * radians2Degrees,
                  onChanged: (v) => applyRotation(v * degrees2Radians),
                ),
              ),
              const SizedBox(width: 4.0),
              IconButton(
                onTap: applyRotateCw,
                child: Icons.rotateCw(),
              ),
            ],
          ),
      ],
    );
  }
}
