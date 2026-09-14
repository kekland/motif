import 'dart:math';

import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

part 'command_intent.dart';
part 'commander.dart';
part 'commander_search.dart';

Iterable<Object> queryActions(BuildContext context) {
  final actions = <Action>[];

  context.visitAncestorElements((e) {
    final widget = e.widget;

    if (widget is Actions) {
      actions.addAll(widget.actions.values);
    }

    if (widget is Shortcuts) {}

    return true;
  });

  return actions;
}
