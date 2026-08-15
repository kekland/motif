import 'package:flutter/material.dart';

class MaybeListenableBuilder extends StatelessWidget {
  const MaybeListenableBuilder({
    super.key,
    required this.values,
    required this.builder,
  });

  final Iterable<Object> values;
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    if (values.any((v) => v is! Listenable)) return builder(context);

    return ListenableBuilder(
      listenable: Listenable.merge(values.cast()),
      builder: (context, _) => builder(context),
    );
  }
}
