// import 'package:color/color.dart';
// import 'package:ui/ui.dart';

// class ColorPicker extends HookWidget {
//   const ColorPicker({
//     super.key,
//     required this.value,
//     this.onChanged,
//     this.size = 48.0,
//   });

//   final ColorData Function() value;
//   final ValueChanged<ColorData>? onChanged;
//   final double size;

//   @override
//   Widget build(BuildContext context) {
//     final computedValue = useComputed(value);
//     final (createEntry, isEntryActive) = useCreateWindowEntry(
//       (context) => ColorPickerWindow.createEntry(context, value: computedValue, onChanged: onChanged),
//     );

//     final color = computedValue.value.toUiColor();
    
//     return GestureSurface(
//       animationStyle: context.animations.effectFast,
//       onTap: () => createEntry(context),
//       width: size,
//       height: size,
//       borderRadius: isEntryActive ? .circular(20.0) : .circular(8.0),
//       color: color,
//     );
//   }
// }
