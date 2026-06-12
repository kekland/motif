import 'package:app/imports.dart';
import 'package:app/app/root_navigation_bar.dart';
import 'package:design/widgets/editor.dart';
import 'package:vector/vector.dart';
// import 'package:design/design.dart';
import 'package:metal_capture_util/metal_capture_util.dart' as mtl_capture;

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(width: double.infinity, child: RootNavigationBar()),
              Divider(height: 1.0),
              Expanded(
                child: VectorEditorPage(),
                // child: DesignEditorPage(),
              ),
            ],
          ),
          // Positioned(
          //   bottom: 16.0,
          //   right: 16.0,
          //   child: FloatingActionButton.extended(
          //     onPressed: () {
          //       mtl_capture.MetalCapture.captureNextFrame(reassemble: true, openFile: true);
          //     },
          //     label: Text('Capture')
          //   ),
          // ),
        ],
      ),
    );
  }
}
