import 'package:app/imports.dart';
import 'package:stack_ffi/stack_ffi.dart';

class RootNavigationBar extends StatelessWidget {
  const RootNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: WindowTitlebar(
        preferredHeight: 48.0,
        trafficLightsHorizontalOffset: 12.0,
        child: Container(),
      ),
    );
  }
}
