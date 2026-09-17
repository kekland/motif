import 'package:ui/ui.dart';
import 'package:mouse_cursor/mouse_cursor.dart';

abstract class PanelConstraints {
  const PanelConstraints();
  const factory PanelConstraints.flex(double flex) = FlexPanelConstraints;
  const factory PanelConstraints.pixels(double min, double max, {double? initial}) = PixelPanelConstraints;
  const factory PanelConstraints.ratio(double min, double max, {double? initial}) = RatioPanelConstraints;
}

class FlexPanelConstraints extends PanelConstraints {
  const FlexPanelConstraints(this.flex);
  final double flex;
}

class PixelPanelConstraints extends PanelConstraints {
  const PixelPanelConstraints(this.min, this.max, {this.initial});

  final double min;
  final double max;
  final double? initial;
}

class RatioPanelConstraints extends PanelConstraints {
  const RatioPanelConstraints(this.min, this.max, {this.initial});

  final double min;
  final double max;
  final double? initial;
}

class Panel {
  const Panel({required this.key, required this.constraints, required this.child});

  final Object key;
  final PanelConstraints constraints;
  final Widget child;
}

class Panels<T extends Object> extends StatefulWidget {
  const Panels({
    super.key,
    required this.direction,
    required this.panels,
  });

  final Axis direction;
  final List<Panel> panels;

  static PanelsState? maybeOf(BuildContext context) => context.findAncestorStateOfType<PanelsState>();
  static PanelsState of(BuildContext context) => maybeOf(context)!;

  @override
  State<Panels<T>> createState() => PanelsState<T>();
}

class PanelsState<T extends Object> extends State<Panels<T>> {
  PanelsState? parent;
  List<PanelsState> children = [];

  void attachChild(PanelsState child) {
    child.parent = this;
    children.add(child);
  }

  void detachChild(PanelsState child) {
    child.parent = null;
    children.remove(child);
  }

  @override
  void initState() {
    super.initState();
    Panels.maybeOf(context)?.attachChild(this);
  }

  @override
  void dispose() {
    parent?.detachChild(this);
    super.dispose();
  }

  int? panelIndexByKey(Object key) {
    final index = widget.panels.indexWhere((panel) => panel.key == key);
    if (index == -1) return null;
    return index;
  }

  void expand(T key) {
    final index = panelIndexByKey(key);
    if (index != null) {
      _setPanelSize(index, _getPanelMinMax(index).$2);
    } else {
      for (final c in children) c.expand(key);
    }
  }

  void collapse(T key) {
    final index = panelIndexByKey(key);
    if (index != null) {
      _setPanelSize(index, _getPanelMinMax(index).$1);
    } else {
      for (final c in children) c.collapse(key);
    }
  }

  void toggle(T key) {
    final index = panelIndexByKey(key);
    if (index != null) {
      if (_panelSizes![index] > 0) {
        expand(key);
      } else {
        collapse(key);
      }
    } else {
      for (final c in children) c.toggle(key);
    }
  }

  BoxConstraints? _constraints;
  List<double>? _panelSizes;

  (double, double) get effectiveConstraints => switch (widget.direction) {
    Axis.horizontal => (_constraints!.minWidth, _constraints!.maxWidth),
    Axis.vertical => (_constraints!.minHeight, _constraints!.maxHeight),
  };

  @override
  void didUpdateWidget(covariant Panels<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.panels.length != widget.panels.length) _panelSizes = null;
  }

  void _initializePanelSizes(List<double>? oldSizes) {
    _panelSizes = List.filled(widget.panels.length, 0.0);
    final maxExtent = effectiveConstraints.$2;
    var remaining = maxExtent;
    var totalFlex = 0.0;

    // Go through ratio/pixel sizes first
    for (var i = 0; i < widget.panels.length; i++) {
      final panel = widget.panels[i];
      final constraints = panel.constraints;

      if (constraints is PixelPanelConstraints) {
        _panelSizes![i] = oldSizes?[i] ?? constraints.initial ?? constraints.min;
        remaining -= _panelSizes![i];
      } else if (constraints is RatioPanelConstraints) {
        _panelSizes![i] = oldSizes?[i] ?? (constraints.initial ?? constraints.min) * maxExtent;
        remaining -= _panelSizes![i];
      } else if (constraints is FlexPanelConstraints) {
        totalFlex += constraints.flex;
      }
    }

    // Flex pass
    for (var i = 0; i < widget.panels.length; i++) {
      final panel = widget.panels[i];
      final constraints = panel.constraints;

      if (constraints is FlexPanelConstraints) {
        _panelSizes![i] = (remaining * constraints.flex) / totalFlex;
      }
    }
  }

  (double, double) _getPanelMinMax(int index) {
    final constraints = widget.panels[index].constraints;

    if (constraints is PixelPanelConstraints) {
      return (constraints.min, constraints.max);
    } else if (constraints is RatioPanelConstraints) {
      final maxExtent = effectiveConstraints.$2;
      return (constraints.min * maxExtent, constraints.max * maxExtent);
    } else if (constraints is FlexPanelConstraints) {
      return (0.0, double.infinity);
    }

    return (0.0, double.infinity);
  }

  double _clampPanel(int index, double size) {
    final minMax = _getPanelMinMax(index);
    return size.clamp(minMax.$1, minMax.$2);
  }

  int? _activeDragIndex;
  DragStartDetails? _activeDragDetails;
  List<double>? _dragStartPanelSizes;

  MouseCursor get _unclampedMouseCursor => switch (widget.direction) {
    Axis.horizontal => SystemMouseCursors.resizeColumn,
    Axis.vertical => SystemMouseCursors.resizeRow,
  };

  MouseCursor get _startClampedMouseCursor => switch (widget.direction) {
    Axis.horizontal => SystemMouseCursors.resizeRight,
    Axis.vertical => SystemMouseCursors.resizeDown,
  };

  MouseCursor get _endClampedMouseCursor => switch (widget.direction) {
    Axis.horizontal => SystemMouseCursors.resizeLeft,
    Axis.vertical => SystemMouseCursors.resizeUp,
  };

  void _setPanelSize(int index, double size) {
    final sizes = _panelSizes;
    if (sizes == null || !size.isFinite) return;
    var remaining = size - sizes[index];
    if (index + 1 < widget.panels.length) {
      remaining -= _moveDivider(index, remaining, sizes);
    }

    if (remaining.abs() > 1e-6 && index > 0) {
      remaining += _moveDivider(index - 1, -remaining, sizes);
    }

    setState(() {});
  }

  double _moveDivider(int index, double delta, List<double> startSizes) {
    final a0 = startSizes[index];
    final b0 = startSizes[index + 1];
    var clamped = _clampPanel(index, a0 + delta);
    var effective = clamped - a0;
    final b = _clampPanel(index + 1, b0 - effective);
    effective = b0 - b;
    clamped = a0 + effective;

    _panelSizes![index] = clamped;
    _panelSizes![index + 1] = b;
    return effective;
  }

  void _onDragStart(int index, DragStartDetails details) {
    if (_activeDragIndex != null) return;

    final range = _getPanelMinMax(index);
    if (range.$1 >= range.$2 && range.$2 != double.infinity) return;

    final nextRange = _getPanelMinMax(index + 1);
    if (nextRange.$1 >= nextRange.$2 && nextRange.$2 != double.infinity) return;

    _activeDragIndex = index;
    _activeDragDetails = details;
    _dragStartPanelSizes = List.from(_panelSizes!);

    _updateMouseCursor();
  }

  void _onDragUpdate(int index, DragUpdateDetails details) {
    if (index != _activeDragIndex) return;

    final startDetails = _activeDragDetails!;
    final deltaOffset = details.globalPosition - startDetails.globalPosition;
    final delta = switch (widget.direction) {
      Axis.horizontal => deltaOffset.dx,
      Axis.vertical => deltaOffset.dy,
    };

    _moveDivider(index, delta, _dragStartPanelSizes!);
    _updateMouseCursor();
    setState(() {});
  }

  MouseCursor _getMouseCursorFor(int index) {
    final (leftMin, leftMax) = _getPanelMinMax(index);
    final (rightMin, rightMax) = _getPanelMinMax(index + 1);

    final panelSize = _panelSizes![index];
    final nextPanelSize = _panelSizes![index + 1];

    const epsilon = 1e-3;
    bool isClose(double a, double b) => (a - b).abs() < epsilon;

    final isClampedOnLeft = isClose(panelSize, leftMin) || isClose(nextPanelSize, rightMax);
    final isClampedOnRight = isClose(panelSize, leftMax) || isClose(nextPanelSize, rightMin);

    if (!isClampedOnLeft && !isClampedOnRight) return _unclampedMouseCursor;
    if (isClampedOnLeft && !isClampedOnRight) return _startClampedMouseCursor;
    if (!isClampedOnLeft && isClampedOnRight) return _endClampedMouseCursor;

    return .defer;
  }

  MouseCursor? _activeMouseCursor;
  void _updateMouseCursor() {
    final index = _activeDragIndex!;

    final cursor = _getMouseCursorFor(index);
    if (cursor == _activeMouseCursor) return;

    _activeMouseCursor = cursor;
    ExclusiveMouseCursor.instance.set(cursor);
  }

  void _onDragEnd(int index, DragEndDetails details) {
    _activeMouseCursor = null;
    _activeDragIndex = null;
    _activeDragDetails = null;
    _dragStartPanelSizes = null;
    ExclusiveMouseCursor.instance.release();
  }

  List<Widget> _buildDividers(BuildContext context) {
    var acc = 0.0;
    final result = <Widget>[];

    const dividerExtent = _PanelDivider.extent;
    const halfDivider = dividerExtent / 2;

    for (var i = 0; i < widget.panels.length - 1; i++) {
      acc += _panelSizes![i];

      final minMax = _getPanelMinMax(i + 1);
      final isLocked = minMax.$1 == minMax.$2;

      result.add(
        Positioned(
          left: widget.direction == .horizontal ? acc - halfDivider : null,
          top: widget.direction == .vertical ? acc - halfDivider : null,
          width: widget.direction == .horizontal ? dividerExtent : _constraints!.maxWidth,
          height: widget.direction == .vertical ? dividerExtent : _constraints!.maxHeight,
          child: _PanelDivider(
            direction: widget.direction,
            cursor: _getMouseCursorFor(i),
            index: i,
            onDragStart: (details) => _onDragStart(i, details),
            onDragUpdate: (details) => _onDragUpdate(i, details),
            onDragEnd: (details) => _onDragEnd(i, details),
            interactable: !isLocked,
          ),
        ),
      );
    }

    return result;
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      for (var i = 0; i < widget.panels.length; i++)
        SizedBox(
          width: widget.direction == Axis.horizontal ? _panelSizes![i] : null,
          height: widget.direction == Axis.vertical ? _panelSizes![i] : null,
          child: widget.panels[i].child,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_constraints != constraints) {
          _constraints = constraints;
          _initializePanelSizes(_panelSizes);
        }

        if (_panelSizes == null) _initializePanelSizes(null);

        return Stack(
          children: [
            Flex(
              direction: widget.direction,
              mainAxisSize: .min,
              children: _buildChildren(context),
            ),

            ..._buildDividers(context),
          ],
        );
      },
    );
  }
}

class _PanelDivider extends StatelessWidget {
  const _PanelDivider({
    required this.direction,
    required this.index,
    required this.cursor,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.interactable = true,
  });

  static const double extent = 8.0;

  final Axis direction;
  final int index;

  final MouseCursor cursor;
  final bool interactable;

  final GestureDragStartCallback? onDragStart;
  final GestureDragUpdateCallback? onDragUpdate;
  final GestureDragEndCallback? onDragEnd;

  @override
  Widget build(BuildContext context) {
    final divider = switch (direction) {
      Axis.horizontal => VerticalDivider(width: extent),
      Axis.vertical => Divider(height: extent),
    };

    if (!interactable) return divider;

    return GestureDetector(
      onHorizontalDragStart: direction == Axis.horizontal ? onDragStart : null,
      onHorizontalDragUpdate: direction == Axis.horizontal ? onDragUpdate : null,
      onHorizontalDragEnd: direction == Axis.horizontal ? onDragEnd : null,
      onVerticalDragStart: direction == Axis.vertical ? onDragStart : null,
      onVerticalDragUpdate: direction == Axis.vertical ? onDragUpdate : null,
      onVerticalDragEnd: direction == Axis.vertical ? onDragEnd : null,
      child: MouseRegion(
        cursor: cursor,
        child: divider,
      ),
    );
  }
}
