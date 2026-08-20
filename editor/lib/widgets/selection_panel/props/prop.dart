import 'dart:math';

import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/widgets.dart';
import 'package:equatable/equatable.dart';

part 'partials.dart';
part 'prop_type.dart';
part 'props.dart';
part 'cell_props.dart';
part 'statement_props.dart';
part 'widgets/builder.dart';
part 'widgets/widgets.dart';

abstract class PropSource<G, S> {
  PropSource();

  PropType<G, S> get type;

  factory PropSource.delegating(
    PropType<G, S> type,
    G Function(Scene scene) getter,
    void Function(SceneTransaction txn, S value) setter,
  ) = DelegatedPropSource<G, S>;

  factory PropSource.transforming(
    PropType<G, S> type,
    TransformSession Function(SceneTransaction) session,
    G Function(Scene scene) getter,
    void Function(TransformSession session, G current, S value) setter,
  ) = TransformingPropSource<G, S>;

  G value(Scene scene);
  void set(SceneTransaction txn, S value);

  PropSource<G2, S2> map<G2, S2>(
    PropType<G2, S2> type,
    G2 Function(G) getter,
    S Function(S2) setter,
  ) => .delegating(
    type,
    (scene) => getter(value(scene)),
    (txn, value) => set(txn, setter(value)),
  );
}

extension PropSourceIterableExt<G, S> on Iterable<PropSource<G, S>> {
  List<PropSource<G2, S2>> remap<G2, S2>(
    PropType<G2, S2> type,
    G2 Function(G) getter,
    S Function(S2) setter,
  ) => map((s) => s.map(type, getter, setter)).toList();
}

final class TransformingPropSource<G, S> extends PropSource<G, S> {
  new(this.type, this.session, this._getter, this._setter);

  @override
  final PropType<G, S> type;

  final G Function(Scene scene) _getter;
  final void Function(TransformSession session, G current, S value) _setter;
  final TransformSession Function(SceneTransaction) session;

  @override
  void set(SceneTransaction txn, S value) {
    final session = this.session(txn);
    final current = _getter(txn.scene);
    _setter(session, current, value);
  }

  @override
  G value(Scene scene) => _getter(scene);
}

final class DelegatedPropSource<G, S> extends PropSource<G, S> {
  DelegatedPropSource(this.type, this._getter, this._setter);

  @override
  final PropType<G, S> type;

  final G Function(Scene scene) _getter;
  final void Function(SceneTransaction txn, S value) _setter;

  @override
  G value(Scene scene) => _getter(scene);

  @override
  void set(SceneTransaction txn, S value) => _setter(txn, value);
}

sealed class PropValue<T> {
  const PropValue();

  const factory PropValue.uniform(T value) = Uniform<T>;
  const factory PropValue.mixed() = Mixed<T>;

  T? get() => switch (this) {
    Uniform(:final value) => value,
    Mixed() => null,
  };

  T? call() => get();
}

final class const Uniform<T>(final T value) extends PropValue<T>;
final class const Mixed<T>() extends PropValue<T>;

sealed class Prop<G, S> {
  Prop(this.sources);

  static List<Prop> resolve(Iterable<Iterable<PropSource>> group) {
    final count = group.length;

    final propsByType = <PropType, List<PropSource>>{};
    for (final props in group) {
      for (final prop in props) {
        propsByType.putIfAbsent(prop.type, () => []).add(prop);
      }
    }

    final result = <Prop>[];
    for (final entry in propsByType.entries) {
      final props = entry.value;
      if (props.length == count) {
        result.add(entry.key.compose(props));
      }
    }

    return result;
  }

  final List<PropSource<G, S>> sources;

  bool compare(G a, G b) => a == b;

  PropValue<G> value(Scene scene) {
    final first = sources.first.value(scene);

    for (final source in sources.skip(1)) {
      final v = source.value(scene);
      if (!compare(first, v)) return const .mixed();
    }

    return .uniform(first);
  }

  void set(SceneTransaction txn, S value) {
    for (final source in sources) source.set(txn, value);
  }

  void alter(SceneTransaction txn, S Function(G current) transform) {
    for (final source in sources) {
      final current = source.value(txn.scene);
      final value = transform(current);
      source.set(txn, value);
    }
  }

  PropType get type;
}
