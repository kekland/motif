part of 'prop.dart';

class PropTransaction {
  late final InputSessionCallbacks sessionCallbacks = .new(
    onStartEditing: onStartChanging,
    onEndEditing: onEndChanging,
  );

  void onStartChanging() {}
  void onEndChanging() {}
  void dispose() {}
}

final class ScenePropTransaction extends PropTransaction {
  ScenePropTransaction(this.scene);

  final Scene scene;
  SceneTransaction? _transaction;
  var _txnCount = 0;

  @override
  void onStartChanging() {
    if (_txnCount == 0) {
      _transaction = scene.beginTransaction();
    }

    _txnCount++;
  }

  @override
  void onEndChanging() {
    _txnCount--;

    if (_txnCount == 0) {
      _transaction?.commit();
      _transaction = null;
    }
  }

  void editScene(void Function(SceneTransaction) fn) {
    if (_txnCount == 0) {
      scene.editTransient(fn);
    } else {
      fn(_transaction!);
      _transaction!.flush();
    }
  }

  @override
  void dispose() {
    _transaction?.commit();
    _transaction = null;
  }
}
