import 'package:flutter/gestures.dart';
import 'package:ui/ui.dart';

final class const InputFieldOptions({
  final bool autofocus = false,
  final bool hasFocus = false,
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
  final bool isFlat = false,
  final bool fillHeight = false,
  final bool focusOnDoubleTap = false,
  final bool ignoreGestures = false,
}) with Equatable {
  InputFieldOptions merge(InputFieldOptions other) => .new(
    leading: other.leading ?? leading,
    trailing: other.trailing ?? trailing,
    useTabularFigures: other.useTabularFigures || useTabularFigures,
    autofocus: other.autofocus || autofocus,
    hasFocus: other.hasFocus || hasFocus,
    padding: other.padding,
    hintText: other.hintText ?? hintText,
    textStyle: other.textStyle ?? textStyle,
    builder: other.builder ?? builder,
    color: other.color ?? color,
    border: other.border ?? border,
    borderRadius: other.borderRadius ?? borderRadius,
    supportedDevices: other.supportedDevices ?? supportedDevices,
    isFlat: other.isFlat || isFlat,
    fillHeight: other.fillHeight || fillHeight,
    focusOnDoubleTap: other.focusOnDoubleTap || focusOnDoubleTap,
    ignoreGestures: other.ignoreGestures || ignoreGestures,
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
    isFlat,
    fillHeight,
    focusOnDoubleTap,
    ignoreGestures,
  ];

  InputFieldOptions copyWith({
    bool? autofocus,
    bool? hasFocus,
    Widget? leading,
    Widget? trailing,
    bool? useTabularFigures,
    EdgeInsets? padding,
    Set<PointerDeviceKind>? supportedDevices,
    String? hintText,
    TextStyle? textStyle,
    ProxyWidgetBuilder? builder,
    Color? color,
    BorderSide? border,
    BorderRadius? borderRadius,
    bool? isFlat,
    bool? fillHeight,
    bool? focusOnDoubleTap,
    bool? ignoreGestures,
  }) => .new(
    autofocus: autofocus ?? this.autofocus,
    hasFocus: hasFocus ?? this.hasFocus,
    leading: leading ?? this.leading,
    trailing: trailing ?? this.trailing,
    useTabularFigures: useTabularFigures ?? this.useTabularFigures,
    padding: padding ?? this.padding,
    supportedDevices: supportedDevices ?? this.supportedDevices,
    hintText: hintText ?? this.hintText,
    textStyle: textStyle ?? this.textStyle,
    builder: builder ?? this.builder,
    color: color ?? this.color,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    isFlat: isFlat ?? this.isFlat,
    fillHeight: fillHeight ?? this.fillHeight,
    focusOnDoubleTap: focusOnDoubleTap ?? this.focusOnDoubleTap,
    ignoreGestures: ignoreGestures ?? this.ignoreGestures,
  );
}

class InputFieldSurface extends StatelessWidget {
  const new({
    super.key,
    required this.builder,
    required this.hasFocus,
    required this.options,
    this.onTap,
    this.onTapDown,
    this.cursor = SystemMouseCursors.text,
  });

  final bool hasFocus;
  final InputFieldOptions options;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final MouseCursor? cursor;
  final Widget Function(BuildContext context, TextStyle style, TextStyle hintStyle) builder;

  @override
  Widget build(BuildContext context) {
    final leading = options.leading;
    final trailing = options.trailing;
    var padding = options.padding;
    final textStyle = options.textStyle;
    final useTabularFigures = options.useTabularFigures;
    final builder = options.builder;
    var color = options.color;
    final border = options.border;
    final borderRadius = options.borderRadius;
    final hasFocus = this.hasFocus || options.hasFocus;

    if (options.isFlat) {
      color = Colors.transparent;
    }

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
      height: options.fillHeight ? .infinity : 32.0,
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

    if (options.isFlat) {
      resolvedBorder = .none;
    }

    final hasOnTap = !options.ignoreGestures && !options.focusOnDoubleTap;
    final hasOnDoubleTap = !options.ignoreGestures && options.focusOnDoubleTap;

    return GestureSurface(
      onTap: hasOnTap ? onTap : null,
      onDoubleTap: hasOnDoubleTap ? onTap : null,
      onTapDown: onTapDown,
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
    this.onTapDown,
  });

  final FocusNode? focusNode;
  final InputFieldOptions options;
  final MouseCursor? cursor;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;
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
          onTapDown: onTapDown,
          builder: (context, style, hintStyle) => builder(context, node, style, hintStyle),
        );
      },
    );
  }
}
