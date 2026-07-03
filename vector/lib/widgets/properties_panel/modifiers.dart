part of '../properties_panel.dart';

class _Modifiers extends HookWidget {
  const _Modifiers({
    super.key,
    required this.cell,
  });

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    final cell = useExistingSignal(this.cell()).value;
    final children = <Widget>[];

    for (var i = 0; i < cell.modifiers.length; i++) {
      final modifier = cell.modifiers.elementAt(i);
      children.add(
        ModifierWidget(
          modifier: modifier,
          onApply: () {},
          onChanged: (v) {
            if (v == null) {
              final modifiers = cell.modifiers.toList();
              modifiers.removeAt(i);
              cell.modifiers = modifiers;
            } else {
              final modifiers = cell.modifiers.toList();
              modifiers[i] = v;
              cell.modifiers = modifiers;
            }
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        Subtitle(
          leading: Icons.wrench(),
          trailing: Builder(
            builder: (context) {
              return Button(
                onTap: () async {
                  final modifier = await WindowNavigator.pushUnique(
                    context,
                    AddModifierWindow.createEntry(
                      context,
                      controller: .of(context),
                    ),
                  );
                  if (modifier == null) return;

                  final modifiers = cell.modifiers.toList();
                  modifiers.add(modifier);
                  cell.modifiers = modifiers;
                },
                leading: Icons.add(),
                child: Text('Add'),
              );
            },
          ),
          child: Text('Modifiers'),
        ),

        for (final child in children) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: child,
          ),
          const SizedBox(height: 8.0),
        ],
      ],
    );
  }
}
