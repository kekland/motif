import 'package:state/state.dart';

Never unreachable() {
  throw StateError('should be unreachable');
}

class ObjectSignal<T> extends Signal<T> {
  ObjectSignal(this.object) : super(object);

  final T object;

  void markAsDirty() => set(object, force: true);
}
