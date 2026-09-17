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

class PortalEntryManager {
  PortalEntry? _entry;
  PortalEntry? get entry => _entry;

  bool get isActive => _entry?.isActive ?? false;

  Future<T?> push<T>(BuildContext context, PortalEntry<T> entry, {PortalAnchor? anchor}) {
    if (_entry != null && _entry!.isActive) {
      _entry!.pop(force: true);
    }
    _entry = entry;
    return entry.push(context, anchor: anchor);
  }

  void pop({bool force = false}) {
    if (_entry != null && _entry!.isActive) {
      _entry!.pop(force: force);
    }
    _entry = null;
  }

  void dispose() {
    pop(force: true);
  }
}

PortalEntryManager usePortalEntryManager() {
  final ref = useRef(PortalEntryManager());

  useEffect(() {
    return () => ref.value.dispose();
  }, const []);

  return ref.value;
}
