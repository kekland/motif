part of '../core.dart';

class SceneNodeNotifier with ChangeNotifier {
  SceneNodeNotifier();

  final _aspectNotifiers = <NodeUpdateAspect, ChangeNotifier>{};

  void notify(NodeUpdateAspect flags) {
    // Update the listeners that listen to any updates.
    notifyListeners();

    // Update specific aspect listeners.
    for (final type in _aspectNotifiers.keys) {
      if ((flags & type).value != 0) {
        final notifier = _aspectNotifiers[type]!;
        notifier.notifyListeners();
      }
    }
  }

  ChangeNotifier aspect(NodeUpdateAspect aspect) {
    return _aspectNotifiers.putIfAbsent(aspect, () => ChangeNotifier());
  }

  @override
  void dispose() {
    for (final notifier in _aspectNotifiers.values) notifier.dispose();
    _aspectNotifiers.clear();
    super.dispose();
  }
}
