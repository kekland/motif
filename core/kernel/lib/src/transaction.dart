part of 'kernel.dart';

class TopologyTransaction {
  TopologyTransaction(this.bundle) : _history = null {
    bundle._lockTransaction();
  }

  TopologyTransaction._history(this.bundle, this._history) {
    bundle._lockTransaction();
  }

  final TopologyBundle bundle;
  final TopologyHistory? _history;

  final delta = TopologyDelta();
  final ops = <TopologyOp>[];

  var _committed = false;
  void _checkOpen() {
    if (_committed) throw StateError('transaction has already been committed');
  }

  String _createTag(String prefix) => '$prefix${bundle._opCounter++}';

  TopologyDelta commit() {
    _checkOpen();
    _committed = true;
    bundle._endTransaction();
    bundle._version++;

    if (_history != null) _history._onCommit(this, delta);
    return delta;
  }

  void abort() {
    _checkOpen();
    final applied = ops.toList();
    for (final op in applied.reversed) op.unapply(this);
    _committed = true;
    bundle._endTransaction();
  }
}
