import 'package:editor/imports.dart';

import 'modifiers/fillet_modifier.dart';

final class const ModifierInputField({
  super.key,
  required super.value,
  super.onChanged,
  super.sessionCallbacks,
  super.focusNode,
  super.options,
  final VoidCallback? onRemove,
}) extends InputField<Modifier> {
  @override
  Widget build(BuildContext context) {
    final kind = useProxyComputedValue(value, (v) => v!.kind);

    final Widget body = switch (kind) {
      .fillet => FilletModifierInputField(
        value: useProxyComputed(value, (v) => v as FilletModifier),
        onChanged: onChanged,
        sessionCallbacks: sessionCallbacks,
        focusNode: focusNode,
        options: options,
      ),
    };

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        // Padding(
        //   padding: const .only(left: 12.0, bottom: 4.0),
        //   child: Text('Fillet', style: context.typography.footnote.secondary),
        // ),
        ListItem(
          title: body,
          height: 32.0,
          padding: .only(left: 12.0, right: 4.0),
          trailing: IconButton.flat(
            onTap: onRemove,
            child: Icons.remove(),
          ),
          reorderableIndex: 0,
        ),
      ],
    );
  }
}
