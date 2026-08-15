import 'package:flutter/widgets.dart';

class PersistentOverlayBuilder extends StatefulWidget {
  const PersistentOverlayBuilder({
    super.key,
    required this.builder,
    required this.child,
  });

  final Widget Function(BuildContext context, OverlayChildLayoutInfo info) builder;
  final Widget child;

  @override
  State<PersistentOverlayBuilder> createState() => _PersistentOverlayBuilderState();
}

class _PersistentOverlayBuilderState extends State<PersistentOverlayBuilder> {
  final controller = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.show());
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: controller,
      overlayChildBuilder: widget.builder,
      child: widget.child,
    );
  }
}
