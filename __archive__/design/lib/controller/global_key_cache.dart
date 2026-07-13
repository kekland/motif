part of '../controller.dart';

class GlobalKeyCache with Disposable {
  GlobalKeyCache();

  final _globalKeyCache = <Node, GlobalKey>{};
  GlobalKey getKeyForNode(Node node) {
    return _globalKeyCache[node] ??= GlobalKey();
  }
}
