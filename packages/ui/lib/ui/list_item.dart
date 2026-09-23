import 'package:ui/ui.dart';

class const ListItem({
  super.key,
  final VoidCallback? onTap,
  final Widget? title,
  final Widget? leading,
  final Widget? trailing,
  final Widget? subtitle,
  final Color? color,
  final Color? selectedColor,
  final double? width,
  final double? height,
  final bool isSelected = false,
  final bool expands = true,
  final EdgeInsets? padding,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? null : context.colors.display.tertiary;
    final titleColor = isSelected ? null : context.colors.display.secondary;

    Widget body = Row(
      mainAxisSize: .min,
      children: [
        if (title != null)
          Flexible(
            fit: expands ? .tight : .loose,
            child: DefaultForegroundStyle(
              style: context.typography.body.copyWith(color: titleColor),
              iconSize: 18.0,
              maxLines: 1,
              overflow: .ellipsis,
              child: title!,
            ),
          ),
        if (trailing != null) ...[
          const SizedBox(width: 4.0),
          DefaultForegroundStyle(
            color: context.colors.display.tertiary,
            style: context.typography.caption.tertiary,
            child: trailing!,
          ),
        ],
      ],
    );

    if (subtitle != null) {
      body = Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          body,
          const SizedBox(height: 2.0),
          DefaultForegroundStyle(
            style: context.typography.caption.tertiary,
            child: subtitle!,
          ),
        ],
      );
    }

    if (leading != null) {
      body = Row(
        mainAxisSize: .min,
        children: [
          if (leading != null) ...[
            DefaultForegroundStyle(
              color: iconColor,
              iconSize: 18.0,
              child: leading!,
            ),
            if (title != null) const SizedBox(width: 6.0),
            Flexible(child: body),
          ],
        ],
      );
    }

    final defaultHeight = switch (subtitle) {
      null => 36.0,
      _ => 48.0,
    };

    final _selectedColor = selectedColor ?? context.colors.accent.secondary;

    final EdgeInsets defaultPadding = switch (trailing) {
      null => const .symmetric(horizontal: 8.0),
      _ => const .only(left: 8.0, right: 4.0),
    };

    if (onTap == null) {
      return Surface(
        color: isSelected ? _selectedColor : color,
        padding: padding ?? defaultPadding,
        width: width,
        height: height ?? defaultHeight,
        child: Center(
          widthFactor: 1.0,
          child: body,
        ),
      );
    }

    return GestureSurface(
      onTap: onTap,
      ignoreDisabled: true,
      color: isSelected ? _selectedColor : color,
      padding: padding ?? defaultPadding,
      width: width,
      height: height ?? defaultHeight,
      state: isSelected ? {.selected} : {},
      child: Center(
        widthFactor: 1.0,
        child: body,
      ),
    );
  }
}

class const CheckboxListItem({
  super.key,
  required final Widget title,
  final Widget? leading,
  required final ReadonlySignal<bool> value,
  final ValueChanged<bool>? onChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListItem(
      onTap: onChanged != null ? () => onChanged!(!value()) : null,
      title: title,
      leading: leading,
      trailing: Checkbox(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
