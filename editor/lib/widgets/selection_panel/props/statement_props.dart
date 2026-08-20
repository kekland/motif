part of 'prop.dart';

extension StatementProps on Statement {
  Iterable<PropSource> get props => switch (this) {
    VertexStatement s => s.props,
    EdgeStatement s => s.props,
    FaceStatement s => s.props,
    ContainerStatement s => s.props,
    ShapeStatement s => s.props,
    CutEdgeStatement s => s.props,
    _ => [],
  };
}

extension VertexStatementProps on VertexStatement {
  Iterable<PropSource> get props sync* {
    yield PropType.position.transformingOf<VertexStatement>(
      id,
      get: (scene, s) => .new(s.position, overridden: scene.layout.of(id)?.offset),
      execute: (session, value) => session.setTranslation(value.resolved),
    );
  }
}

extension EdgeStatementProps on EdgeStatement {
  Iterable<PropSource> get props sync* {
    yield PropType.edgeStyle.of<EdgeStatement>(
      id,
      get: (scene, s) => .from(s.style),
      set: (scene, s, value) => s.copyWith(style: value.apply(s.style)),
    );
  }
}

extension FaceStatementProps on FaceStatement {
  Iterable<PropSource> get props sync* {
    yield PropType.faceStyle.of<FaceStatement>(
      id,
      get: (scene, s) => .from(s.style),
      set: (scene, s, value) => s.copyWith(style: value.apply(s.style)),
    );
  }
}

extension ShapeStatementProps on ShapeStatement {
  Iterable<PropSource> get props sync* {
    yield PropType.transform.transforming(
      (txn) => TransformSession.statement(txn.scene, id, transaction: txn),
      (scene) => .from(scene.statement<ShapeStatement>(id).transform, translationOverride: scene.layout.of(id)?.offset),
      (session, current, value) => value.execute(session, current),
    );

    yield PropType.layoutSize.of<ShapeStatement>(
      id,
      get: (scene, s) => .new(s.size, overridden: scene.layout.of(id)?.size),
      set: (scene, s, value) => s.copyWith(size: value.size),
    );

    yield PropType.faceStyle.of<ShapeStatement>(
      id,
      get: (scene, s) => s.resolvedFaceStyle(scene),
      set: (scene, s, value) => s.copyWith(faceStyle: value.apply(s.faceStyle)),
    );

    yield PropType.edgeStyle.of<ShapeStatement>(
      id,
      get: (scene, s) => s.resolvedEdgeStyle(scene),
      set: (scene, s, value) => s.copyWith(edgeStyle: value.apply(s.edgeStyle)),
    );
  }
}

extension ContainerStatementProps on ContainerStatement {
  Iterable<PropSource> get props sync* {
    yield* (this as ShapeStatement).props;

    yield PropType.childLayout.of<ContainerStatement>(
      id,
      get: (scene, s) => s.childLayout,
      set: (scene, s, value) => s.copyWith(childLayout: value),
    );
  }
}

extension CutEdgeStatementProps on CutEdgeStatement {
  Iterable<PropSource> get props sync* {
    yield PropType.cutT.of<CutEdgeStatement>(
      id,
      get: (scene, s) => s.t,
      set: (scene, s, value) => s.copyWith(t: value),
    );
  }
}
