import 'package:flutter/material.dart';

class UnconstrainedOverflowBox extends StatelessWidget {
  const UnconstrainedOverflowBox({
    super.key,
    this.alignment = Alignment.center,
    required this.child,
  });

  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: 0.0,
      minHeight: 0.0,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      alignment: alignment,
      child: child,
    );
  }
}
