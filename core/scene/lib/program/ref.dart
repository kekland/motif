part of 'program.dart';

typedef _RefData = (StatementId statement, Symbol product);

/// A reference to a statement's product, which will resolve to [H].
///
/// See subclasses for specific product types, e.g. [FrameRef], [VertexRef], etc.
extension type Ref<H extends CellHandle>._(_RefData _v) implements Object {
  Ref(StatementId statement, Symbol product) : _v = (statement, product);

  StatementId get statement => _v.$1;
  Symbol get product => _v.$2;

  Ref<C> cast<C extends CellHandle>() => Ref<C>(statement, product);
}

typedef FrameRef = Ref<FrameHandle>;
typedef VertexRef = Ref<VertexHandle>;
typedef EdgeRef = Ref<EdgeHandle>;
typedef FaceRef = Ref<FaceHandle>;
