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

    Widget body = DefaultForegroundStyle(
      style: context.typography.body.copyWith(color: titleColor),
      iconSize: 18.0,
      maxLines: 1,
      overflow: .ellipsis,
      child: title ?? SizedBox.shrink(),
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

    if (leading != null || trailing != null) {
      body = Row(
        mainAxisSize: expands ? .max : .min,
        children: [
          if (leading != null) ...[
            DefaultForegroundStyle(
              color: iconColor,
              iconSize: 18.0,
              child: leading!,
            ),
            if (title != null) const SizedBox(width: 6.0),
          ],
          Flexible(
            fit: expands ? .tight : .loose,
            child: body,
          ),
          if (trailing != null) ...[
            const SizedBox(width: 6.0),
            DefaultForegroundStyle(
              color: context.colors.display.tertiary,
              style: context.typography.caption.tertiary,
              child: trailing!,
            ),
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
      _ => const .only(left: 8.0, right: 6.0),
    };

    if (onTap == null) {
      return Surface(
        color: isSelected ? _selectedColor : color,
        padding: padding ?? defaultPadding,
        width: width,
        height: height ?? defaultHeight,
        child: Align(
          alignment: .centerLeft,
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
      child: Align(
        alignment: .centerLeft,
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
