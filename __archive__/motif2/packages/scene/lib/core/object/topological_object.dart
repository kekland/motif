part of '../core.dart';

mixin TopologicalSceneObject on SceneObject {
  @override
  void _initialize() {
    super._initialize();
    _layoutTopology(.zero);
  }

  Topology _topology = .empty();
  Topology get topology => _topology;

  var _modifierStack = ModifierStack();
  ModifierEvaluationContext? _modifierEvaluationContext;

  Topology produceTopology(ResolvedSize size) => .empty();

  @override
  void performLayout(ObjectConstraints constraints) {
    super.performLayout(constraints);
    _layoutTopology(_resolvedSize!);
  }

  void _layoutTopology(ResolvedSize size) {
    final baseTopology = produceTopology(size);
    final (newTopology, context, nextStack) = _modifierStack.evaluate(baseTopology);
    _modifierStack = nextStack;
    _modifierEvaluationContext = context;

    final oldCells = _topology.cells.toList();
    final newCells = newTopology.cells.toList();

    if (Topology.isEquivalent(oldCells, newCells)) {
      for (var i = 0; i < oldCells.length; i++) {
        oldCells[i].setFrom(newCells[i]);
      }
    } else {
      final result = newTopology.reconcile(_topology);

      for (final c in oldCells) c.detach();
      for (final c in newCells) c._detachFromTopology();
      _removeChildren(result.deadCells);
      _addChildren(result.cells);
      if (result.danglingCells.isNotEmpty) parent!.addChildren(result.danglingCells);

      _topology = Topology(result.cells);
    }

    for (final c in _topology.cells) {
      c._owner = this;
      c.layout();
    }
  }

  EdgeCutResult cutEdge(Edge target, double t) {
    final modifier = CutEdgeModifier(targetId: target.topologyId, t: t);
    _modifierStack = _modifierStack.add(modifier);
    relayout();

    final activeModifier = _modifierStack.modifiers.last;
    final result = _modifierEvaluationContext!.results[activeModifier] as EdgeCutResult;

    return .new(
      vertex: topology.get(result.vertex.topologyId),
      edge1: topology.get(result.edge1.topologyId),
      edge2: topology.get(result.edge2.topologyId),
    );
  }
}
