import 'package:flutter/widgets.dart';

class Command {
  const Command({
    required this.name,
    required this.intentBuilder,
  });

  final String name;
  final Intent Function() intentBuilder;
}
