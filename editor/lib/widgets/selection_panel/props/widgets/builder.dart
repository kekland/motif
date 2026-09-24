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
        PositionProp p => PositionPropWidget(scene: scene, prop: p),
        EdgeStyleProp p => EdgeStylePropWidget(scene: scene, prop: p),
        FaceStyleProp p => FaceStylePropWidget(scene: scene, prop: p),
        TransformProp p => TransformPropWidget(scene: scene, prop: p),
        LayoutProp p => LayoutPropWidget(scene: scene, prop: p),
        LayoutSizeProp p => LayoutSizePropWidget(scene: scene, prop: p),
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

Computed<PropValue<G>> usePropComputed<G, S>(Scene scene, Prop<G, S> prop) {
  final computed = useMemoComputed(() {
    scene.signal();
    try {
      return prop.value(scene);
    } catch (e) {
      return PropValue<G>.mixed(null);
    }
  }, keys: [scene, prop]);

  return computed;
}

PropTransaction usePropTransaction(Scene scene, [List<Object?> keys = const []]) {
  final txn = useMemoized(() => PropTransaction(scene), keys);
  useEffect(() => txn.dispose, [txn]);
  return txn;
}

final class PropTransaction {
  PropTransaction(this.scene);

  final Scene scene;
  SceneTransaction? _transaction;

  void onStartChanging() {
    if (_transaction != null) throw StateError('Transaction already started');
    _transaction = scene.beginTransaction();
  }

  void onEndChanging() {
    _transaction!.commit();
    _transaction = null;
  }

  void edit(void Function(SceneTransaction) fn) {
    final isOneOff = _transaction == null;
    if (isOneOff) onStartChanging();
    fn(_transaction!);
    _transaction!.flush();
    if (isOneOff) onEndChanging();
  }

  void dispose() {
    _transaction?.commit();
    _transaction = null;
  }
}
