import 'package:editor/imports.dart';

mixin PropWidget on Widget {
  bool get isNested;
  String resolveHeader(BuildContext context);

  EdgeInsets get resolvedPadding => switch (isNested) {
    true => .zero,
    false => padding,
  };

  static const EdgeInsets padding = .only(left: 12.0, right: 12.0, bottom: 8.0);
}

Computed<PropValue<G>> usePropComputed<G, S>(Prop<G, S> prop) {
  final scene = Editor.of(useContext()).scene;
  final lastValue = useRef<PropValue<G>?>(null);

  final computed = useMemoComputed(() {
    scene.signal();
    try {
      if (!prop.isEverythingActive(scene)) return lastValue.value ?? .mixed();
      return lastValue.value = prop.resolve(scene);
    } catch (e) {
      // This can usually happen when the statement is removed from the tree, but the prop references update
      // only on the next frame.
      return PropValue<G>.mixed();
    }
  }, keys: [scene, prop]);

  return computed;
}

PropTransaction usePropTransaction() {
  return useContext().watch<PropTransaction>();
}
