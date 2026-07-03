import 'package:vector/imports.dart';
import 'package:vector/widgets/generators/generator_window.dart';

class SelectGeneratorWindow extends HookWidget {
  const SelectGeneratorWindow({super.key, required this.manager});

  final GeneratorManager manager;

  static WindowEntry<Generator> createEntry(BuildContext context, {required GeneratorManager manager}) =>
      .withContextAnchor(
        context,
        builder: (_) => SelectGeneratorWindow(manager: manager),
      );

  @override
  Widget build(BuildContext context) {
    final generators = useListenable(manager).generators;

    return WindowScaffold(
      title: Text('Generator nodes'),
      child: SizedBox(
        width: 200.0,
        height: 400.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final g in generators)
              Builder(
                builder: (context) => Tile(
                  onTap: () {
                    WindowNavigator.pushUnique(context, GeneratorWindow.createEntry(context, generator: g));
                    Navigator.pop(context, g);
                  },
                  leading: Icons.generator(),
                  title: Text(g.id),
                ),
              ),

            Builder(
              builder: (context) {
                return Tile(
                  onTap: () {
                    final g = manager.createGenerator();
                    WindowNavigator.pushUnique(
                      context,
                      GeneratorWindow.createEntry(context, generator: g),
                    );
                    Navigator.pop(context, g);
                  },
                  leading: Icons.add(),
                  title: Text('Create'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
