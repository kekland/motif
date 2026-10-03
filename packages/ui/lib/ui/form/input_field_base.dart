import 'package:flutter/gestures.dart';
import 'package:ui/ui.dart';

final class const InputFieldOptions({
  final bool autofocus = false,
  final Widget? leading,
  final Widget? trailing,
  final bool useTabularFigures = false,
  final EdgeInsets padding = const .symmetric(horizontal: 6.0),
  final Set<PointerDeviceKind>? supportedDevices,
  final String? hintText,
  final TextStyle? textStyle,
  final ProxyWidgetBuilder? builder,
  final Color? color,
  final BorderSide? border,
  final BorderRadius? borderRadius,
}) with Equatable {
  InputFieldOptions merge(InputFieldOptions other) => .new(
    leading: other.leading ?? leading,
    trailing: other.trailing ?? trailing,
    useTabularFigures: other.useTabularFigures || useTabularFigures,
    autofocus: other.autofocus || autofocus,
    padding: other.padding,
    hintText: other.hintText ?? hintText,
    textStyle: other.textStyle ?? textStyle,
    builder: other.builder ?? builder,
    color: other.color ?? color,
    border: other.border ?? border,
    borderRadius: other.borderRadius ?? borderRadius,
    supportedDevices: other.supportedDevices ?? supportedDevices,
  );

  @override
  List<Object?> get props => [
    autofocus,
    leading,
    trailing,
    useTabularFigures,
    padding,
    supportedDevices,
    hintText,
    textStyle,
    builder,
    color,
    border,
    borderRadius,
  ];
}

class InputFieldSurface extends StatelessWidget {
  const new({
    super.key,
    required this.builder,
    required this.hasFocus,
    required this.options,
    this.onTap,
    this.cursor = SystemMouseCursors.text,
  });

  final bool hasFocus;
  final InputFieldOptions options;
  final VoidCallback? onTap;
  final MouseCursor? cursor;
  final Widget Function(BuildContext context, TextStyle style, TextStyle hintStyle) builder;

  @override
  Widget build(BuildContext context) {
    final leading = options.leading;
    final trailing = options.trailing;
    final padding = options.padding;
    final textStyle = options.textStyle;
    final useTabularFigures = options.useTabularFigures;
    final builder = options.builder;
    final color = options.color;
    final border = options.border;
    final borderRadius = options.borderRadius;

    var effectiveTextStyle = textStyle ?? context.typography.body.primary;
    if (useTabularFigures) effectiveTextStyle = effectiveTextStyle.tabular;

    final hintStyle = effectiveTextStyle.copyWith(color: context.colors.display.tertiary);
    Widget child = this.builder(
      context,
      effectiveTextStyle,
      hintStyle,
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

    var resolvedBorder = border ?? .new(color: context.colors.divider);
    if (hasFocus) {
      resolvedBorder = resolvedBorder.copyWith(color: context.colors.accent.primary.background);
    }

    return GestureSurface(
      onTap: onTap,
      width: double.infinity,
      supportedDevices: options.supportedDevices,
      color: color ?? context.colors.surface.secondary,
      borderSide: resolvedBorder,
      borderRadius: borderRadius ?? .circular(4.0),
      cursor: cursor ?? .defer,
      state: {if (hasFocus) .focused},
      child: child,
    );
  }
}

class InputFieldFocus extends HookWidget {
  const InputFieldFocus({
    super.key,
    required this.builder,
    required this.options,
    this.focusNode,
  });

  final FocusNode? focusNode;
  final InputFieldOptions options;
  final Widget Function(BuildContext context, FocusNode node) builder;

  @override
  Widget build(BuildContext context) {
    final focusNode = useManagedResource(
      create: () => FocusNode(),
      dispose: (v) => v.dispose(),
      value: this.focusNode,
    );

    useListenable(focusNode);

    return Focus(
      autofocus: options.autofocus,
      focusNode: focusNode,
      child: builder(context, focusNode),
    );
  }
}

class InputFieldBase extends StatelessWidget {
  const new({
    super.key,
    required this.builder,
    required this.options,
    this.cursor,
    this.focusNode,
    this.onTap,
  });

  final FocusNode? focusNode;
  final InputFieldOptions options;
  final MouseCursor? cursor;
  final VoidCallback? onTap;
  final Widget Function(BuildContext context, FocusNode node, TextStyle style, TextStyle hintStyle) builder;

  @override
  Widget build(BuildContext context) {
    return InputFieldFocus(
      focusNode: focusNode,
      options: options,
      builder: (context, node) {
        return InputFieldSurface(
          hasFocus: node.hasFocus,
          options: options,
          cursor: cursor,
          onTap: onTap,
          builder: (context, style, hintStyle) => builder(context, node, style, hintStyle),
        );
      },
    );
  }
}
