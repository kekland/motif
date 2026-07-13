part of '../core.dart';

extension SceneLayout on Scene {
  void _layout() {
    final _needingLayout = _objectsNeedingLayout.toList();

    for (final object in _needingLayout) {
      // print('layout: ${object}');
      object.layout(.new());
    }

    // print('still needs layout: ${_objectsNeedingLayout.difference(_needingLayout.toSet())}');
    _objectsNeedingLayout.clear();
  }
}
