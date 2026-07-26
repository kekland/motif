part of '../core.dart';

class TransientTransform {
  TransientTransform({this.local, this.global});

  final Matrix4? local;
  final Matrix4? global;

  static Matrix4? _lerpMatrix4(Matrix4? a, Matrix4? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b?.lerpDecomposed(.identity(), 1.0 - t);
    if (b == null) return a.lerpDecomposed(.identity(), t);
    return a.lerpDecomposed(b, t);
  }

  static TransientTransform? lerp(TransientTransform? a, TransientTransform? b, double t) {
    if (a == null && b == null) return null;
    return .new(
      local: _lerpMatrix4(a?.local, b?.local, t),
      global: _lerpMatrix4(a?.global, b?.global, t),
    );
  }

  TransientTransform copyWith({Matrix4? local, Matrix4? global}) {
    return .new(
      local: local ?? this.local,
      global: global ?? this.global,
    );
  }
}

class TransientTransformTween extends Tween<TransientTransform?> {
  TransientTransformTween({super.begin, super.end});

  @override
  TransientTransform? lerp(double t) => TransientTransform.lerp(begin, end, t);
}

class SceneTransientTransforms with Disposable {
  SceneTransientTransforms(this.scene);
  final Scene scene;

  TransientTransform? get(NodeId id) {
    final node = scene._getNode(id);
    return node.transientTransform;
  }

  void set(NodeId id, TransientTransform? transform) {
    final node = scene._getNode(id);
    node.transientTransform = transform;
  }

  void clear(NodeId id) {
    final node = scene._getNode(id);
    node.transientTransform = null;
  }

  final curve = Curves.easeInOut;
  final _animationControllers = <NodeId, AnimationController>{};
  final _tweens = <NodeId, TransientTransformTween>{};

  void animate(NodeId id, {required TransientTransform to, TransientTransform? from}) {
    if (_animationControllers.containsKey(id)) {
      _animationControllers[id]!.dispose();
    }

    final _from = from ?? get(id);
    final vsync = _transientTransformsTickerProviderKey.currentState!;
    final controller = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 125));
    _animationControllers[id] = controller;
    _tweens[id] = .new(begin: _from, end: to);

    controller.addListener(() {
      final t = curve.transform(controller.value);
      final transform = _tweens[id]!.lerp(t);
      final current = get(id);
      set(id, .new(local: transform?.local, global: current?.global));
    });

    controller.addStatusListener((status) {
      if (status == .completed) {
        _animationControllers[id]!.dispose();
        _animationControllers.remove(id);
        _tweens.remove(id);
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    for (final controller in _animationControllers.values) controller.dispose();
    super.dispose();
  }
}

final _transientTransformsTickerProviderKey = GlobalKey<SceneTransientTransformsTickerProviderState>();

class SceneTransientTransformsTickerProvider extends StatefulWidget {
  SceneTransientTransformsTickerProvider({required this.child}) : super(key: _transientTransformsTickerProviderKey);

  final Widget child;

  @override
  State<SceneTransientTransformsTickerProvider> createState() => SceneTransientTransformsTickerProviderState();
}

class SceneTransientTransformsTickerProviderState extends State<SceneTransientTransformsTickerProvider>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => widget.child;
}
