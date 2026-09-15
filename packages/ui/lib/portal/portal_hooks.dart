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

class PortalEntryManager<T> {
  PortalEntry<T>? _entry;
  PortalEntry<T>? get entry => _entry;

  bool get isActive => _entry?.isActive ?? false;

  void push(BuildContext context, PortalEntry<T> entry, {PortalAnchor? anchor}) {
    if (_entry != null && _entry!.isActive) {
      _entry!.pop(force: true);
    }
    _entry = entry;
    _entry!.push(context, anchor: anchor);
  }

  void pop({bool force = false}) {
    if (_entry != null && _entry!.isActive) {
      _entry!.pop(force: force);
    }
    _entry = null;
  }
}

PortalEntryManager<T> usePortalEntryManager<T>() {
  final ref = useRef(PortalEntryManager<T>());

  useEffect(() {
    return () => ref.value.pop(force: true);
  }, const []);

  return ref.value;
}
