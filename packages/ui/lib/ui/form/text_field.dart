import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

class TextField extends HookWidget {
  const new({
    super.key,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.inputFormatters,
    this.options = const .new(),
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final InputFieldOptions options;

  @override
  Widget build(BuildContext context) {
    final controller = useManagedResource(
      value: this.controller,
      create: TextEditingController.new,
      dispose: (c) => c.dispose(),
    );

    final focusNode = useManagedResource(
      value: this.focusNode,
      create: FocusNode.new,
      dispose: (n) => n.dispose(),
    );

    final hadFocus = useRef(false);
    final fieldFocusNode = useFocusNode(skipTraversal: true);

    useListenerEffect(
      focusNode,
      () {
        if (!hadFocus.value && focusNode.hasFocus) {
          controller.selection = .new(baseOffset: 0, extentOffset: controller.text.length);
          focusNode.skipTraversal = true;
          fieldFocusNode.requestFocus();
        } else if (hadFocus.value && !focusNode.hasFocus) {
          focusNode.skipTraversal = false;
        }

        hadFocus.value = focusNode.hasFocus;
      },
    );

    return InputFieldBase(
      focusNode: focusNode,
      options: options,
      cursor: SystemMouseCursors.text,
      onTap: focusNode.requestFocus,
      builder: (context, node, style, hintStyle) {
        final hasFocus = node.hasFocus;

        if (hasFocus) {
          return material.TextField(
            autofocus: true,
            focusNode: fieldFocusNode,
            controller: controller,
            style: style,
            inputFormatters: inputFormatters,
            onTapUpOutside: (_) => focusNode.unfocus(),
            onEditingComplete: onEditingComplete,
            onSubmitted: (_) => onSubmitted?.call(),
            onChanged: onChanged,
            decoration: InputDecoration.collapsed(
              hintText: options.hintText,
              hintStyle: hintStyle,
            ),
          );
        } else {
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return Text(
                controller.text.isNotEmpty ? controller.text : options.hintText ?? '',
                style: controller.text.isNotEmpty ? style : hintStyle,
                maxLines: 1,
                overflow: .visible,
              );
            },
          );
        }
      },
    );
  }
}
