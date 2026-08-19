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
    yield PropType.position.transforming(
      (txn) => TransformSession.statement(txn.scene, id, transaction: txn),
      (scene) => .from(scene.statement<VertexStatement>(id).position),
      (session, current, value) => session.setTranslation(value.apply(current.value)),
    );
  }
}

extension EdgeStatementProps on EdgeStatement {
  Iterable<PropSource> get props sync* {
    yield PropType.edgeStyle.delegating(
      (scene) => .from(scene.statement<EdgeStatement>(id).style),
      (txn, value) => txn.update(id, partial(style: value)),
    );
  }
}

extension FaceStatementProps on FaceStatement {
  Iterable<PropSource> get props sync* {
    yield PropType.faceStyle.delegating(
      (scene) => .from(scene.statement<FaceStatement>(id).style),
      (txn, value) => txn.update(id, partial(style: value)),
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

    yield PropType.layoutSize.delegating(
      (scene) => .new(scene.statement<ShapeStatement>(id).size, scene.layout.of(id)?.size),
      (txn, value) => txn.update(id, partial(size: value)),
    );

    yield PropType.faceStyle.delegating(
      (scene) => scene.statement<ShapeStatement>(id).resolvedFaceStyle(scene),
      (txn, value) => txn.update(id, partial(faceStyle: value)),
    );

    yield PropType.edgeStyle.delegating(
      (scene) => scene.statement<ShapeStatement>(id).resolvedEdgeStyle(scene),
      (txn, value) => txn.update(id, partial(edgeStyle: value)),
    );
  }
}

extension ContainerStatementProps on ContainerStatement {
  Iterable<PropSource> get props sync* {
    yield* (this as ShapeStatement).props;

    yield PropType.childLayout.delegating(
      (scene) => scene.statement<ContainerStatement>(id).childLayout,
      (txn, value) => txn.update(id, partial(childLayout: value)),
    );
  }
}

extension CutEdgeStatementProps on CutEdgeStatement {
  Iterable<PropSource> get props sync* {
    yield PropType.cutT.delegating(
      (scene) => scene.statement<CutEdgeStatement>(id).t,
      (txn, value) => txn.update(id, partial(t: value)),
    );
  }
}
