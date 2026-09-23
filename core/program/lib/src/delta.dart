part of '_program.dart';

final class ProgramDelta {
  ProgramDelta(this.changes);
  ProgramDelta.single(ProgramChange change) : this([change]);
  ProgramDelta.empty() : this([]);

  factory decode(gen.ProgramDelta program) => ProgramCodec.decodeProgramDelta(program);
  static ProgramDelta? decodeRaw(Uint8List data) => ProgramCodec.decodeRaw(() => .decode(.fromBuffer(data)));

  factory coalesced(Iterable<ProgramDelta> deltas) {
    final out = <ProgramChange>[];
    for (final d in deltas) {
      for (final op in d.changes) _fold(out, op);
    }
    return ProgramDelta(out);
  }

  final List<ProgramChange> changes;
  bool get isEmpty => changes.isEmpty;

  void reapply(Evaluation evaluation) {
    final pass = evaluation.beginPass();
    for (final op in changes) op.reapply(pass);
    pass.drain();
  }

  void unapply(Evaluation evaluation) {
    final pass = evaluation.beginPass();
    for (final op in changes.reversed) op.unapply(pass);
    pass.drain();
  }

  ProgramDelta coalesce(ProgramDelta next) {
    final out = [...changes];
    for (final nextOp in next.changes) _fold(out, nextOp);
    return .new(out);
  }

  ProgramDelta invert() => .new(changes.reversed.map((c) => c.invert()).toList());

  static void _fold(List<ProgramChange> changes, ProgramChange c) {
    if (c.isEmpty) return;

    for (var i = changes.length - 1; i >= 0; i--) {
      final merged = changes[i].coalesce(c);
      if (merged != null) {
        if (merged.isEmpty) {
          changes.removeAt(i);
        } else {
          changes[i] = merged;
        }
        return;
      }
      if (!changes[i].commutesWith(c)) break;
    }

    changes.add(c);
  }
}
