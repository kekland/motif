import 'package:ui/ui.dart';

class Checkbox extends StatelessWidget {
  const Checkbox({
    super.key,
    required this.value,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureSurface(
      width: 16.0,
      height: 16.0,
      borderRadius: .circular(4.0),
      borderSide: .new(color: context.colors.divider, width: 0.0),
      color: value ? context.colors.accent.secondary : context.colors.surface.secondary,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: value ? Icons.check(size: 12.0) : null,
    );
  }
}
