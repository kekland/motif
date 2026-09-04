part of 'program.dart';

final class ProgramDelta {
  ProgramDelta(this.ops);
  ProgramDelta.single(ProgramOp op) : this([op]);

  final List<ProgramOp> ops;
  bool get isEmpty => ops.isEmpty;

  void reapply(Program program) {
    for (final op in ops) op.reapply(program);
  }

  void unapply(Program program) {
    for (final op in ops.reversed) op.unapply(program);
  }

  ProgramDelta coalesce(ProgramDelta next) {
    final out = [...ops];
    for (final nextOp in next.ops) _fold(out, nextOp);
    return .new(out);
  }

  ProgramDelta invert() => .new(ops.reversed.map((op) => op.invert()).toList());

  static void _fold(List<ProgramOp> ops, ProgramOp op) {
    if (op.isEmpty) return;

    for (var i = ops.length - 1; i >= 0; i--) {
      final merged = ops[i].coalesce(op);
      if (merged != null) {
        if (merged.isEmpty) {
          ops.removeAt(i);
        } else {
          ops[i] = merged;
        }
        return;
      }
      if (!ops[i].commutesWith(op)) break;
    }

    ops.add(op);
  }
}
