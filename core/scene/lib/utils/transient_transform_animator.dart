part of '../scene.dart';

final class TransientTransformAnimator {
  TransientTransformAnimator(this.scene);

  final Scene scene;
  Ticker? _ticker;

  final _animations = <StatementId, _AnimationState>{};
  var _now = Duration.zero;

  void animate(
    Map<StatementId, Vec2> offsets, {
    Duration? duration,
    Curve? curve,
  }) {
    if (offsets.isEmpty) return;

    final ticker = _ticker ??= scene.tickerProviderKey.currentState!.createTicker(_tick);
    if (!ticker.isActive) _now = .zero;

    for (final entry in offsets.entries) {
      final id = entry.key;
      final current = _animations[id]?.current(_now) ?? .zero();

      _animations[id] = .new(
        current + entry.value,
        _now,
        duration ?? const .new(milliseconds: 200),
        curve ?? Curves.decelerate,
      );
    }

    _apply(_now);
    if (!ticker.isActive) ticker.start();
  }

  void cancel(Iterable<StatementId> ids) {
    final removed = ids.where((id) => _animations.remove(id) != null).toList();
    if (removed.isEmpty) return;
    scene._editTransient((pass) {
      for (final id in removed) pass.setLocalTransientTransform(id, null);
    });
  }

  void _tick(Duration elapsed) {
    _now = elapsed;
    _apply(_now);
    if (_animations.isEmpty) _ticker?.stop();
  }

  void _apply(Duration now) {
    final updates = <StatementId, Mat4?>{};

    for (final entry in _animations.entries.toList()) {
      final offset = entry.value.current(now);
      if (offset == null) {
        _animations.remove(entry.key);
        updates[entry.key] = null;
      } else {
        updates[entry.key] = .translation2(offset);
      }
    }

    // Apply the updates to the scene
    scene._editTransient((pass) {
      for (final entry in updates.entries) {
        pass.setLocalTransientTransform(entry.key, entry.value);
      }
    });
  }

  void dispose() {
    _ticker?.dispose();
  }
}

final class _AnimationState(
  final Vec2 from,
  final Duration start,
  final Duration duration,
  final Curve curve,
) {
  Vec2? current(Duration now) {
    final t = ((now - start).inMicroseconds / duration.inMicroseconds).clamp(0.0, 1.0);
    if (t >= 1) return null;
    return from * (1.0 - curve.transform(t));
  }
}
