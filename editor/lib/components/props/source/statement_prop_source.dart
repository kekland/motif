import 'package:editor/imports.dart';

extension StatementProps on Statement {
  Iterable<PropSource> resolveProps(Scene scene) => switch (this) {
    VertexStatement s => _vertexStatementProps(scene, s),
    EdgeStatement s => _edgeStatementProps(scene, s),
    FaceStatement s => _faceStatementProps(scene, s),
    ContainerStatement s => _containerStatementProps(scene, s),
    ShapeStatement s => _shapeStatementProps(scene, s),
    TextStatement s => _textStatementProps(scene, s),
    LayoutBoxStatement s => _layoutBoxStatementProps(scene, s),
    _ => [],
  };
}

StringProp resolveStatementNameProp(BuildContext context, Scene scene, Statement s) {
  return .new(
    [
      PropKind.string.of<Statement>(
        s.id,
        scene: scene,
        get: (scene, s) => s.name ?? s.resolveName(context),
        set: (scene, s, value) => s.copyWith(name: value.isNotEmpty ? value : null),
      ),
    ],
    label: 'Name',
    tooltip: .new('Statement name'),
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
    set: (scene, s, value) => s.copyWith(style: value),
  );
}

Iterable<PropSource> _faceStatementProps(Scene scene, FaceStatement s) sync* {
  yield PropKind.faceStyle.statement<FaceStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.style,
    set: (scene, s, value) => s.copyWith(style: value),
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

Iterable<PropSource> _shapeStatementProps(Scene scene, ShapeStatement s) sync* {
  yield* _layoutBoxStatementProps(scene, s);

  yield PropKind.faceStyle.statement<ShapeStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.faceStyle,
    set: (scene, s, value) => s.copyWith(faceStyle: value),
  );

  yield PropKind.edgeStyle.statement<ShapeStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.edgeStyle,
    set: (scene, s, value) => s.copyWith(edgeStyle: value),
  );
}

Iterable<PropSource> _containerStatementProps(Scene scene, ContainerStatement s) sync* {
  yield* _shapeStatementProps(scene, s);

  yield PropKind.layout.of<ContainerStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.layout,
    set: (scene, s, value) => s.copyWith(layout: value),
  );
}

Iterable<PropSource> _textStatementProps(Scene scene, TextStatement s) sync* {
  yield* _layoutBoxStatementProps(scene, s);

  yield PropKind.textFormat.statement<TextStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.textFormat,
    set: (scene, s, value) => s.copyWith(textFormat: value),
  );

  yield PropKind.paragraphFormat.statement<TextStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.paragraphFormat,
    set: (scene, s, value) => s.copyWith(paragraphFormat: value),
  );

  yield PropKind.faceStyle.statement<TextStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.faceStyle,
    set: (scene, s, value) => s.copyWith(faceStyle: value),
  );

  yield PropKind.edgeStyle.statement<TextStatement>(
    s.id,
    scene: scene,
    get: (scene, s) => s.edgeStyle,
    set: (scene, s, value) => s.copyWith(edgeStyle: value),
  );
}
