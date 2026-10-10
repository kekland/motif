import 'package:editor/imports.dart';

final class const PrefabsTab({
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Coming soon!',
        style: context.typography.subtitle.tertiary,
      ),
    );
  }
}
