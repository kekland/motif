part of 'portal.dart';

class PortalRoot extends StatefulWidget {
  const new({
    super.key,
    required this.child,
    this.anchorResolver = _defaultAnchorResolver,
  });

  final PortalAnchor? Function(BuildContext) anchorResolver;
  final Widget child;

  @override
  State<PortalRoot> createState() => PortalRootState();
}

class PortalRootState extends State<PortalRoot> {
  final _entries = <PortalEntry, OverlayEntry>{};
  final _entryKeys = <PortalEntry, GlobalKey<PortalEntryWidgetState>>{};
  final _entryUniqueKeys = <Object, PortalEntry>{};
  final _overlayKey = GlobalKey<OverlayState>();
  OverlayState get overlay => _overlayKey.currentState!;
  RenderBox get overlayRenderObject => overlay.context.findRenderObject()! as RenderBox;

  void push(BuildContext srcContext, PortalEntry entry, {PortalAnchor? anchor, Object? uniqueKey}) {
    if (uniqueKey != null) {
      final existing = _entryUniqueKeys[uniqueKey];
      if (existing != null) pop(existing, force: true);
      _entryUniqueKeys[uniqueKey] = entry;
    }

    final key = GlobalKey<PortalEntryWidgetState>();
    _entryKeys[entry] = key;

    final resolvedAnchor = anchor ?? widget.anchorResolver(srcContext);
    final overlayEntry = OverlayEntry(
      builder: (context) => PortalEntryWidget(key: key, entry: entry, anchor: resolvedAnchor),
      canSizeOverlay: false,
    );

    _entries[entry] = overlayEntry;
    overlay.insert(overlayEntry);
  }

  void pop(PortalEntry entry, {bool force = false}) {
    final overlayEntry = _entries[entry];
    final key = _entryKeys[entry];
    if (overlayEntry == null) return;

    if (force) {
      _remove(entry, overlayEntry, key!);
    } else {
      final entryState = key?.currentState;
      if (entryState == null) {
        _remove(entry, overlayEntry, key!);
      } else {
        entryState.onPop().then((_) => _remove(entry, overlayEntry, key!));
      }
    }
  }

  void _remove(PortalEntry entry, OverlayEntry overlayEntry, GlobalKey key) {
    if (_entries[entry] == overlayEntry) {
      _entries.remove(entry);
      _entryKeys.remove(entry);
      _entryUniqueKeys.removeWhere((key, value) => value == entry);
    }

    overlayEntry.remove();
    overlayEntry.dispose();
  }

  @override
  void dispose() {
    for (final entry in _entries.keys.toList()) {
      final overlayEntry = _entries[entry]!;
      final key = _entryKeys[entry]!;
      _remove(entry, overlayEntry, key);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      key: _overlayKey,
      initialEntries: [
        OverlayEntry(
          builder: (context) => widget.child,
          canSizeOverlay: true,
        ),
      ],
    );
  }
}

PortalAnchor? _defaultAnchorResolver(BuildContext context) {
  return PortalAnchor.compute(context);
}
