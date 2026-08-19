import 'package:flutter/gestures.dart';
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
    this.border,
    this.borderRadius,
  });

  final bool autofocus;
  final Widget? leading;
  final Widget? trailing;
  final bool useTabularFigures;
  final EdgeInsets padding;
  final String? hintText;
  final TextStyle? textStyle;
  final ProxyWidgetBuilder? builder;
  final BorderSide? border;
  final BorderRadius? borderRadius;

  TextFieldOptions merge(TextFieldOptions other) => .new(
    leading: other.leading ?? leading,
    trailing: other.trailing ?? trailing,
    useTabularFigures: other.useTabularFigures || useTabularFigures,
    autofocus: other.autofocus || autofocus,
    padding: other.padding,
    hintText: other.hintText ?? hintText,
    textStyle: other.textStyle ?? textStyle,
    builder: other.builder ?? builder,
    border: other.border ?? border,
    borderRadius: other.borderRadius ?? borderRadius,
  );

  @override
  bool operator ==(Object other) =>
      other is TextFieldOptions &&
      other.leading == leading &&
      other.trailing == trailing &&
      other.useTabularFigures == useTabularFigures &&
      other.autofocus == autofocus &&
      other.padding == padding &&
      other.hintText == hintText &&
      other.textStyle == textStyle &&
      other.builder == builder &&
      other.border == border &&
      other.borderRadius == borderRadius;

  @override
  int get hashCode => Object.hash(
    leading,
    trailing,
    useTabularFigures,
    autofocus,
    padding,
    hintText,
    textStyle,
    builder,
    border,
    borderRadius,
  );
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
    this.supportedDevices,
    this.options = const .new(),
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Set<PointerDeviceKind>? supportedDevices;
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

    final focusScope = useFocusScopeNode();
    $useListenerEffect(
      focusScope,
      () {
        if (!focusScope.hasFocus) return;
        controller.selection = .new(baseOffset: 0, extentOffset: controller.text.length);
      },
      callImmediately: true,
    );

    final autofocus = options.autofocus;
    final leading = options.leading;
    final trailing = options.trailing;
    final padding = options.padding;
    final hintText = options.hintText;
    final textStyle = options.textStyle;
    final useTabularFigures = options.useTabularFigures;
    final builder = options.builder;
    final border = options.border;
    final borderRadius = options.borderRadius;

    final hasFocus = useFocusNodeHasFocus(focusScope);

    var effectiveTextStyle = textStyle ?? context.typography.body.primary;
    if (useTabularFigures) effectiveTextStyle = effectiveTextStyle.tabular;

    Widget child = hasFocus
        ? material.TextField(
            autofocus: true,
            controller: controller,
            focusNode: focusNode,
            style: effectiveTextStyle,
            inputFormatters: inputFormatters,
            onTapUpOutside: (_) => focusNode.unfocus(),
            onEditingComplete: onEditingComplete,
            onSubmitted: (_) => onSubmitted?.call(),
            onChanged: onChanged,
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: context.typography.body.tertiary,
            ),
          )
        : ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return Text(
                controller.text.isNotEmpty ? controller.text : hintText ?? '',
                style: controller.text.isNotEmpty ? effectiveTextStyle : context.typography.body.tertiary,
                maxLines: 1,
                overflow: .visible,
              );
            },
          );

    child = Surface(
      padding: padding,
      height: 32.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            DefaultForegroundStyle(
              iconSize: 16.0,
              style: context.typography.body.tertiary,
              child: leading,
            ),
            SizedBox(width: 6.0),
          ],
          Expanded(
            child: child,
          ),
          if (trailing != null) ...[
            SizedBox(width: 6.0),
            DefaultForegroundStyle(
              iconSize: 16.0,
              style: context.typography.body.tertiary,
              child: trailing,
            ),
          ],
        ],
      ),
    );

    if (builder != null) {
      child = builder(context, child);
    }

    return TextFieldTapRegion(
      child: FocusScope(
        autofocus: autofocus,
        node: focusScope,
        child: GestureSurface(
          onTap: () {
            focusScope.requestFocus();
            // controller.selection = .new(baseOffset: 0, extentOffset: controller.text.length);
          },
          supportedDevices: supportedDevices,
          width: double.infinity,
          color: context.colors.surface.secondary,
          borderSide:
              border ?? .new(color: hasFocus ? context.colors.accent.primary.background : context.colors.divider),
          borderRadius: borderRadius ?? .circular(4.0),
          cursor: SystemMouseCursors.text,
          state: {if (hasFocus) .focused},
          child: child,
        ),
      ),
    );
  }
}
