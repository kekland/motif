import 'package:flutter/services.dart';
import 'package:ui/ui.dart';
import 'package:flutter/material.dart' as material;

class TextFieldOptions {
  const TextFieldOptions({
    this.leading,
    this.trailing,
    this.useTabularFigures = false,
    this.autofocus = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0),
    this.hintText,
    this.textStyle,
    this.builder,
  });

  final bool autofocus;
  final Widget? leading;
  final Widget? trailing;
  final bool useTabularFigures;
  final EdgeInsets padding;
  final String? hintText;
  final TextStyle? textStyle;
  final ProxyWidgetBuilder? builder;
}

class TextField extends HookWidget {
  const TextField({
    super.key,
    this.controller,
    this.focusNode,
    this.inputFormatters,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.options = const .new(),
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextFieldOptions options;

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

    final autofocus = options.autofocus;
    final leading = options.leading;
    final trailing = options.trailing;
    final padding = options.padding;
    final hintText = options.hintText;
    final textStyle = options.textStyle;
    final useTabularFigures = options.useTabularFigures;
    final builder = options.builder;

    final hasFocus = useFocusNodeHasFocus(focusNode);

    var effectiveTextStyle = textStyle ?? context.typography.caption1.primary;
    if (useTabularFigures) effectiveTextStyle = effectiveTextStyle.tabular;

    return TextFieldTapRegion(
      child: GestureSurface(
        onTap: () => focusNode.requestFocus(),
        width: double.infinity,
        color: context.colors.surface.secondary,
        borderSide: BorderSide(
          color: hasFocus
              ? context.colors.accent.primary.background
              : context.colors.accent.secondary.foreground!.withScaledAlpha(0.0),
        ),
        foregroundColor: hasFocus ? context.colors.accent.primary.background : context.colors.display.tertiary,
        borderRadius: BorderRadius.circular(4.0),
        padding: padding,
        cursor: SystemMouseCursors.text,
        builder: (context, states) {
          final child = SizedBox(
            height: 32.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) ...[
                  DefaultGestureReaction(
                    states: {...states, if (hasFocus) .selected},
                    child: DefaultForegroundStyle(
                      iconSize: 16.0,
                      textStyle: context.typography.caption1.tertiary,
                      child: leading,
                    ),
                  ),
                  SizedBox(width: 6.0),
                ],
                Expanded(
                  child: material.TextField(
                    autofocus: autofocus,
                    controller: controller,
                    focusNode: focusNode,
                    style: effectiveTextStyle,
                    ignorePointers: !hasFocus,
                    inputFormatters: inputFormatters,
                    onTapUpOutside: (_) => focusNode.unfocus(),
                    onEditingComplete: onEditingComplete,
                    onSubmitted: (_) => onSubmitted?.call(),
                    onChanged: onChanged,
                    decoration: InputDecoration.collapsed(
                      hintText: hintText,
                      hintStyle: context.typography.caption1.tertiary,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: 6.0),
                  DefaultGestureReaction(
                    states: {...states, if (hasFocus) .selected},
                    child: DefaultForegroundStyle(
                      iconSize: 16.0,
                      textStyle: context.typography.caption1.tertiary,
                      child: trailing,
                    ),
                  ),
                ],
              ],
            ),
          );

          if (builder != null) {
            return builder(context, child);
          } else {
            return child;
          }
        },
      ),
    );
  }
}
