part of 'program.dart';

/// A name of a product in a statement.
extension type const Name(String value) implements Object {
  Name.scoped(Scope? scope, String name) : this(scope != null ? '${scope.value}/$name' : name);
}

typedef _RefData = (StatementId statement, Name product, CellKind kind);

/// A reference to a product in a statement.
extension type const Ref<H extends CellHandle>._(_RefData _) implements Object {
  const Ref(StatementId statement, Name product, CellKind kind) : _ = (statement, product, kind);

  Ref.of(Statement s, String product, CellKind kind) : _ = (s.id, .scoped(s.scope, product), kind);

  static VertexRef vertex(Statement statement, String product) => .of(statement, product, .vertex);
  static EdgeRef edge(Statement statement, String product) => .of(statement, product, .edge);
  static FaceRef face(Statement statement, String product) => .of(statement, product, .face);
  static FrameRef frame(Statement statement, String product) => .of(statement, product, .frame);

  StatementId get statement => _.$1;
  Name get product => _.$2;
  CellKind get kind => _.$3;

  CellId get cellId => CellId('s${statement.value}/${product.value}');
}

typedef FrameRef = Ref<FrameHandle>;
typedef VertexRef = Ref<VertexHandle>;
typedef EdgeRef = Ref<EdgeHandle>;
typedef FaceRef = Ref<FaceHandle>;

/// A remap function for references
typedef Remap = Ref Function(Ref ref);
typedef RefMap = Map<Ref, Ref>;
