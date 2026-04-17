part of '../controller.dart';

typedef TransientTransform = (Node node, Matrix4? transform);

class TransientTransforms with Disposable {
  late final _streamController = $streamControllerBroadcast<TransientTransform>(sync: true);
  Stream<TransientTransform> get stream => _streamController.stream;
  Stream<Matrix4?> streamFor(Node node) => stream.where((t) => t.$1 == node).map((t) => t.$2);

  final _values = <Node, Matrix4?>{};
  void apply(Node node, Matrix4? transform) {
    if (_values[node] == transform) return;
    _values[node] = transform;
    _streamController.add((node, transform));
  }

  void clear(Node node) => apply(node, null);

  Matrix4? get(Node node) => _values[node];

  // -
  // Animations
  // -
  final curve = Curves.easeInOut;
  final _animationControllers = <Node, AnimationController>{};
  final _tweens = <Node, Matrix4Tween>{};

  void animate(Node node, {required Matrix4 to, Matrix4? from}) {
    if (_animationControllers.containsKey(node)) {
      _animationControllers[node]!.dispose();
    }

    final _from = from ?? get(node) ?? Matrix4.identity();

    final vsync = transientTransformsTickerProviderKey.currentState!;
    final controller = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 125));
    _animationControllers[node] = controller;
    _tweens[node] = Matrix4Tween(begin: _from, end: to);

    controller.addListener(() {
      final value = curve.transform(controller.value);
      final transform = _tweens[node]!.lerp(value);
      apply(node, transform);
    });

    controller.addStatusListener((status) {
      if (status == .completed) {
        _animationControllers[node]!.dispose();
        _animationControllers.remove(node);
        _tweens.remove(node);
      }
    });

    controller.forward();
  }
}

// -
// Provides a TickerProvider for transient transforms.
//
// Inserted once in the widget tree.
// -

final transientTransformsTickerProviderKey = GlobalKey<TransientTransformsTickerProviderState>();

class TransientTransformsTickerProvider extends StatefulWidget {
  TransientTransformsTickerProvider({required this.child}) : super(key: transientTransformsTickerProviderKey);

  final Widget child;

  @override
  State<TransientTransformsTickerProvider> createState() => TransientTransformsTickerProviderState();
}

class TransientTransformsTickerProviderState extends State<TransientTransformsTickerProvider>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => widget.child;
}
