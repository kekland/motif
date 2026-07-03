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
    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: Center(
        child: GestureSurface(
          width: 20.0,
          height: 20.0,
          borderRadius: .circular(4.0),
          borderSide: .new(color: context.colors.divider),
          color: value ? context.colors.accent.tertiary : context.colors.surface.secondary,
          onTap: onChanged != null ? () => onChanged!(!value) : null,
          child: value ? Icons.check(size: 16.0) : null,
        ),
      ),
    );
  }
}
