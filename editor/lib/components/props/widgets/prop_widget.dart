import 'package:editor/imports.dart';

mixin PropWidget on Widget {
  bool get isNested;
  String? resolveHeader(BuildContext context);

  EdgeInsets get resolvedPadding => switch (isNested) {
    true => .zero,
    false => padding,
  };

  static const EdgeInsets padding = .only(left: 12.0, right: 12.0, bottom: 12.0);
}

Computed<PropValue<G>> usePropComputed<G, S>(Prop<G, S> prop) {
  final lastValue = useRef<PropValue<G>?>(null);

  final computed = useMemoComputed(() {
    for (final source in prop.sources) {
      source.signal?.call();
    }

    try {
      if (!prop.isEverythingActive()) return lastValue.value ?? .mixed();
      return lastValue.value = prop.resolve();
    } catch (e) {
      // This can usually happen when the statement is removed from the tree, but the prop references update
      // only on the next frame.
      return PropValue<G>.mixed();
    }
  }, keys: [prop]);

  return computed;
}

PropTransaction usePropTransaction() {
  return useContext().watch<PropTransaction>();
}
