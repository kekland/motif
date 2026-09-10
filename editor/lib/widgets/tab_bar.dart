import 'package:ui/ui.dart';

class EditorTabBar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: ListView(
        scrollDirection: .horizontal,
        children: [
          ListItem(
            onTap: () {},
            width: 160.0,
            leading: Icons.animation(),
            title: Text('Animation'),
          ),
          VerticalDivider(),
          ListItem(
            onTap: () {},
            width: 160.0,
            leading: Icons.generator(),
            title: Text('Generators'),
          ),
          VerticalDivider(),
        ],
      ),
    );
  }
}
