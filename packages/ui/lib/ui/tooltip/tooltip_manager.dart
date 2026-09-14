part of 'tooltip.dart';

class TooltipManager extends StatefulWidget {
  const new({
    super.key,
    this.showDelay = const .new(milliseconds: 500),
    this.warmDelay = const .new(milliseconds: 400),
    required this.child,
  });

  static TooltipManagerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<TooltipManagerState>()!;
    return state;
  }

  final Duration showDelay;
  final Duration warmDelay;
  final Widget child;

  @override
  State<TooltipManager> createState() => TooltipManagerState();
}

class TooltipManagerState extends State<TooltipManager> {
  DateTime? _lastHidden;
  bool _isShowing = false;

  Duration get showDelay => widget.showDelay;
  Duration get warmDelay => widget.warmDelay;

  Timer createTimer(VoidCallback callback) => .new(showDelay, callback);
  bool get isWarm => _isShowing || (_lastHidden != null && DateTime.now().difference(_lastHidden!) < warmDelay);

  void onShow() {
    _isShowing = true;
  }

  void onHide() {
    _isShowing = false;
    _lastHidden = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
