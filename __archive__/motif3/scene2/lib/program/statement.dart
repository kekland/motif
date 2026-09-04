part of 'program.dart';

extension type const StatementId._(String value) {
  const StatementId(String value) : this._(value);
  StatementId.generate() : this._('TODO');
}

extension type const Scope._(String value) {
  const Scope(String value) : this._(value);
  factory Scope.sub(Scope? parent, Scope child) => parent == null ? child : parent.child(child.value);

  Scope child(String next) => Scope('$value/$next');
}

/// A base unit of a program.
sealed class Statement {
  Statement({
    StatementId? id,
    this.scope,
  }) : id = id ?? .generate();

  // dart format off
  factory Statement.frame({StatementId? id, Scope? scope, Mat4? transform, FrameRef? parent}) = FrameStatement;
  factory Statement.vertex(Vec2 position, {StatementId? id, Scope? scope, VertexStyle style, FrameRef? parent}) = VertexStatement;
  factory Statement.edge(VertexRef start, VertexRef end, {Vec2? startTangent, Vec2? endTangent, EdgeStyle style, StatementId? id, Scope? scope, FrameRef? parent}) = EdgeStatement;
  factory Statement.face(List<EdgeRef> edges, {List<List<EdgeRef>> holes, FaceStyle style, StatementId? id, Scope? scope, FrameRef? parent}) = FaceStatement;
  // dart format on

  final StatementId id;
  final Scope? scope;

  Iterable<Arg> get _args;
  Iterable<Arg> get args => _args;

  void execute(EvalContext context) {
    context.push(this);
    try {
      performExecute(context);
      context.autobind(this);
    } catch (e, st) {
      throw EvalFailure(id, scope, e, st);
    } finally {
      context.pop();
    }
  }

  void performExecute(EvalContext context);

  Statement copyWith({StatementId? id, Scope? scope});

  /// Copies this statement, remapping all references using the provided [remapper].
  ///
  /// If nothing changes, returns the same instance.
  Statement copyWithRefs(Remap remapper, {StatementId? id}) {
    var touched = id != this.id;
    final s = copyWith(id: id);
    for (final arg in s.args) {
      if (arg._remap(remapper)) touched = true;
    }

    if (!touched) return this;
    return s;
  }
}

/// A statement that can have sub-statements.
sealed class CompositeStatement extends Statement {
  CompositeStatement({super.id, super.scope});

  Iterable<Statement> expand(EvalContext context) {
    var result = performExpand(context);
    assert(result.every((s) => s.scope != null), 'all sub-statements must be scoped');

    result = result.map((s) => s.copyWith(id: id, scope: .sub(scope, s.scope!)));
    return result;
  }

  Iterable<Statement> performExpand(EvalContext context);

  @override
  void performExecute(EvalContext context) {
    for (final child in expand(context)) child.execute(context);
  }
}
