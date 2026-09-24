part of '../_program.dart';

final class ParentSelector(super.ref) extends CellSelector<FrameHandle> {
  @override
  ParentSelector clone() => .new(ref);

  static ParentSelector? of(CellRef<FrameHandle>? ref) {
    if (ref == null) return null;
    if (ref.namespace.isZero) return null;
    return .new(ref);
  }

  @override
  RemapResult _remap(Remap remap) {
    final cells = remap.cell(_ref);
    if (cells == null) return .unchanged;

    if (cells.isEmpty) {
      if (_ref == .root) return .unchanged;
      _ref = .root;
      return .changed;
    } else if (cells.length == 1) {
      if (_ref == cells.single) return .unchanged;
      _ref = cells.single.asFrame;
      return .changed;
    }

    return .refused;
  }

  @override
  int get hashCode => Object.hash(runtimeType, ref.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is! ParentSelector) return false;
    if (other.runtimeType != runtimeType) return false;
    if (other.ref != ref) return false;
    return true;
  }
}
