import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

final class MoveActivity extends TransformActivity {
  MoveActivity(
    super.editor,
    super.cells, {
    super.onStart,
    super.onUpdate,
    super.onEnd,
    super.onCancel,
    this.snapToPixel = false,
  });

  late final Vec2 startPosition;
  late final Map<StatementId, Mat4> startWorld;
  late final StatementId grabbed;
  late final Vec2 grabOffset;
  final bool snapToPixel;
  Vec2 _bakedDelta = .zero();

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    startPosition = editor.globalToScene(details.globalPosition);

    if (!hasLayoutBoxes) return;

    scene.transientTransformAnimator.cancel(layoutBoxIds!);
    startWorld = {for (final id in layoutBoxIds!) id: scene.bundle.query.localToWorld(frameOf(id))};
    grabOffset = scene.bundle.query.hull(refs, space: .root).center - startPosition;

    final dragged = layoutBoxIds!.toSet();
    grabbed = scene.query
        .hitTest(startPosition)
        .statements
        .map(evaluation.rootOf)
        .firstWhere(dragged.contains, orElse: () => layoutBoxIds!.first);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final snapToAxis = isShiftPressed;
    final start = editor.globalToScene(startDetails.globalPosition);
    final current = editor.globalToScene(details.globalPosition);
    var delta = current - start;
    if (snapToAxis) delta = delta.snappedToAxis();

    session.translateBy(delta - _bakedDelta, snapToPixel: snapToPixel);
    _updateTransients(delta);

    if (_rearrange(current)) {
      session = .of(scene, refs, transaction: txn, mergeKey: mergeKey);
      _bakedDelta = delta;
      _updateTransients(delta);
      _animateRearrangement();
    }

    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails details) {
    final offsets = _settleTransients();
    super.onEnd(details);
    scene.transientTransformAnimator.animate(offsets);
  }

  @override
  void onCancel() {
    _clearTransients();
    super.onCancel();
  }

  @override
  MouseCursor resolveCursor() => Cursors.toolMove;

  // -------------------------------------------------------------------------------------------------------------------
  // Reparent and reordering
  // -------------------------------------------------------------------------------------------------------------------

  LayoutTree get layoutTree => evaluation.layout;

  bool _rearrange(Vec2 pointer) {
    if (!hasLayoutBoxes) return false;

    final parent = _parentAt(pointer);
    final parentLayout = parent != null ? layoutTree.layoutOf(parent) : null;

    if (parentLayout is FlexLayout) {
      final children = layoutTree.childrenOf(parent!).toList();
      final dragged = layoutBoxIds!.toSet();
      final siblings = children.where((id) => !dragged.contains(id)).toList();
      final slot = _flexSlot(parent, parentLayout, siblings, pointer + grabOffset);
      final order = [...siblings]..insertAll(slot, dragged);
      if (listEquals(order, children)) return false;
      _move(parent, before: slot < siblings.length ? siblings[slot] : null);
      return true;
    }

    if (layoutBoxes.every((b) => b.parentId == parent)) return false;
    _move(parent);
    return true;
  }

  StatementId? _parentAt(Vec2 pointer) {
    final currentParent = layoutTree.parentOf(layoutBoxes.first.id);
    final currentParentLayout = currentParent != null ? layoutTree.layoutOf(currentParent) : null;
    final ignored = {
      ...layoutBoxes,
      if (currentParentLayout is FlexLayout) ...layoutTree.childrenOf(currentParent!),
    };

    for (final hit in scene.query.hitTest(pointer).statements) {
      final id = evaluation.rootOf(hit);
      if (ignored.contains(id) || layoutTree.ancestorsOf(id).any((i) => ignored.contains(i))) continue;
      if (evaluation.statement(id) is LayoutContainer) return id;
    }

    return null;
  }

  void _move(StatementId? parent, {StatementId? before}) {
    final ids = layoutBoxIds!;
    final affected = {...ids};
    final parents = {...ids.map(layoutTree.parentOf).nonNulls, ?parent};
    for (final p in parents) {
      if (layoutTree.layoutOf(p) is FlexLayout) {
        affected.addAll(layoutTree.childrenOf(p));
      }
    }

    _beforeRearrange = {};
    for (final id in affected) {
      _beforeRearrange![id] = _settledWorld(id);
    }

    final FrameRef parentFrame = parent != null ? frameOf(parent) : .root;
    txn!.reparent(layoutBoxes.map((b) => b.frame), parentFrame, before: before);
    txn!.flush();
  }

  void _updateTransients(Vec2 delta) {
    if (!hasLayoutBoxes) return;

    final collapsed = _hasFixedPlacement(grabbed);
    final grabbedPosition = startWorld[grabbed]!.translation2 + delta;

    for (final id in layoutBoxIds!) {
      if (!_hasFixedPlacement(id)) {
        txn!.setGlobalTransientTransform(id, null);
        continue;
      }

      final start = startWorld[id]!;
      final position = collapsed
          ? grabbedPosition + (_placedWorld(id) - _placedWorld(grabbed))
          : start.translation2 + delta;

      txn!.setGlobalTransientTransform(id, Mat4.translation2(position - start.translation2) * start);
    }

    txn!.flush();
  }

  Map<StatementId, Vec2>? _beforeRearrange;
  void _animateRearrangement() {
    final before = _beforeRearrange;
    if (before == null) return;
    _beforeRearrange = null;

    final offsets = <StatementId, Vec2>{};
    for (final entry in before.entries) {
      final id = entry.key, from = entry.value;
      final offset = _toParent(id, from) - _toParent(id, _settledWorld(id));
      if (offset.length > 1e-6) offsets[id] = offset;
    }

    scene.transientTransformAnimator.animate(offsets);
  }

  Map<StatementId, Vec2> _settleTransients() {
    if (!hasLayoutBoxes) return const {};

    final transforms = <StatementId, Vec2>{};
    for (final id in layoutBoxIds!) {
      final transient = evaluation.transientTransform.globalOf(id);
      if (transient != null) transforms[id] = transient.translation2;
    }

    if (transforms.isEmpty) return const {};
    for (final id in transforms.keys) txn!.setGlobalTransientTransform(id, null);
    txn!.flush();

    return transforms.map((id, v) => .new(id, _toParent(id, v) - _toParent(id, _placedWorld(id))));
  }

  void _clearTransients() {
    if (!hasLayoutBoxes) return;
    for (final id in layoutBoxIds!) txn!.setGlobalTransientTransform(id, null);
  }

  FrameRef frameOf(StatementId id) => evaluation.statement<FramedStatement>(id)!.frame;

  bool _hasFixedPlacement(StatementId id) => evaluation.layout.placementOf(id)?.offset != null;

  Vec2 _worldOrigin(StatementId id) => scene.bundle.query.localToWorld(frameOf(id)).translation2;

  Vec2 _settledWorld(StatementId id) {
    final origin = _worldOrigin(id);
    final local = evaluation.transientTransform.localOf(id);
    if (local == null) return origin;

    final parent = layoutTree.parentOf(id);
    final space = parent != null ? frameOf(parent) : CellRef.root;
    final query = scene.bundle.query;
    final inParent = query.worldToLocal(space).transform2(origin) - local.translation2;
    return query.localToWorld(space).transform2(inParent);
  }

  Vec2 _placedWorld(StatementId id) {
    final parent = layoutTree.parentOf(id);
    if (parent == null) return _worldOrigin(id);
    return scene.bundle.query.localToWorld(frameOf(parent)).transform2(evaluation.layout.placementOf(id)!.offset!);
  }

  Vec2 _toParent(StatementId id, Vec2 world) {
    final parent = layoutTree.parentOf(id);
    return scene.bundle.query.worldToLocal(parent != null ? frameOf(parent) : CellRef.root).transform2(world);
  }

  Aabb2 _placementBounds(StatementId id) {
    final box = evaluation.statement<LayoutBoxStatement>(id)!;
    final placement = evaluation.layout.placementOf(box.id)!;
    final size = placement.size;
    final offset = placement.offset ?? .zero();
    return size.toAabb()
      ..transformDelta(box.transform)
      ..transform(.translation2(offset));
  }

  int _flexSlot(StatementId parent, FlexLayout layout, List<StatementId> siblings, Vec2 worldCenter) {
    if (siblings.isEmpty) return 0;

    final dir = layout.direction;
    final local = scene.bundle.query.worldToLocal(frameOf(parent)).transform2(worldCenter);
    final center = dir.main(local.x, local.y);

    var block = layout.gap * (layoutBoxCount - 1);
    for (final box in layoutBoxes) block += dir.mainOfSize(_placementBounds(box.id).size);

    var cursor = dir.mainOfVector(_placementBounds(layoutTree.childrenOf(parent).first).min);
    for (var i = 0; i < siblings.length; i++) {
      final extent = dir.mainOfSize(_placementBounds(siblings[i]).size);
      if (center < cursor + (block + extent + layout.gap) / 2.0) return i;
      cursor += extent + layout.gap;
    }

    return siblings.length;
  }
}
