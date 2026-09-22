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
  int get hashCode => Object.hash(runtimeType, ref.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is! ParentSelector) return false;
    if (other.runtimeType != runtimeType) return false;
    if (other.ref != ref) return false;
    return true;
  }
}
