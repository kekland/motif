import 'package:app/imports.dart';
import 'package:app/app/root_navigation_bar.dart';
import 'package:design/widgets/editor.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: RootNavigationBar(),
          ),
          Divider(height: 1.0),
          Expanded(
            // child: VectorEditorPage(),
            child: DesignEditorPage(),
          ),
        ],
      ),
    );
  }
}
