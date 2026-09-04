part of 'program.dart';

sealed class Selector<T>() {
  static CellSelector<H> cell<H extends CellHandle>(
    CellKey<H> key,
  ) => CellSelector(key);

  static IncidentEdgeSelector incidentEdge(
    EdgeKey edge, {
    required CellSelector<VertexHandle> vertex,
  }) => IncidentEdgeSelector(edge, vertex: vertex);

  static BoundarySelector boundary(
    List<EdgeKey> edges,
  ) => BoundarySelector(edges);

  static ProductsSelector<H> products<H extends CellHandle>(
    StatementId id, [
    CellKind? kind,
  ]) => ProductsSelector(id, kind);

  T resolve(EvalContext context);

  Selector<T> rebase(RebaseContext context) {
    final clone = copyWith();
    clone._rebase(context);
    return clone;
  }

  bool _rebase(RebaseContext context);
  Iterable<StatementId> get references;
  Selector<T> copyWith();

  Iterable<CellKey> get keys;
}

typedef FrameSelector = Selector<FrameHandle>;
typedef VertexSelector = Selector<VertexHandle>;
typedef EdgeSelector = Selector<EdgeHandle>;
typedef FaceSelector = Selector<FaceHandle>;

final class CellSelector<H extends CellHandle> extends Selector<H> {
  CellSelector(this._key);

  CellKey<H> _key;
  CellKey<H> get key => _key;

  @override
  H resolve(EvalContext context) => context.handle(key);

  @override
  bool _rebase(RebaseContext context) {
    if (!context.affects(key)) return false;
    final same = context.descendantsOf(key).where((k) => k.kind == key.kind).toList();
    if (same.length == 1) {
      if (_key == same.single) return false;
      _key = same.single as CellKey<H>;
      return true;
    }
    throw RebaseRefused('cell $key became ambiguous (${same.length} candidates)');
  }

  @override
  Iterable<StatementId> get references => [?key.creator];

  @override
  CellSelector<H> copyWith({CellKey<H>? key}) => .new(key ?? _key);

  @override
  Iterable<CellKey> get keys => [key];
}

final class IncidentEdgeSelector extends EdgeSelector {
  IncidentEdgeSelector(this._edge, {required this._vertex});

  EdgeKey _edge;
  EdgeKey get edge => _edge;
  final CellSelector<VertexHandle> _vertex;
  CellSelector<VertexHandle> get vertex => _vertex;

  @override
  EdgeHandle resolve(EvalContext context) => context.handle(edge);

  @override
  bool _rebase(RebaseContext context) {
    final vertexChanged = _vertex._rebase(context);
    if (!context.affects(edge)) return vertexChanged;

    final bundle = context.bundle;

    final at = bundle.handle(vertex.key);
    final hits = context.descendantsOf(edge).where((k) => k.kind == .edge);
    final adjacent = hits.where((h) => bundle.edgeVertices(bundle.handle(h)!).contains(at));
    if (adjacent.length == 1) {
      if (_edge == adjacent.single) return vertexChanged;
      _edge = adjacent.single as EdgeKey;
      return true;
    }

    throw RebaseRefused('edge $edge became ambiguous (${adjacent.length} candidates)');
  }

  @override
  Iterable<StatementId> get references => [?edge.creator, ...vertex.references];

  @override
  IncidentEdgeSelector copyWith({EdgeKey? edge, CellSelector<VertexHandle>? vertex}) =>
      .new(edge ?? _edge, vertex: vertex ?? _vertex);

  @override
  Iterable<CellKey> get keys => [edge, ...vertex.keys];
}

final class BoundarySelector extends Selector<List<EdgeHandle>> {
  BoundarySelector(this._edges);

  List<EdgeKey> _edges;
  List<EdgeKey> get edges => _edges;

  @override
  List<EdgeHandle> resolve(EvalContext context) => [for (final e in edges) context.handle(e)];

  @override
  bool _rebase(RebaseContext context) {
    if (!edges.any(context.affects)) return false;
    final out = <EdgeKey>[];

    for (final e in _edges) {
      if (!context.affects(e)) {
        out.add(e);
        continue;
      }

      for (final k in context.descendantsOf(e)) {
        final _ = switch (k.kind) {
          .edge => out.add(k.asEdge),
          .vertex => null,
          .face || .frame => throw RebaseRefused('edge $e became ambiguous (descendant $k is not an edge)'),
        };
      }
    }

    if (_edges.length == out.length) {
      if (ListEquality().equals(_edges, out)) return false;
    }

    _edges = out;
    return true;
  }

  @override
  Iterable<StatementId> get references => [for (final e in edges) ?e.creator];

  @override
  BoundarySelector copyWith({List<EdgeKey>? edges}) => .new(edges ?? _edges);

  @override
  Iterable<CellKey> get keys => edges;
}

final class ProductsSelector<H extends CellHandle> extends Selector<List<H>> {
  ProductsSelector(this.id, [this.kind]);

  final StatementId id;
  final CellKind? kind;

  @override
  List<H> resolve(EvalContext context) {
    final out = <H>{};
    for (final k in context.statement(id).products(context)) {
      if (kind != null && k.kind != kind) continue;
      for (final d in context.lineage.descendantsOf(k)) {
        final handle = context.maybeHandle<H>(d);
        if (handle != null) out.add(handle);
      }
    }
    return out.toList();
  }

  @override
  bool _rebase(RebaseContext context) => false;

  @override
  Iterable<StatementId> get references => [id];

  @override
  ProductsSelector<H> copyWith({StatementId? id, CellKind? kind}) => .new(id ?? this.id, kind ?? this.kind);

  @override
  Iterable<CellKey> get keys => [];
}

extension CellExtension<H extends CellHandle> on CellKey<H> {
  CellSelector<H> selector() => CellSelector(this);
}
