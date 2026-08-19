part of 'prop.dart';

extension StatementProps on Statement {
  Iterable<Prop> get props => switch (this) {
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
  Iterable<Prop> get props sync* {
    yield PositionProp(
      (txn) => TransformSession.statement(txn.scene, id, transaction: txn),
      (scene) => .from(scene.statement<VertexStatement>(id).position),
    );
  }
}

extension EdgeStatementProps on EdgeStatement {
  Iterable<Prop> get props sync* {
    yield EdgeStyleProp(
      (scene) => .from(scene.statement<EdgeStatement>(id).style),
      (txn, value) => txn.update(id, partial(style: value)),
    );
  }
}

extension FaceStatementProps on FaceStatement {
  Iterable<Prop> get props sync* {
    yield FaceStyleProp(
      (scene) => .from(scene.statement<FaceStatement>(id).style),
      (txn, value) => txn.update(id, partial(style: value)),
    );
  }
}

extension ShapeStatementProps on ShapeStatement {
  Iterable<Prop> get props sync* {
    yield TransformProp(
      (txn) => TransformSession.statement(txn.scene, id, transaction: txn),
      (scene) => scene.statement<ShapeStatement>(id).transform,
    );

    yield LayoutSizeProp(
      id,
      (scene) => .from(scene.statement<ShapeStatement>(id).size),
      (txn, value) => txn.update(id, partial(size: value)),
    );

    yield FaceStyleProp(
      (scene) => scene.statement<ShapeStatement>(id).resolvedFaceStyle(scene),
      (txn, value) => txn.update(id, partial(faceStyle: value)),
    );

    yield EdgeStyleProp(
      (scene) => scene.statement<ShapeStatement>(id).resolvedEdgeStyle(scene),
      (txn, value) => txn.update(id, partial(edgeStyle: value)),
    );
  }
}

extension ContainerStatementProps on ContainerStatement {
  Iterable<Prop> get props sync* {
    yield* (this as ShapeStatement).props;

    yield ChildLayoutProp(
      (scene) => scene.statement<ContainerStatement>(id).childLayout,
      (txn, value) => txn.update(id, partial(childLayout: value)),
    );
  }
}

extension CutEdgeStatementProps on CutEdgeStatement {
  Iterable<Prop> get props sync* {
    yield CutTProp(
      (scene) => scene.statement<CutEdgeStatement>(id).t,
      (txn, value) => txn.update(id, partial(t: value)),
    );
  }
}
