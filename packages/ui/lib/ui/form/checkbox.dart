import 'package:ui/ui.dart';

class Checkbox extends StatelessWidget {
  const new({
    super.key,
    required this.value,
    this.onChanged,
  });

  final ReadonlySignal<bool> value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      onTap: onChanged != null ? () => onChanged!(!value()) : null,
      width: 28.0,
      height: 28.0,
      borderRadius: .circular(4.0),
      child: SignalBuilder(
        builder: (context) => CheckboxIcon(value: value()),
      ),
    );
  }
}

class CheckboxIcon extends StatelessWidget {
  const new({
    super.key,
    required this.value,
  });

  final bool value;

  @override
  Widget build(BuildContext context) {
    return DefaultForegroundStyle(
      iconFill: value ? 1.0 : 0.0,
      iconWeight: value ? 400.0 : 200.0,
      color: value ? context.colors.accent.primary : context.colors.accent.secondary,
      child: value ? Icons.checkbox_checked() : Icons.checkbox(),
    );
  }
}
