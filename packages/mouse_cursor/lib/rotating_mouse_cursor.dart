import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mouse_cursor/mouse_cursor.dart';
import 'package:ui/ui.dart';
import 'package:vector_graphics/vector_graphics.dart' as vg;

class RotatingMouseCursor extends MouseCursor {
  RotatingMouseCursor({required this.steps, required this.generator}) {
    _cursors = List.generate(steps, (i) => generator(i * 2 * math.pi / steps));
  }

  RotatingMouseCursor.vg({required vg.BytesLoader loader, required this.steps})
    : generator = ((a) => VectorGraphicsMouseCursor(loader: loader, transform: Matrix4.rotationZ(a))) {
    _cursors = List.generate(steps, (i) => generator(i * 2 * math.pi / steps));
  }

  final int steps;
  final MouseCursor Function(double angle) generator;
  late final List<MouseCursor> _cursors;

  /// Resolves a cursor for a given angle of rotation. Angle is in radians.
  MouseCursor resolve(double angle) {
    final _angle = angle % (2 * math.pi);
    final step = (_angle / (2 * math.pi) * steps).floor() % steps;
    return _cursors[step];
  }

  /// Resolves a cursor given a transformation matrix to the global space alongside with anchor helpers (edge/corner).
  MouseCursor resolveRaw(Matrix4 transform, {Side? side, Corner? corner}) {
    final double angle;

    if (side == null && corner == null) {
      angle = math.atan2(transform[1], transform[0]);
    } else {
      final double localDx, localDy;

      if (side != null) {
        (localDx, localDy) = switch (side) {
          .left => (1.0, 0.0),
          .top => (0.0, 1.0),
          .right => (-1.0, 0.0),
          .bottom => (0.0, -1.0),
        };
      } else {
        (localDx, localDy) = switch (corner!) {
          .topLeft => (1.0, 1.0),
          .topRight => (-1.0, 1.0),
          .bottomLeft => (1.0, -1.0),
          .bottomRight => (-1.0, -1.0),
        };
      }

      final globalDx = transform[0] * localDx + transform[4] * localDy;
      final globalDy = transform[1] * localDx + transform[5] * localDy;
      angle = math.atan2(globalDy, globalDx);
    }

    return resolve(angle);
  }

  @override
  MouseCursorSession createSession(int device) => _cursors.first.createSession(device);

  @override
  String get debugDescription => 'RotatingMouseCursor';
}

class RotatingMouseRegion extends MouseRegion {
  const RotatingMouseRegion({
    super.key,
    required RotatingMouseCursor super.cursor,
    this.side,
    this.corner,
    super.onEnter,
    super.onExit,
    super.onHover,
    super.opaque = true,
    super.hitTestBehavior,
    super.child,
  });

  final Side? side;
  final Corner? corner;

  @override
  RotatingMouseCursor get cursor => super.cursor as RotatingMouseCursor;

  @override
  RenderRotatingMouseRegion createRenderObject(BuildContext context) {
    return RenderRotatingMouseRegion(
      onEnter: onEnter,
      onHover: onHover,
      onExit: onExit,
      baseCursor: cursor,
      opaque: opaque,
      hitTestBehavior: hitTestBehavior,
      side: side,
      corner: corner,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderRotatingMouseRegion renderObject) {
    renderObject
      ..onEnter = onEnter
      ..onHover = onHover
      ..onExit = onExit
      ..baseCursor = cursor
      ..opaque = opaque
      ..hitTestBehavior = hitTestBehavior
      ..side = side
      ..corner = corner;
  }
}

class RenderRotatingMouseRegion extends RenderMouseRegion {
  RenderRotatingMouseRegion({
    required this._baseCursor,
    super.onEnter,
    super.onHover,
    super.onExit,
    super.opaque = true,
    super.hitTestBehavior,
    super.child,
    super.validForMouseTracker,
    this._side,
    this._corner,
  });

  Side? _side;
  Side? get side => _side;
  set side(Side? value) {
    if (value == _side) return;
    _side = value;
    markNeedsPaint();
  }

  Corner? _corner;
  Corner? get corner => _corner;
  set corner(Corner? value) {
    if (value == _corner) return;
    _corner = value;
    markNeedsPaint();
  }

  RotatingMouseCursor _baseCursor;
  RotatingMouseCursor get baseCursor => _baseCursor;
  set baseCursor(RotatingMouseCursor value) {
    if (value == _baseCursor) return;
    _baseCursor = value;
    markNeedsPaint();
  }

  @override
  MouseCursor get cursor => _cursor ?? MouseCursor.defer;
  MouseCursor? _cursor;

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final m = getTransformTo(null);
    _cursor = baseCursor.resolveRaw(m, side: side, corner: corner);
  }
}
