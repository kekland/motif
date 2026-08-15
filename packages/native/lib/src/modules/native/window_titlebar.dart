import 'dart:io';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:objective_c/objective_c.dart';
import 'package:state/state.dart';

import 'package:native/macos.dart' as macos;
import 'package:native/native.dart';

class WindowTitlebar extends StatelessWidget {
  const WindowTitlebar({
    super.key,
    required this.child,
    required this.preferredHeight,
    this.trafficLightsHorizontalOffset = 6.0,
  });

  final double preferredHeight;
  final double trafficLightsHorizontalOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return _MacosTitlebar(
        preferredHeight: preferredHeight,
        trafficLightsHorizontalOffset: trafficLightsHorizontalOffset,
        child: child,
      );
    }

    return SizedBox(height: preferredHeight, child: child);
  }
}

class _MacosTitlebar extends SingleChildRenderObjectWidget {
  const _MacosTitlebar({
    required Widget super.child,
    this.preferredHeight = 28.0,
    this.trafficLightsHorizontalOffset = 6.0,
  });

  final double preferredHeight;
  final double trafficLightsHorizontalOffset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMacosTitlebar(
      preferredHeight: preferredHeight,
      trafficLightsHorizontalOffset: trafficLightsHorizontalOffset,
      mediaQuerySize: MediaQuery.sizeOf(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMacosTitlebar renderObject,
  ) {
    renderObject.preferredHeight = preferredHeight;
    renderObject.trafficLightsHorizontalOffset = trafficLightsHorizontalOffset;
    renderObject.mediaQuerySize = MediaQuery.sizeOf(context);
  }
}

class _RenderMacosTitlebar extends RenderProxyBox {
  _RenderMacosTitlebar({
    required this._preferredHeight,
    required this._trafficLightsHorizontalOffset,
    required this._mediaQuerySize,
  }) {
    _fullscreenObserver = FullscreenObserver();
    _disposeEffect = effect(() {
      _onFullscreenChanged();
    });

    // Get application and window
    final application = macos.NSApplication.getSharedApplication();
    window = application.flutterWindow;

    // Get the titlebar view, compute the default title bar height and obtain/create the accessory view controller
    titlebar = window.standardWindowButton(macos.NSWindowButton.NSWindowCloseButton)!.superview!;
    var defaultTitleBarHeight = titlebar.frame.size.height;

    if (window.titlebarAccessoryViewControllers.count > 0) {
      final controller = window.titlebarAccessoryViewControllers.firstObject!;
      accessoryView = macos.NSTitlebarAccessoryViewController.fromPointer(controller.ref.pointer);
      defaultTitleBarHeight -= accessoryView.view.frame.size.height;
    } else {
      accessoryView = macos.NSTitlebarAccessoryViewController.alloc().init();
    }

    accessoryView.layoutAttribute = macos.NSLayoutAttribute.NSLayoutAttributeBottom;
    this.defaultTitleBarHeight = defaultTitleBarHeight;

    // Get the buttons and their leading offsets
    closeButton = window.standardWindowButton(macos.NSWindowButton.NSWindowCloseButton)!;
    minimizeButton = window.standardWindowButton(macos.NSWindowButton.NSWindowMiniaturizeButton)!;
    zoomButton = window.standardWindowButton(macos.NSWindowButton.NSWindowZoomButton)!;

    final firstLeadingOffset = closeButton.frame.origin.x;
    originalButtonLeadingOffsets = buttons.map((b) => b.frame.origin.x - firstLeadingOffset).toList();

    // macOS sometimes resets the button positions after the first frame, so we just reapply the positions after it.
    if (!WidgetsBinding.instance.firstFrameRasterized) {
      WidgetsBinding.instance.addPostFrameCallback((_) => markNeedsLayout());
    }
  }

  @override
  void dispose() {
    _disposeEffect();
    _fullscreenObserver.dispose();
    super.dispose();
  }

  late double _preferredHeight;
  double get preferredHeight => _preferredHeight;
  set preferredHeight(double value) {
    if (_preferredHeight == value) return;
    _preferredHeight = value;
    markNeedsLayout();
  }

  late double _trafficLightsHorizontalOffset;
  double get trafficLightsHorizontalOffset => _trafficLightsHorizontalOffset;
  set trafficLightsHorizontalOffset(double value) {
    if (_trafficLightsHorizontalOffset == value) return;
    _trafficLightsHorizontalOffset = value;
    markNeedsLayout();
  }

  late Size _mediaQuerySize;
  Size get mediaQuerySize => _mediaQuerySize;
  set mediaQuerySize(Size value) {
    if (_mediaQuerySize == value) return;
    _mediaQuerySize = value;
    markNeedsLayout();
  }

  late final VoidCallback _disposeEffect;
  late final FullscreenObserver _fullscreenObserver;
  bool get isFullscreen => _fullscreenObserver.isFullscreen;

  late final macos.NSWindow window;
  late final macos.NSView titlebar;
  late final double defaultTitleBarHeight;
  late final macos.NSTitlebarAccessoryViewController accessoryView;

  late final macos.NSButton closeButton;
  late final macos.NSButton minimizeButton;
  late final macos.NSButton zoomButton;

  List<macos.NSButton> get buttons => [closeButton, minimizeButton, zoomButton];
  late final List<double> originalButtonLeadingOffsets;

  late Offset childOffset;

  var _didLayout = false;

  @override
  void performLayout() {
    withZoneArena(() {
      makeWindowBorderless();

      // Initial setup and cleanup
      if (window.titlebarAccessoryViewControllers.count > 0) window.removeTitlebarAccessoryViewControllerAtIndex(0);

      var titleBarHeight = defaultTitleBarHeight;

      // Setup accessory view and compute constraints
      if (preferredHeight > defaultTitleBarHeight) {
        final accessoryViewHeight = preferredHeight - 28.0;
        accessoryView.view.frame = macos.Structs.CGRect(0.0, 0.0, 0.0, accessoryViewHeight);
        window.addTitlebarAccessoryViewController(accessoryView);
        titleBarHeight = preferredHeight;
      }

      // Perform own layout
      size = Size(constraints.maxWidth, titleBarHeight);

      // Position buttons: in fullscreen we use the default title bar and button positions.
      late final double buttonsExtent;

      if (isFullscreen) {
        buttonsExtent = 0.0;
      } else {
        buttonsExtent = _positionButtons();
      }

      // Perform layout
      final childMaxSize = Size(size.width - buttonsExtent, size.height);
      child!.layout(BoxConstraints.loose(childMaxSize));
      childOffset = Offset(buttonsExtent, 0.0);

      _didLayout = true;
    });
  }

  // Positions the buttons, returns the total width of the buttons + left/right spacing
  double _positionButtons() {
    double _maxButtonTraillingOffset = 0.0;

    for (var i = 0; i < buttons.length; i++) {
      final button = buttons[i];
      final originalLeadingOffset = originalButtonLeadingOffsets[i];

      final x = trafficLightsHorizontalOffset + originalLeadingOffset;
      final y = (size.height - button.frame.size.height) * 0.5;
      button.frame = macos.Structs.CGRect(x, y, button.frame.size.width, button.frame.size.height);

      final trailingOffset = x + button.frame.size.width;
      _maxButtonTraillingOffset = max(trailingOffset, _maxButtonTraillingOffset);
    }

    return _maxButtonTraillingOffset + trafficLightsHorizontalOffset;
  }

  void _onFullscreenChanged() {
    if (!_didLayout) return;

    if (isFullscreen) {
      accessoryView.isHidden = true;
      markNeedsLayout();
    } else {
      accessoryView.isHidden = false;
      markNeedsLayout();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset + childOffset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return super.hitTest(result, position: position - childOffset);
  }
}
