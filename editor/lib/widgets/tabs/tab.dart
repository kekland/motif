import 'dart:math';

import 'package:editor/imports.dart';
import 'package:editor/widgets/tabs/generators_tab.dart';
import 'package:editor/widgets/tabs/variables_tab.dart';

class EditorTabWidget extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = useExistingSignal(context.editor.tab).value;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: OverflowBox(
            alignment: .topCenter,
            minHeight: 192.0,
            maxHeight: max(192.0, constraints.maxHeight),
            fit: .deferToChild,
            child: switch (selectedTab) {
              .generators => GeneratorsTab(),
              .variables => VariablesTab(),
              _ => Container(),
            },
          ),
        );
      }
    );
  }
}
