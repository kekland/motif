part of '../kernel.dart';

extension MutationUtils on Transaction {
  H _cell<H extends CellHandle>() {
    assert(mode == .geometry);
    return _record!._created[_sub++] as H;
  }

  H _addCell<H extends CellHandle>(
    Mutation Function(CellId) builder,
    H Function(CellId) getHandle,
  ) {
    final H handle;

    if (mode == .topology) {
      final mutation = builder(_id());
      handle = mutation.reapply(this) as H;
      _record!._created.add(handle);
      _recordMutation(mutation);
      markAdded(handle);
    } else {
      handle = _cell<H>();
    }

    return handle;
  }

  void _deleteCell<H extends CellHandle>(
    H h,
    Mutation mutation,
  ) {
    markDeleted(h);
    mutation.reapply(this);
    _recordMutation(mutation);
  }
}
