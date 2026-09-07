part of '../program.dart';

final class ParentSelector(super.ref) extends CellSelector<FrameHandle> {
  @override
  ParentSelector clone() => .new(ref);

  static ParentSelector? of(CellRef<FrameHandle>? ref) {
    if (ref == null) return null;
    return .new(ref);
  }

  @override
  int get hashCode => Object.hash(runtimeType, ref.hashCode);

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType && (other as ParentSelector).ref == ref;
}
