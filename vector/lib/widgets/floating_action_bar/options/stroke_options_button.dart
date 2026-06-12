part of '../floating_action_bar.dart';

class StrokeOptionsButton extends HookWidget {
  const StrokeOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final (createWindow, hasWindow) = useCreateWindowEntry(context, StrokeOptionsWindow.createEntry);

    return GestureSurface(
      onTap: createWindow,
      width: 40.0,
      height: 40.0,
      borderRadius: hasWindow ? .circular(20.0) : .circular(8.0),
      color: Surface.colorOf(context),
      child: Center(child: Icons.tune()),
    );
  }
}
