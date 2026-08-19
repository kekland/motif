part of '../prop.dart';

final class PropListBuilder extends StatelessWidget {
  const new({
    super.key,
    required this.scene,
    required this.props,
  });

  final Scene scene;
  final List<Prop> props;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final prop in props) {
      final widget = switch (prop) {
        Prop<Vec2Partial> p => PositionPropWidget(scene: scene, prop: p),
        Prop<EdgeStylePartial> p => EdgeStylePropWidget(scene: scene, prop: p),
        Prop<FaceStylePartial> p => FaceStylePropWidget(scene: scene, prop: p),
        Prop<Mat4> p => TransformPropWidget(scene: scene, prop: p),
        Prop<ChildLayout> p => ChildLayoutPropWidget(scene: scene, prop: p),
        Prop<LayoutSizePartial> p => LayoutSizePropWidget(scene: scene, prop: p),
        _ => null,
      };

      if (widget != null)
        children.add(
          PropertiesSection(
            title: Text(widget.resolveHeader(context)),
            child: widget,
          ),
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.interleave(Divider()).toList(),
    );
  }
}

Computed<PropValue<T>> usePropComputed<T>(Scene scene, Prop<T> prop) {
  final computed = useMemoComputed(() {
    scene.signal();
    return prop.value(scene);
  }, keys: [scene, prop]);

  return computed;
}
