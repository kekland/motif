import 'package:ui/ui.dart';

bool useFocusNodeHasFocus(FocusNode focusNode) {
  final hasFocus = useState(focusNode.hasFocus);
  $useListenerEffect(focusNode, () => hasFocus.value = focusNode.hasFocus, callImmediately: true);

  return hasFocus.value;
}

void useOnDispose(VoidCallback callback) {
  useEffect(() => callback, const []);
}

Computed<T> useMemoComputed<T>(T Function() compute, {List<Object?> keys = const []}) {
  final computed = useMemoized(() => Computed(compute), keys);
  useEffect(() => computed.dispose, [computed]);
  return computed;
}
