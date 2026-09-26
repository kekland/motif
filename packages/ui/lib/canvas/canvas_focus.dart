import 'package:flutter/widgets.dart';

class InteractiveCanvasFocus extends StatefulWidget {
  const InteractiveCanvasFocus({
    super.key,
    required this.focusScopeNode,
    required this.child,
  });

  final FocusScopeNode focusScopeNode;
  final Widget child;

  @override
  State<InteractiveCanvasFocus> createState() => _InteractiveCanvasFocusState();
}

class _InteractiveCanvasFocusState extends State<InteractiveCanvasFocus> {
  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_onPrimaryFocusChanged);
  }

  void _onPrimaryFocusChanged() {
    final primaryFocus = FocusManager.instance.primaryFocus;

    var request = false;
    if (primaryFocus == null) {
      request = true;
    } else if (primaryFocus.ancestors.isEmpty) {
      request = true;
    } else if (primaryFocus == widget.focusScopeNode.enclosingScope) {
      request = true;
    }

    if (request) {
      widget.focusScopeNode.requestFocus();
    }
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onPrimaryFocusChanged);
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _onPrimaryFocusChanged();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      canRequestFocus: true,
      descendantsAreFocusable: true,
      node: widget.focusScopeNode,
      child: widget.child,
    );
  }
}
