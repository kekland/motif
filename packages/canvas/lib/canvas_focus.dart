import 'package:flutter/widgets.dart';

class InteractiveCanvasFocus extends StatefulWidget {
  const InteractiveCanvasFocus({super.key, required this.child});

  final Widget child;

  @override
  State<InteractiveCanvasFocus> createState() => _InteractiveCanvasFocusState();
}

class _InteractiveCanvasFocusState extends State<InteractiveCanvasFocus> {
  late final focusNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_onPrimaryFocusChanged);
  }

  void _onPrimaryFocusChanged() {
    final primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus == focusNode.enclosingScope) focusNode.requestFocus();
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onPrimaryFocusChanged);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      canRequestFocus: true,
      descendantsAreFocusable: true,
      node: focusNode,
      child: widget.child,
    );
  }
}
