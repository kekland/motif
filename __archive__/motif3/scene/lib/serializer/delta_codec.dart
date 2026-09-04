part of 'serializer.dart';

pb.DeltaBatch encodeDeltaBatch(SceneDelta delta) {
  final out = <pb.Delta>[];

  void add(SceneDelta d) => switch (d) {
    CompositeSceneDelta c => c.deltas.forEach(add),
    ProgramSceneDelta p => out.addAll(_encodeProgramDelta(p.delta)),
    EmptySceneDelta() => null,
    _ => null,
  };

  add(delta);
  return pb.DeltaBatch(deltas: out);
}

Iterable<pb.Delta> _encodeProgramDelta(ProgramDelta delta) {
  return delta.ops.map(
    (op) => pb.Delta(
      program: pb.ProgramDelta(
        anchor: switch (op.anchor) {
          StartAnchor() => pb.Anchor(start: true),
          AfterAnchor(:final id) => pb.Anchor(after: _statementIdCodec.encode(id)),
          AtAnchor(:final id) => pb.Anchor(at: _statementIdCodec.encode(id)),
          EndAnchor() => pb.Anchor(end: true),
        },
        inserted: [for (final s in op.inserted) _statementCodec.encode(s)],
        removed: [for (final s in op.removed) _statementIdCodec.encode(s.id)],
      ),
    ),
  );
}

SceneDelta decodeDeltaBatch(pb.DeltaBatch batch, Scene scene) {
  return SceneDelta.coalesced([
    for (final delta in batch.deltas)
      switch (delta.whichDelta()) {
        pb.Delta_Delta.program => _decodeProgramDelta(delta.program, scene.program),
        _ => .empty(),
      },
  ]);
}

ProgramSceneDelta _decodeProgramDelta(pb.ProgramDelta delta, Program program) {
  return .new(
    ProgramDelta([
      ProgramOp(
        anchor: switch (delta.anchor.whichAnchor()) {
          pb.Anchor_Anchor.start => const Anchor.start(),
          pb.Anchor_Anchor.after => Anchor.after(_statementIdCodec.decode(delta.anchor.after)),
          pb.Anchor_Anchor.at => Anchor.at(_statementIdCodec.decode(delta.anchor.at)),
          _ => const Anchor.end(),
        },
        removed: [
          for (final id in delta.removed) ?program.byId(_statementIdCodec.decode(id)),
        ],
        inserted: [for (final s in delta.inserted) _statementCodec.decode(s)],
      ),
    ]),
  );
}
