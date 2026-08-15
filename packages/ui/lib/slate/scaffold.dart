part of 'slate.dart';

class Scaffold extends StatelessWidget {
  const Scaffold({
    super.key,
    this.backgroundColor,
    this.isFullScreen = true,
    this.resizeToAvoidBottomInset = true,
    required this.child,
  });

  final Color? backgroundColor;
  final bool isFullScreen;
  final bool resizeToAvoidBottomInset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scrollController = PrimaryScrollController.of(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);

    Widget child;

    child = BackdropGroup(
      child: Padding(
        padding: resizeToAvoidBottomInset ? viewInsets : EdgeInsets.zero,
        child: Builder(
          builder: (context) {
            return MediaQuery.removeViewInsets(
              context: context,
              removeTop: resizeToAvoidBottomInset,
              removeBottom: resizeToAvoidBottomInset,
              removeLeft: resizeToAvoidBottomInset,
              removeRight: resizeToAvoidBottomInset,
              child: this.child,
            );
          },
        ),
      ),
    );

    const transparent = Color(0x00000000);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: context.brightness,
        statusBarIconBrightness: context.brightness.inverse,
        statusBarColor: transparent,
        systemNavigationBarColor: transparent,
        systemNavigationBarDividerColor: transparent,
        systemNavigationBarIconBrightness: context.brightness.inverse,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Stack(
        children: [
          material.Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: backgroundColor,
            body: Surface(color: backgroundColor, child: child),
          ),

          // Only add the tap-to-scroll-to-top area on iOS when we're guaranteed that the scaffold is full-screen
          if (isFullScreen && !kIsWeb && Platform.isIOS)
            ListenableBuilder(
              listenable: scrollController,
              builder: (context, child) {
                if (scrollController.hasClients) {
                  return child!;
                }

                return const SizedBox.shrink();
              },
              child: Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                height: MediaQuery.paddingOf(context).top,
                child: GestureDetector(
                  onTap: () {
                    if (scrollController.hasClients)
                      scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeOutCirc,
                      );
                  },
                  behavior: HitTestBehavior.opaque,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
