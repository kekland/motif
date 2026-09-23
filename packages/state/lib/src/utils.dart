import 'package:state/state.dart';

class ObjectSignal<T> extends Signal<T> {
  ObjectSignal(this.object) : super(object);

  final T object;

  void markAsDirty() => set(object, force: true);
}
