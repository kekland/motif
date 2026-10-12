import 'package:editor/imports.dart';

extension StatementProps on Statement {
  Iterable<PropSource> resolveProps(Scene scene) sync* {
    yield* switch (this) {
      VertexStatement s => _vertexStatementProps(scene, s),
      EdgeStatement s => _edgeStatementProps(scene, s),
      FaceStatement s => _faceStatementProps(scene, s),
      ContainerStatement s => _containerStatementProps(scene, s),
      PrefabInstanceStatement s => _prefabInstanceStatementProps(scene, s),
      ShapeStatement s => _shapeStatementProps(scene, s),
      TextStatement s => _textStatementProps(scene, s),
      LayoutBoxStatement s => _layoutBoxStatementProps(scene, s),
      _ => [],
    };

    yield* _statementProps(scene, this);
  }
}

StringProp resolveStatementNameProp(BuildContext context, Scene scene, StatementId id) {
  return .new(
    [
      PropKind.string.of<Statement>(
        id,
        scene: scene,
        get: (scene, s) => s.name ?? s.resolveName(context),
        set: (scene, value) => .name(value),
      ),
    ],
    label: 'Name',
    tooltip: .new('Statement name'),
  );
}

Iterable<PropSource> _statementProps(Scene scene, Statement s) sync* {
  yield PropKind.modifierStack.of<Statement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.resolveModifiers(scene.evaluation.contextFor(s.id)),
    set: (scene, value) => .modifiers(value),
  );
}

Iterable<PropSource> _vertexStatementProps(Scene scene, VertexStatement s) sync* {
  yield PropKind.position.statementTransforming<VertexStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.position,
    execute: (session, v, p) => session.setTranslation(p.apply(v)),
    override: (scene, s) => .from(scene.layoutOf(s.id)?.offset),
  );
}

Iterable<PropSource> _edgeStatementProps(Scene scene, EdgeStatement s) sync* {
  yield PropKind.edgeStyle.statement<EdgeStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.style,
    set: (scene, value) => .edgeStyle(value),
  );
}

Iterable<PropSource> _faceStatementProps(Scene scene, FaceStatement s) sync* {
  yield PropKind.faceStyle.statement<FaceStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.style,
    set: (scene, value) => .faceStyle(value),
  );
}

Iterable<PropSource> _layoutBoxStatementProps(Scene scene, LayoutBoxStatement s) sync* {
  yield PropKind.transform.statementTransforming<LayoutBoxStatement>(
    s.id,
    scene: scene,
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
    s.id,
    scene: scene,
    get: (scene, s) => s.resolveSize(scene.evaluation.contextFor(s.id)),
    set: (scene, value) => .layoutSize(value),
    override: (scene, s) {
      final layout = scene.layoutOf(s.id);
      if (layout == null) return null;

      final size = s.resolveSize(scene.evaluation.contextFor(s.id));
      return .new(
        width: !size.width.isFixed ? .new(layout.size.width, size.width.type, size.width.range) : null,
        height: !size.height.isFixed ? .new(layout.size.height, size.height.type, size.height.range) : null,
      );
    },
  );
}

Iterable<PropSource> _shapeStatementProps(Scene scene, ShapeStatement s) sync* {
  yield* _layoutBoxStatementProps(scene, s);

  yield PropKind.faceStyle.statement<ShapeStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.faceStyle,
    set: (scene, value) => .faceStyle(value),
  );

  yield PropKind.edgeStyle.statement<ShapeStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.edgeStyle,
    set: (scene, value) => .edgeStyle(value),
  );
}

Iterable<PropSource> _containerStatementProps(Scene scene, ContainerStatement s) sync* {
  yield* _shapeStatementProps(scene, s);

  yield PropKind.layout.statement<ContainerStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.layout,
    set: (scene, value) => .layout(value),
  );
}

Iterable<PropSource> _textStatementProps(Scene scene, TextStatement s) sync* {
  yield* _layoutBoxStatementProps(scene, s);

  yield PropKind.textFormat.statement<TextStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.textFormat,
    set: (scene, value) => .textFormat(value),
  );

  yield PropKind.paragraphFormat.statement<TextStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.paragraphFormat,
    set: (scene, value) => .paragraphFormat(value),
  );

  yield PropKind.faceStyle.statement<TextStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.faceStyle,
    set: (scene, value) => .faceStyle(value),
  );

  yield PropKind.edgeStyle.statement<TextStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.edgeStyle,
    set: (scene, value) => .edgeStyle(value),
  );
}

Iterable<PropSource> _prefabInstanceStatementProps(Scene scene, PrefabInstanceStatement s) sync* {
  yield* _layoutBoxStatementProps(scene, s);

  // yield PropKind.vertexStyle.statement<PrefabInstanceStatement>(
  //   s.id,
  //   scene: scene,
  //   get: (scene, s) => s.vertexStyle,
  //   set: (scene, value) => .vertexStyle(value),
  // );

  yield PropKind.faceStyle.statement<PrefabInstanceStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.resolveFaceStyle(scene.evaluation.contextFor(s.id)),
    set: (scene, value) => .faceStyle(value),
  );

  yield PropKind.edgeStyle.statement<PrefabInstanceStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.resolveEdgeStyle(scene.evaluation.contextFor(s.id)),
    set: (scene, value) => .edgeStyle(value),
  );

  yield PropKind.layout.statement<PrefabInstanceStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.resolveLayout(scene.evaluation.contextFor(s.id)),
    set: (scene, value) => .layout(value),
  );
}
