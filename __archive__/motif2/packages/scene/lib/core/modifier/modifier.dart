part of '../core.dart';

class ModifierEvaluationContext {
  final Map<Modifier, Object> results = {};
  final List<String> warnings = [];

  void _addResult(Modifier modifier, Object result) {
    results[modifier] = result;
  }
}

abstract class Modifier {
  const Modifier({this.isActive = true});

  final bool isActive;

  (Topology, Modifier) apply(ModifierEvaluationContext context, Topology input);
}

class ModifierStack {
  ModifierStack({this._modifiers = const []});

  final List<Modifier> _modifiers;
  List<Modifier> get modifiers => List.unmodifiable(_modifiers);

  (Topology, ModifierEvaluationContext, ModifierStack) evaluate(Topology baseTopology) {
    final context = ModifierEvaluationContext();
    var current = baseTopology;

    final newModifiers = <Modifier>[];
    var stackChanged = false;

    for (final modifier in _modifiers) {
      if (!modifier.isActive) continue;

      try {
        final (newTopology, newModifier) = modifier.apply(context, current);
        current = newTopology;
        newModifiers.add(newModifier);
        if (!identical(newModifier, modifier)) stackChanged = true;
      } catch (e) {
        context.warnings.add('Modifier ${modifier.runtimeType} failed: $e');
        newModifiers.add(modifier);
      }
    }

    final nextStack = stackChanged ? ModifierStack(modifiers: newModifiers) : this;
    return (current, context, nextStack);
  }

  ModifierStack add(Modifier modifier) => .new(modifiers: [..._modifiers, modifier]);
}
