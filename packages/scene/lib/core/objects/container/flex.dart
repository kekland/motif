part of '../../core.dart';

ResolvedSize _layoutFlex(
  FlexContainerChildLayout layout,
  ObjectSize size,
  LayoutConstraints constraints,
  List<SceneObject> children,
) {
  final direction = layout.direction;

  final mainDimension = direction.mainSize(size);
  final crossDimension = direction.crossSize(size);

  final isMainContain = mainDimension.type == .contain;
  final isCrossContain = crossDimension.type == .contain;

  var fixedMainAxisSize = 0.0;
  var maxCrossAxisSize = 0.0;
  var totalFlex = 0.0;

  for (final child in children) {
    final childSize = child.size;
    final childMainDimension = direction.mainSize(childSize);
    final childCrossDimension = direction.crossSize(childSize);

    if (childMainDimension.type == .expand && !isMainContain) {
      const flexFactor = 1.0;
      totalFlex += flexFactor;
    } else {
      child.layout(constraints);
      final childBbox = child.bbox;
      final childTransform = child.transform.value;
      final localBbox = childTransform.transformAabb2(childBbox);

      final main = direction.main(localBbox.width, localBbox.height);
      final cross = direction.cross(localBbox.width, localBbox.height);

      fixedMainAxisSize += main;
      if (childCrossDimension.type != .expand || !isCrossContain) {
        maxCrossAxisSize = math.max(maxCrossAxisSize, cross);
      }
    }
  }

  final gapSpace = children.isEmpty ? 0.0 : (children.length - 1) * layout.gap;

  final mainConstraints = direction.mainConstraints(constraints);
  final containerMainSize = mainDimension.resolve(
    mainConstraints.min,
    mainConstraints.max,
    childValue: fixedMainAxisSize + gapSpace,
  );

  final crossConstraints = direction.crossConstraints(constraints);
  final containerCrossSize = crossDimension.resolve(
    crossConstraints.min,
    crossConstraints.max,
    childValue: maxCrossAxisSize,
  );

  final remainingSpace = (containerMainSize - fixedMainAxisSize - gapSpace).clamp(0.0, double.infinity);
  final spacePerFlex = totalFlex > 0.0 ? remainingSpace / totalFlex : 0.0;

  var currentMainOffset = 0.0;

  for (final child in children) {
    final childMainDimension = direction.mainSize(child.size);
    final childCrossDimension = direction.crossSize(child.size);
    final childTransform = child.transform.value;

    double childMainSize, childCrossSize;
    var needsLayout = false;

    if (childMainDimension.type == .expand && !isMainContain) {
      const flexFactor = 1.0;
      childMainSize = spacePerFlex * flexFactor;
      needsLayout = true;
    } else {
      final localBbox = child.bbox;
      final bbox = childTransform.transformAabb2(localBbox);
      childMainSize = direction.main(bbox.width, bbox.height);
    }

    if (childCrossDimension.type == .expand) {
      childCrossSize = containerCrossSize;
      needsLayout = true;
    } else {
      final localBbox = child.bbox;
      final bbox = childTransform.transformAabb2(localBbox);
      childCrossSize = direction.cross(bbox.width, bbox.height);
    }

    if (needsLayout) {
      // final constraints = direction.tightConstraintsFor(main: childMainSize, cross: childCrossSize);
      // child.layout(constraints);
    }

    final localBbox = child.bbox;
    final t2 = childTransform.clone()..setTranslationRaw(0, 0, 0);
    final bbox = t2.transformAabb2(localBbox);

    final dx = direction == .row ? currentMainOffset : 0.0;
    final dy = direction == .row ? 0.0 : currentMainOffset;

    final tx = dx - bbox.left;
    final ty = dy - bbox.top;

    child.transform = child.transform.copyWithTranslation(.new(tx, ty));
    currentMainOffset += childMainSize + layout.gap;
  }

  return direction.sizeFor(main: containerMainSize, cross: containerCrossSize);
}
