import 'dart:math';

import 'package:editor/imports.dart';
import 'package:editor/widgets/selection_panel/widgets.dart';

part 'props.dart';
part 'statement_props.dart';
part 'cell_props.dart';
part 'widgets/builder.dart';
part 'widgets/widgets.dart';

final class PropType<T> {
  const PropType._(this.id);
  final String id;

  static const coordinate = PropType<double>._('coordinate');
  static const position = PropType<Vec2Partial>._('position');
  static const rotation = PropType<double>._('rotation');
  static const transform = PropType<Mat4>._('transform');
  static const layoutSize = PropType<LayoutSizePartial>._('layoutSize');
  static const childLayout = PropType<ChildLayout>._('childLayout');
  static const edgeStyle = PropType<EdgeStylePartial>._('edgeStyle');
  static const faceStyle = PropType<FaceStylePartial>._('faceStyle');
  static const cutT = PropType<double>._('cutT');

  CompositeProp<T> compose(Iterable<Prop> props) => switch (T) {
    const (Vec2Partial) => CompositePositionProp._(props.cast<Prop<Vec2Partial>>().toList()),
    const (Mat4) => CompositeTransformProp._(props.cast<Prop<Mat4>>().toList()),
    const (LayoutSizePartial) => CompositeLayoutSizeProp._(props.cast<LayoutSizePropBase>().toList()),
    _ => CompositeProp<T>._(props.cast<Prop<T>>().toList()),
  } as CompositeProp<T>;
}

sealed class PropValue<T> {
  const PropValue();
  const factory PropValue.uniform(T value) = Uniform<T>;
  const factory PropValue.mixed() = Mixed<T>;

  T get unwrap => (this as Uniform<T>).value;
  T? get result => switch (this) {
    Uniform<T> u => u.value,
    Mixed<T> _ => null,
  };

  bool get isUniform => this is Uniform<T>;
  bool get isMixed => this is Mixed<T>;

  PropValue<R> map<R>(R Function(T value) uniform) => switch (this) {
    Uniform<T> u => .uniform(uniform(u.value)),
    Mixed<T> _ => .mixed(),
  };

  T? call() => result;
}

final class const Uniform<T>(final T value) extends PropValue<T> {
  @override
  bool operator ==(Object other) => other is Uniform<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

final class const Mixed<T>() extends PropValue<T> {
  @override
  bool operator ==(Object other) => other is Mixed<T>;

  @override
  int get hashCode => 0;
}

sealed class Prop<T> {
  const Prop();

  PropValue<T> value(Scene scene);
  void set(SceneTransaction txn, T value);
  void alter(SceneTransaction txn, T Function(T current) update) {
    final current = value(txn.scene).unwrap;
    set(txn, update(current));
  }

  PropType<T> get type;

  bool compare(T a, T b) => a == b;
}

sealed class ObjectProp<T> extends Prop<T> {
  ObjectProp(this._getter, this._setter);

  final T Function(Scene scene) _getter;
  final void Function(SceneTransaction txn, T value) _setter;

  @override
  PropValue<T> value(Scene scene) => .uniform(_getter(scene));

  @override
  void set(SceneTransaction txn, T value) => _setter(txn, value);
}

mixin PositionPropBase on Prop<Vec2Partial> {
  Prop<double> get x;
  Prop<double> get y;
}

mixin TransformPropBase on Prop<Mat4> {
  Prop<Vec2Partial> get position;
  Prop<double> get rotation;
}

mixin LayoutSizePropBase on Prop<LayoutSizePartial> {
  Size2? resolvedSize(Scene scene);
}

class CompositeProp<T> implements Prop<T> {
  CompositeProp._(this.props) {
    assert(() {
      final types = props.map((p) => p.type).toSet();
      if (types.length > 1) {
        throw ArgumentError.value(
          props,
          'props',
          'all props must have the same type, but found: $types',
        );
      }
      return true;
    }());
  }

  static List<CompositeProp> resolveFor(Iterable<Iterable<Prop>> group) {
    final count = group.length;

    final propsByType = <PropType, List<Prop>>{};
    for (final props in group) {
      for (final prop in props) {
        propsByType.putIfAbsent(prop.type, () => []).add(prop);
      }
    }

    final result = <CompositeProp>[];
    for (final entry in propsByType.entries) {
      final props = entry.value;
      if (props.length == count) {
        result.add(entry.key.compose(props));
      }
    }

    return result;
  }

  final List<Prop<T>> props;

  @override
  PropType<T> get type => props.first.type;

  @override
  PropValue<T> value(Scene scene) {
    final first = props.first.value(scene);
    if (first is! Uniform<T>) return const .mixed();

    for (final prop in props.skip(1)) {
      final v = prop.value(scene);
      if (v is! Uniform<T>) return const .mixed();
      if (!prop.compare(first.value, v.value)) return const .mixed();
    }

    return first;
  }

  @override
  void set(SceneTransaction txn, T value) {
    for (final prop in props) prop.set(txn, value);
  }

  @override
  void alter(SceneTransaction txn, T Function(T current) update) {
    for (final prop in props) prop.alter(txn, update);
  }

  @override
  bool compare(T a, T b) => props.first.compare(a, b);
}

class CompositeTransformProp extends CompositeProp<Mat4> with TransformPropBase {
  CompositeTransformProp._(super.props) : super._();

  @override
  late final position = CompositePositionProp._(
    [for (final prop in props) (prop as TransformPropBase).position],
  );

  @override
  late final rotation = CompositeProp<double>._(
    [for (final prop in props) (prop as TransformPropBase).rotation],
  );
}

class CompositeLayoutSizeProp extends CompositeProp<LayoutSizePartial> with LayoutSizePropBase {
  CompositeLayoutSizeProp._(super.props) : super._();

  @override
  Size2? resolvedSize(Scene scene) {
    final props = this.props.cast<LayoutSizePropBase>();
    final first = props.first.resolvedSize(scene);
    for (final prop in props.skip(1)) {
      final size = prop.resolvedSize(scene);
      if (size != first) return null;
    }
    return first;
  }
}

class CompositePositionProp extends CompositeProp<Vec2Partial> with PositionPropBase {
  CompositePositionProp._(super.props) : super._();

  @override
  late final x = CompositeProp<double>._(
    [for (final prop in props) (prop as PositionPropBase).x],
  );

  @override
  late final y = CompositeProp<double>._(
    [for (final prop in props) (prop as PositionPropBase).y],
  );
}
