import 'package:flutter/widgets.dart';

List<Route<dynamic>> _generateInitialRoutes(NavigatorState navigator, String initialRouteName) {
  return [];
}

class WindowProxyNavigator<T> extends Navigator {
  const WindowProxyNavigator({
    super.key,
    required this.child,
    required this.onPop,
  }) : super(
         onGenerateInitialRoutes: _generateInitialRoutes,
         pages: const [],
       );

  final Widget child;
  final void Function(dynamic) onPop;

  @override
  NavigatorState createState() => WindowProxyNavigatorState();
}

class WindowProxyNavigatorState extends NavigatorState {
  late final NavigatorState _proxyingNavigator;

  @override
  void initState() {
    super.initState();
    _proxyingNavigator = Navigator.of(context);
  }

  @override
  // ignore: must_call_super
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}

  @override
  WindowProxyNavigator get widget => super.widget as WindowProxyNavigator;

  // dart format off
  @override bool canPop() => true;
  @override Future<T?> push<T extends Object?>(Route<T> route) => _proxyingNavigator.push(route);
  @override Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) => _proxyingNavigator.pushNamed(routeName, arguments: arguments);
  @override Future<T?> pushAndRemoveUntil<T extends Object?>(Route<T> newRoute, RoutePredicate predicate) => _proxyingNavigator.pushAndRemoveUntil(newRoute, predicate);
  @override Future<T?> pushNamedAndRemoveUntil<T extends Object?>(String newRouteName, RoutePredicate predicate, {Object? arguments}) => _proxyingNavigator.pushNamedAndRemoveUntil(newRouteName, predicate, arguments: arguments);
  @override Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Route<T> newRoute, {TO? result}) => _proxyingNavigator.pushReplacement(newRoute, result: result);
  @override Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(String routeName, {TO? result, Object? arguments}) => _proxyingNavigator.pushReplacementNamed(routeName, result: result, arguments: arguments);
  @override void replace<T extends Object?>({required Route<dynamic> oldRoute, required Route<T> newRoute})=> _proxyingNavigator.replace(oldRoute: oldRoute, newRoute: newRoute);
  @override void replaceRouteBelow<T extends Object?>({required Route<dynamic> anchorRoute, required Route<T> newRoute}) => _proxyingNavigator.replaceRouteBelow(anchorRoute: anchorRoute, newRoute: newRoute);
  // dart format on

  @override
  void pop<T extends Object?>([T? result]) => widget.onPop(result);

  @override
  Future<bool> maybePop<T extends Object?>([T? result]) async {
    widget.onPop(result);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
