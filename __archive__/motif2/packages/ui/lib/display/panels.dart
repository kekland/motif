import 'package:flutter/widgets.dart';

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.title,
    required this.child,
  });

  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        title,
        child,
      ],
    );
  }
}
