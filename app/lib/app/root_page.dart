import 'package:app/imports.dart';
import 'package:app/app/root_navigation_bar.dart';

class RootPage extends HookWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = useDisposable(() => Editor());

    return Scaffold(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(width: double.infinity, child: RootNavigationBar()),
              Divider(height: 1.0),
              Expanded(child: EditorWidget(editor: editor)),
            ],
          ),
        ],
      ),
    );
  }
}
