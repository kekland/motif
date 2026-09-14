part of 'portal.dart';

PortalEntry<T> usePortalEntry<T>(PortalEntry<T> Function() create) {
  final ref = useRef<PortalEntry<T>?>(create());

  useEffect(() {
    return () {
      final entry = ref.value;
      if (entry != null && entry.isActive) {
        entry.pop(force: true);
      }
    };
  }, const []);

  return ref.value!;
}
