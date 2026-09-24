part of '../scene.dart';

class SceneTickerProvider extends StatefulWidget {
  new({required this.scene, required this.child}) : super(key: scene.tickerProviderKey);

  final Scene scene;
  final Widget child;

  @override
  State<SceneTickerProvider> createState() => SceneTickerProviderState();
}

class SceneTickerProviderState extends State<SceneTickerProvider> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => widget.child;
}
