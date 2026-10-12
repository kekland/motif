part of '../../_program.dart';

typedef GeneratedStatement = (StatementId? source, Statement statement);

mixin GeneratingStatement on Statement {
  Iterable<GeneratedStatement> generate(EvalContext context);

  GeneratingStatement? absorbChildUpdate(EvalContext context, List<StatementId> path, StatementPartial update);
}

extension type const GeneratorOverrides([Map<StatementId, GeneratorOverrideNode> children = const {}])
    implements Map<StatementId, GeneratorOverrideNode> {
  factory GeneratorOverrides.at(List<StatementId> path, StatementPartial partial) {
    var node = GeneratorOverrideNode(partial: partial);
    for (var i = path.length - 1; i > 0; i--) {
      node = .new(children: .new({path[i]: node}));
    }
    return .new({path.first: node});
  }

  static GeneratorOverrides merged(GeneratorOverrides inner, GeneratorOverrides outer) {
    final result = <StatementId, GeneratorOverrideNode>{...inner};
    for (final o in outer.entries) {
      if (result.containsKey(o.key)) {
        result[o.key] = result[o.key]!.merge(o.value);
      } else {
        result[o.key] = o.value;
      }
    }
    return .new(result);
  }
}

final class const GeneratorOverrideNode({
  final StatementPartial? partial,
  final GeneratorOverrides children = const .new(),
}) {
  GeneratorOverrideNode merge(GeneratorOverrideNode outer) => .new(
    partial: .merged([?partial, ?outer.partial]),
    children: .merged(children, outer.children),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GeneratorOverrideNode) return false;
    return other.partial == partial && mapEquals(other.children, children);
  }

  @override
  int get hashCode => Object.hash(partial, mapHash(children));
}
