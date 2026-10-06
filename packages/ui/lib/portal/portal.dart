import 'dart:async';

import 'package:bindings/bindings.dart';
import 'package:flutter/material.dart' show Material;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:state/state.dart';

part 'portal_root.dart';
part 'portal_entry_widget.dart';
part 'portal_proxy_navigator.dart';
part 'portal_anchor.dart';
part 'portal_hooks.dart';

class Portal {
  static PortalRootState? maybeOf(BuildContext context) => context.findAncestorStateOfType<PortalRootState>();
  static PortalRootState of(BuildContext context) => maybeOf(context)!;
  static RenderBox renderOf(BuildContext context) => of(context).overlayRenderObject;

  static Future<T?> push<T>(BuildContext context, PortalEntry<T> entry) => entry.push(context);
}

typedef PortalEntryBuilder = Widget Function(
  BuildContext context,
);

typedef PortalScrimBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
);

typedef PortalAnchorBuilder = Widget Function(
  BuildContext context,
  PortalAnchor? anchor,
  Widget child,
);

typedef PortalEntryTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

class PortalEntry<T> with ChangeNotifier {
  new({
    required this.builder,
    this.anchorBuilder,
    this.scrimBuilder,
    this.animationStyle = .noAnimation,
    this.transitionBuilder,
    this.isModal = false,
  });

  final PortalEntryBuilder builder;
  final AnimationStyle animationStyle;
  final PortalScrimBuilder? scrimBuilder;
  final PortalAnchorBuilder? anchorBuilder;
  final PortalEntryTransitionBuilder? transitionBuilder;
  final bool isModal;

  var _isActive = false;
  bool get isActive => _isActive;
  bool get isRemoved => !_isActive;

  PortalRootState? _root;
  Completer<T?>? _completer;
  int? _poppedModalPointerId;

  Future<T?> push(BuildContext context, {PortalAnchor? anchor, Object? uniqueKey}) {
    // If the modal was popped by a pointer event, check if the same pointer event wants to push this.
    if (_poppedModalPointerId != null) {
      final activePointerIds = GlobalPointerTracker.instance.activePointerIds;
      if (activePointerIds.singleOrNull == _poppedModalPointerId) return Future.value(null);
    }

    _insert(context, anchor: anchor, uniqueKey: uniqueKey);
    return _completer!.future;
  }

  void _insert(BuildContext context, {PortalAnchor? anchor, Object? uniqueKey}) {
    if (_isActive) return;
    _root = context.findAncestorStateOfType<PortalRootState>()!;
    _root!.push(context, this, anchor: anchor, uniqueKey: uniqueKey);
    _isActive = true;
    _completer = .new();
    notifyListeners();
  }

  void _resolve(T? result) => _completer?.complete(result);

  void pop({T? result, bool force = false, int? pointerId}) {
    if (!_isActive) return;
    _poppedModalPointerId = pointerId;

    _isActive = false;
    _root!.pop(this, force: force);

    if (!_completer!.isCompleted) _resolve(result);
    notifyListeners();
  }

  @override
  void dispose() {
    if (isActive) pop(force: true);
    super.dispose();
  }
}
