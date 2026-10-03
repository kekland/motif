import 'package:editor/imports.dart';

mixin PropWidget on Widget {
  String resolveHeader(BuildContext context);

  static const EdgeInsets padding = .symmetric(horizontal: 8.0);
}

Computed<PropValue<G>> usePropComputed<G, S>(Prop<G, S> prop) {
  final scene = Editor.of(useContext()).scene;

  final computed = useMemoComputed(() {
    scene.signal();
    try {
      return prop.resolve(scene);
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
