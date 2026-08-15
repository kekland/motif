import 'package:app/imports.dart';
import 'package:native/native.dart';

class RootNavigationBar extends StatelessWidget {
  const RootNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: SafeArea(
        top: true,
        bottom: false,
        child: WindowTitlebar(
          preferredHeight: 48.0,
          trafficLightsHorizontalOffset: 12.0,
          child: Row(
            children: [
              VerticalDivider(),
              GestureSurface(
                onTap: () {},
                width: 48.0,
                height: 48.0,
                child: Center(child: Icons.home()),
              ),
              VerticalDivider(),
              GestureSurface(
                onTap: () {},
                height: 48.0,
                state: {.selected},
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  widthFactor: 1.0,
                  child: Row(
                    children: [
                      Icons.pen(),
                      const SizedBox(width: 6.0),
                      Text(
                        'Document',
                        style: context.typography.body,
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
