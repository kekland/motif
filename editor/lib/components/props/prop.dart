import 'package:editor/imports.dart';

part 'prop_kind.dart';
part 'prop_transaction.dart';

/// A [Prop] is an abstract representation of an editable piece of multiple objects.
///
/// Type argument [G] represents the type that is extracted from the object, and [S] represents the type that is used
/// to modify the object (e.g. the same type, or a [Partial] type).
///
/// Prop values are obtained from [PropSource] instances.
abstract class Prop<G, S> {
  Prop(this.sources, {required this.kind});

  final List<PropSource<G, S>> sources;
  final PropKind<G, S> kind;

  bool compare(G a, G b) => a == b;

  bool isEverythingActive() => sources.every((s) => s.isActive());

  PropValue<G> resolve() {
    final active = sources.where((s) => s.isActive()).toList();
    final values = active.map((s) => s.get()).toList();
    if (values.isEmpty) return const .mixed();

    final first = values.first;
    for (final value in values.skip(1)) {
      if (!compare(first.resolve() as G, value.resolve() as G)) return const .mixed();
    }

    return first;
  }

  void set(PropTransaction txn, S value) {
    txn.onStartChanging();
    for (final source in sources) source.set(txn, value);
    txn.onEndChanging();
  }

  P remap<G2, S2, P extends Prop<G2, S2>>(
    PropKind<G2, S2> kind, {
    required G2 Function(G) getter,
    required S Function(G, S2) setter,
    S2? Function(S?)? override,
  }) => kind.factory(sources.remap(kind, getter: getter, setter: setter, override: override)) as P;

  PropWidget? buildWidget(BuildContext context) => null;
  Widget? buildHeaderButton(BuildContext context) => null;

  static List<Prop> union(Iterable<Iterable<PropSource>> group) {
    final propsByKind = <PropKind, List<PropSource>>{};
    for (final props in group) {
      for (final prop in props) {
        propsByKind.putIfAbsent(prop.kind, () => []).add(prop);
      }
    }

    final result = <Prop>[];
    for (final entry in propsByKind.entries) {
      result.add(entry.key.compose(entry.value));
    }

    return result;
  }

  static List<Prop> intersect(Iterable<Iterable<PropSource>> group) {
    final count = group.length;

    final propsByKind = <PropKind, List<PropSource>>{};
    for (final props in group) {
      for (final prop in props) {
        propsByKind.putIfAbsent(prop.kind, () => []).add(prop);
      }
    }

    final result = <Prop>[];
    for (final entry in propsByKind.entries) {
      final props = entry.value;
      if (props.length == count) {
        result.add(entry.key.compose(props));
      }
    }

    return result;
  }

  Iterable<Prop> get children => .empty();
  Iterable<Widget> buildHeaderButtons(BuildContext context) {
    final out = <Widget>[];

    final work = <Prop>[this];
    while (work.isNotEmpty) {
      final prop = work.removeLast();
      work.addAll(prop.children);

      final button = prop.buildHeaderButton(context);
      if (button != null) out.add(button);
    }

    return out;
  }
}

/// A [PropSource] is responsible for taking an object, and resolving its values.
final class PropSource<G, S> {
  PropSource({
    required this.kind,
    required this._getter,
    required this._setter,
    required this.signal,
    this._override,
    this._isActive,
  });

  final PropKind<G, S> kind;
  final G Function() _getter;
  final void Function(PropTransaction txn, S value) _setter;
  final S? Function()? _override;
  final bool Function()? _isActive;
  final Signal? signal;

  bool isActive() => _isActive?.call() ?? true;

  PropValue<G> get() {
    final value = _getter();
    final override = _override?.call();
    if (override != null) {
      return .uniform(resolveOverridden(value, override), isOverridden: true);
    }

    return .uniform(value);
  }

  void set(PropTransaction txn, S value) => _setter(txn, value);

  G resolveOverridden(G value, S override) {
    if (G == S) return override as G;
    if (S == Partial<G>) return (override as Partial<G>).apply(value);
    throw Exception('Cannot resolve overridden value: incompatible types.');
  }

  PropSource<G2, S2> map<G2, S2>(
    PropKind<G2, S2> kind, {
    required G2 Function(G) getter,
    required S Function(G, S2) setter,
    S2? Function(S?)? override,
  }) => .new(
    kind: kind,
    isActive: _isActive,
    getter: () => getter(_getter()),
    setter: (txn, value) => set(txn, setter(_getter(), value)),
    override: () => override?.call(_override?.call()),
    signal: signal,
  );
}

/// A [PropValue] is the resolved value obtained from multiple [PropSource]s.
sealed class const PropValue<T>() {
  const factory uniform(T value, {bool isOverridden}) = UniformPropValue<T>;
  const factory mixed() = MixedPropValue<T>;

  T? resolve() => switch (this) {
    UniformPropValue(:final value) => value,
    MixedPropValue() => null,
  };

  bool get isUniform => this is UniformPropValue<T>;
  bool get isOverridden => false;
  bool get isMixed => this is MixedPropValue<T>;
}

final class const UniformPropValue<T>(final T value, {@override final bool isOverridden = false}) extends PropValue<T>;
final class const MixedPropValue<T>() extends PropValue<T>;

/// Extension method to remap a list of [PropSource]s to a different type.
extension PropSourceIterableExt<G, S> on Iterable<PropSource<G, S>> {
  List<PropSource<G2, S2>> remap<G2, S2>(
    PropKind<G2, S2> kind, {
    required G2 Function(G) getter,
    required S Function(G, S2) setter,
    S2? Function(S?)? override,
  }) => map(
    (s) => s.map(
      kind,
      getter: getter,
      setter: setter,
      override: override,
    ),
  ).toList();
}

// ---------------------------------------------------------------------------------------------------------------------
// Source extensions
// ---------------------------------------------------------------------------------------------------------------------

PropSource<G, S> _sceneSource<G, S>(
  PropKind<G, S> kind,
  Scene scene, {
  required Signal signal,
  required bool Function(Scene) isActive,
  required G Function(Scene) get,
  required void Function(SceneTransaction, S) set,
  S? Function(Scene)? override,
}) {
  return .new(
    kind: kind,
    isActive: () => isActive(scene),
    getter: () => get(scene),
    setter: (txn, value) => (txn as ScenePropTransaction).editScene((txn) => set(txn, value)),
    override: override != null ? () => override(scene) : null,
    signal: signal,
  );
}

extension PartialStatementFieldProp<G, S extends Partial<G>> on PropKind<G, S> {
  PropSource<G, S> statement<T extends Statement>(
    StatementId id, {
    required Scene scene,
    required G Function(Scene, T) get,
    required T Function(Scene, T, G) set,
    S? Function(Scene, T)? override,
  }) {
    return _sceneSource(
      this,
      scene,
      isActive: (scene) => scene.statement(id) != null,
      get: (scene) => get(scene, scene.statement<T>(id)!),
      set: (txn, value) => txn.update<T>(id, (s) => set(scene, s, value.apply(get(scene, s)))),
      override: override != null ? (scene) => override(scene, scene.statement<T>(id)!) : null,
      signal: scene.notifier.forStatement(id),
    );
  }

  PropSource<G, S> statementTransforming<T extends Statement>(
    StatementId id, {
    required Scene scene,
    required G Function(Scene, T) get,
    required void Function(TransformSession, G, S) execute,
    S? Function(Scene, T)? override,
  }) {
    return _sceneSource(
      this,
      scene,
      isActive: (scene) => scene.statement(id) != null,
      get: (scene) => get(scene, scene.statement<T>(id)!),
      set: (txn, value) {
        final session = TransformSession.statements(scene, [id], transaction: txn);
        return execute(session, get(scene, scene.statement<T>(id)!), value);
      },
      override: override != null ? (scene) => override(scene, scene.statement<T>(id)!) : null,
      signal: scene.notifier.forStatement(id),
    );
  }
}

extension TotalStatementFieldProp<V> on PropKind<V, V> {
  PropSource<V, V> of<T extends Statement>(
    StatementId id, {
    required Scene scene,
    required V Function(Scene, T) get,
    required T Function(Scene, T, V) set,
    V? Function(Scene, T)? override,
  }) {
    return _sceneSource(
      this,
      scene,
      isActive: (scene) => scene.statement(id) != null,
      get: (scene) => get(scene, scene.statement<T>(id)!),
      set: (txn, value) => txn.update<T>(id, (s) => set(scene, s, value)),
      override: override != null ? (scene) => override(scene, scene.statement<T>(id)!) : null,
      signal: scene.notifier.forStatement(id),
    );
  }
}
