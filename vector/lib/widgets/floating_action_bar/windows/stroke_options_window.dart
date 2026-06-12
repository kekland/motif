import 'package:vector/imports.dart';

class StrokeOptionsWindow extends StatelessWidget {
  const StrokeOptionsWindow({super.key});

  static WindowEntry createEntry(BuildContext context) {
    return WindowEntry.withContextAnchor(
      context,
      builder: (_) => StrokeOptionsWindow(),
      isModal: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WindowScaffold(
      title: 'Options',
      child: Container(),
    );
  }
}
