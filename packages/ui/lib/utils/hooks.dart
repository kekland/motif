import 'package:ui/ui.dart';

bool useFocusNodeHasFocus(FocusNode focusNode) {
  final hasFocus = useState(focusNode.hasFocus);
  useListenerEffect(focusNode, () => hasFocus.value = focusNode.hasFocus, callImmediately: true);

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

Computed<R> useProxyComputed<T, R>(ReadonlySignal<T> signal, R Function(T) compute) {
  return useMemoComputed(() {
    return compute(signal.value);
  }, keys: [signal]);
}

R useProxyComputedValue<T, R>(ReadonlySignal<T> signal, R Function(T) compute) {
  final computed = useComputed(() => compute(signal()), keys: [signal]);
  return computed.value;
}

ReadonlySignal<R> useCastComputed<R>(ReadonlySignal signal) {
  final s = useSignal<R>(signal.value as R);

  useSignalEffect(() {
    final value = signal.value;
    if (value is R) s.value = value;
  }, keys: [signal]);

  return s;
}
