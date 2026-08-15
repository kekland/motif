import 'package:flutter/widgets.dart' as flutter;
import 'package:state/state.dart';

T useManagedResource<T>({
  T? value,
  required T Function() create,
  required void Function(T value) dispose,
  List<Object?>? keys,
}) {
  return use(
    _ManagedResourceHook<T>(
      value: value,
      create: create,
      dispose: dispose,
      keys: keys,
    ),
  );
}

class _ManagedResourceHook<T> extends Hook<T> {
  const _ManagedResourceHook({
    super.keys,
    required this.value,
    required this.create,
    required this.dispose,
  });

  final T? value;
  final T Function() create;
  final void Function(T value) dispose;

  @override
  HookState<T, Hook<T>> createState() => _ManagedResourceHookState();
}

class _ManagedResourceHookState<T> extends HookState<T, _ManagedResourceHook<T>> {
  late T value;

  @override
  void initHook() {
    super.initHook();
    value = hook.value ?? hook.create();
  }

  @override
  void didUpdateHook(_ManagedResourceHook<T> oldHook) {
    super.didUpdateHook(oldHook);

    if (oldHook.value != hook.value) {
      if (oldHook.value == null) hook.dispose(value);
      value = hook.value ?? hook.create();
    }
  }

  @override
  void dispose() {
    if (hook.value == null) hook.dispose(value);
    super.dispose();
  }

  @override
  T build(flutter.BuildContext context) => value;
}

T useComputedValue<T>(T Function() getter) {
  return useComputed(getter).value;
}

T useDisposable<T extends Disposable>(T Function() create, [List<Object?> keys = const []]) {
  final disposable = useMemoized(create, keys);

  useEffect(() {
    return disposable.dispose;
  }, [disposable]);

  return disposable;
}

void useCallOnce(VoidCallback callback) {
  useEffect(() {
    callback();
    return null;
  }, const []);
}

void useCallOncePostFrame(VoidCallback callback) {
  useEffect(() {
    flutter.WidgetsBinding.instance.addPostFrameCallback((_) => callback());
    return null;
  }, const []);
}

void $useListenerEffect(flutter.ChangeNotifier notifier, VoidCallback listener, {bool callImmediately = false}) {
  useEffect(() {
    notifier.addListener(listener);
    if (callImmediately) listener();

    return () => notifier.removeListener(listener);
  }, [notifier, listener]);
}

void useListenerEffect(ChangeNotifier notifier, VoidCallback listener, {bool callImmediately = false}) {
  useEffect(() {
    notifier.addListener(listener);
    if (callImmediately) listener();

    return () => notifier.removeListener(listener);
  }, [notifier, listener]);
}
