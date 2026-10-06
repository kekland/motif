import 'package:editor/imports.dart';

extension StatementProps on Statement {
  Iterable<PropSource> get props => switch (this) {
    VertexStatement s => s.props,
    EdgeStatement s => s.props,
    FaceStatement s => s.props,
    ContainerStatement s => s.props,
    ShapeStatement s => s.props,
    TextStatement s => s.props,
    LayoutBoxStatement s => s.props,
    CutEdgeStatement s => s.props,
    _ => [],
  };
}

extension VertexStatementProps on VertexStatement {
  Iterable<PropSource> get props sync* {
    yield PropKind.position.statementTransforming<VertexStatement>(
      id,
      get: (scene, s) => s.position,
      execute: (session, v, p) => session.setTranslation(p.apply(v)),
      override: (scene, s) => .from(scene.layoutOf(s.id)?.offset),
    );
  }
}

extension EdgeStatementProps on EdgeStatement {
  Iterable<PropSource> get props sync* {
    yield PropKind.edgeStyle.statement<EdgeStatement>(
      id,
      get: (scene, s) => s.style,
      set: (scene, s, value) => s.copyWith(style: value),
    );
  }
}

extension FaceStatementProps on FaceStatement {
  Iterable<PropSource> get props sync* {
    yield PropKind.faceStyle.statement<FaceStatement>(
      id,
      get: (scene, s) => s.style,
      set: (scene, s, value) => s.copyWith(style: value),
    );
  }
}

extension LayoutBoxStatementProps on LayoutBoxStatement {
  Iterable<PropSource> get props sync* {
    yield PropKind.transform.statementTransforming<LayoutBoxStatement>(
      id,
      get: (scene, s) => .from(s.transform),
      execute: (session, v, p) => p.execute(session, v),
      override: (scene, s) {
        final layout = scene.layoutOf(s.id);
        if (layout == null) return null;
        if (layout.offset == null) return null;
        return .new(translation: .from(layout.offset), rotation: null);
      },
    );

    yield PropKind.layoutSize.statement<LayoutBoxStatement>(
      id,
      get: (scene, s) => s.size,
      set: (scene, s, value) => s.copyWith(size: value),
      override: (scene, s) {
        final layout = scene.layoutOf(s.id);
        if (layout == null) return null;

        return .new(
          width: !s.size.width.isFixed ? .new(layout.size.width, s.size.width.type, s.size.width.range) : null,
          height: !s.size.height.isFixed ? .new(layout.size.height, s.size.height.type, s.size.height.range) : null,
        );
      },
    );
  }
}

extension ShapeStatementProps on ShapeStatement {
  Iterable<PropSource> get props sync* {
    yield* (this as LayoutBoxStatement).props;

    yield PropKind.faceStyle.statement<ShapeStatement>(
      id,
      get: (scene, s) => s.faceStyle,
      set: (scene, s, value) => s.copyWith(faceStyle: value),
    );

    yield PropKind.edgeStyle.statement<ShapeStatement>(
      id,
      get: (scene, s) => s.edgeStyle,
      set: (scene, s, value) => s.copyWith(edgeStyle: value),
    );
  }
}

extension ContainerStatementProps on ContainerStatement {
  Iterable<PropSource> get props sync* {
    yield* (this as ShapeStatement).props;

    yield PropKind.layout.of<ContainerStatement>(
      id,
      get: (scene, s) => s.layout,
      set: (scene, s, value) => s.copyWith(layout: value),
    );
  }
}

extension TextStatementProps on TextStatement {
  Iterable<PropSource> get props sync* {
    yield* (this as LayoutBoxStatement).props;

    yield PropKind.textFormat.statement<TextStatement>(
      id,
      get: (scene, s) => s.textFormat,
      set: (scene, s, value) => s.copyWith(textFormat: value),
    );

    yield PropKind.paragraphFormat.statement<TextStatement>(
      id,
      get: (scene, s) => s.paragraphFormat,
      set: (scene, s, value) => s.copyWith(paragraphFormat: value),
    );

    yield PropKind.faceStyle.statement<TextStatement>(
      id,
      get: (scene, s) => s.faceStyle,
      set: (scene, s, value) => s.copyWith(faceStyle: value),
    );

    yield PropKind.edgeStyle.statement<TextStatement>(
      id,
      get: (scene, s) => s.edgeStyle,
      set: (scene, s, value) => s.copyWith(edgeStyle: value),
    );
  }
}
