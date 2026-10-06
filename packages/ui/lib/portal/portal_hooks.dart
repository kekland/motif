part of 'portal.dart';

PortalEntry<T> usePortalEntry<T>(PortalEntry<T> Function() create, [List<Object?>? keys]) {
  final ref = useRef<PortalEntry<T>?>(create());

  useEffect(() {
    return () {
      final entry = ref.value;
      entry?.dispose();
    };
  }, const []);

  useEffect(
    () {
      ref.value?.dispose();
      ref.value = create();
      return null;
    },
    keys ?? const [],
  );

  return ref.value!;
}

bool usePortalEntryActive(PortalEntry entry) {
  useListenable(entry);
  return entry.isActive;
}

class PortalEntryManager {
  PortalEntry? _entry;
  PortalEntry? get entry => _entry;

  bool get isActive => _entry?.isActive ?? false;

  Future<T?> push<T>(BuildContext context, PortalEntry<T> entry, {PortalAnchor? anchor}) {
    _entry?.dispose();
    _entry = entry;
    return entry.push(context, anchor: anchor);
  }

  void pop({bool force = false}) {
    _entry?.dispose();
    _entry = null;
  }

  void dispose() {
    _entry?.dispose();
  }
}

PortalEntryManager usePortalEntryManager() {
  final ref = useRef(PortalEntryManager());

  useEffect(() {
    return () => ref.value.dispose();
  }, const []);

  return ref.value;
}
