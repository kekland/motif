part of 'prop.dart';

final class PropTransaction {
  PropTransaction(this.scene);

  final Scene scene;
  SceneTransaction? _transaction;

  late final InputSessionCallbacks sessionCallbacks = .new(
    onStartEditing: onStartChanging,
    onEndEditing: onEndChanging,
  );

  void onStartChanging() {
    if (_transaction != null) throw StateError('Transaction already started');
    _transaction = scene.beginTransaction();
  }

  void onEndChanging() {
    _transaction?.commit();
    _transaction = null;
  }

  void edit(void Function(SceneTransaction) fn) {
    final isOneOff = _transaction == null;

    if (isOneOff) {
      scene.editTransient(fn);
    } else {
      fn(_transaction!);
      _transaction!.flush();
    }
  }

  void dispose() {
    _transaction?.commit();
    _transaction = null;
  }
}
