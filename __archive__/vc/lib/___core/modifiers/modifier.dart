part of '../core.dart';

abstract class Modifier<C extends ImmutableCell> {
  Modifier({this.isEnabled = true});

  final bool isEnabled;

  (C, List<ImmutableCell>) apply(C cell);
}

typedef VertexModifier = Modifier<ImmutableVertex>;
typedef EdgeModifier = Modifier<ImmutableEdge>;

mixin Modifiable<C extends ImmutableCell> on Cell {
  Iterable<Modifier<C>> get modifiers;
}

mixin ImmutableModifiable<C extends ImmutableCell> on Cell implements Modifiable<C> {
  @override
  Iterable<Modifier<C>> get modifiers => _modifiers;
  List<Modifier<C>> get _modifiers;
}

mixin MutableModifiable<C extends ImmutableCell> on Cell implements Modifiable<C> {
  @override
  Iterable<Modifier<C>> get modifiers => _modifiers;
  ListSignal<Modifier<C>> get _modifiers;

  void addModifier(Modifier<C> modifier) => _modifiers.add(modifier);
  void insertModifier(int index, Modifier<C> modifier) => _modifiers.insert(index, modifier);
  void removeModifier(Modifier<C> modifier) => _modifiers.remove(modifier);
  void replaceModifier(int index, Modifier<C> modifier) => _modifiers[index] = modifier;
}
