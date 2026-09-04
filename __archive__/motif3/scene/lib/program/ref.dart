part of 'program.dart';

typedef _RefData = (StatementId statement, Symbol product, CellKind kind);

/// A reference to a statement's product, which will resolve to [H].
///
/// See subclasses for specific product types, e.g. [FrameRef], [VertexRef], etc.
extension type Ref<H extends CellHandle>._(_RefData _v) implements Object {
  Ref(StatementId statement, Symbol product, CellKind kind) : _v = (statement, product, kind);

  static VertexRef vertex(StatementId statement, Symbol product) => Ref(statement, product, .vertex);
  static EdgeRef edge(StatementId statement, Symbol product) => Ref(statement, product, .edge);
  static FaceRef face(StatementId statement, Symbol product) => Ref(statement, product, .face);
  static FrameRef frame(StatementId statement, Symbol product) => Ref(statement, product, .frame);

  StatementId get statement => _v.$1;
  Symbol get product => _v.$2;
  CellKind get kind => _v.$3;

  Ref<H> copyWith({
    StatementId? statement,
    Symbol? product,
    CellKind? kind,
  }) => .new(
    statement ?? this.statement,
    product ?? this.product,
    kind ?? this.kind,
  );

  Ref<C> cast<C extends CellHandle>() => Ref<C>(statement, product, kind);
}

typedef FrameRef = Ref<FrameHandle>;
typedef VertexRef = Ref<VertexHandle>;
typedef EdgeRef = Ref<EdgeHandle>;
typedef FaceRef = Ref<FaceHandle>;

extension RefIterableExt on Iterable<Ref> {
  Iterable<FrameRef> get frames => where((r) => r.kind == .frame).cast<FrameRef>();
  Iterable<VertexRef> get vertices => where((r) => r.kind == .vertex).cast<VertexRef>();
  Iterable<EdgeRef> get edges => where((r) => r.kind == .edge).cast<EdgeRef>();
  Iterable<FaceRef> get faces => where((r) => r.kind == .face).cast<FaceRef>();
}
