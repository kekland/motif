import 'package:blueprint/blueprint.dart';
import 'package:flutter/rendering.dart';
import 'package:ui/ui.dart';

part 'transient_connection.dart';

class BlueprintController<B extends Blueprint> with ChangeNotifier, ChangeNotifierDisposable {
  BlueprintController(this.blueprint) {
    blueprint.addListener(notifyListeners);
  }

  static BlueprintController of(BuildContext context) => context.read<BlueprintController>();
  static BlueprintController watch(BuildContext context) => context.watch<BlueprintController>();

  final B blueprint;
  late final transientConnections = $customDisposable(TransientConnections(), (d) => d.dispose());

  final renderKey = GlobalKey();
  RenderConnections get render => renderKey.currentContext!.findRenderObject()! as RenderConnections;

  Offset globalToLocal(Offset globalPosition) => render.globalToLocal(globalPosition);
  List<SocketHitTestEntry> hitTestSockets(Offset globalPosition) {
    return render.hitTestSockets(globalToLocal(globalPosition));
  }

  @override
  void dispose() {
    blueprint.removeListener(notifyListeners);
    super.dispose();
  }

  Iterable<Node> get nodes => blueprint.nodes;
  Iterable<Connection> get connections => blueprint.connections;

  void addNode(Node node, {bool isStatic = false, Offset? position}) =>
      blueprint.addNode(node, isStatic: isStatic, position: position);

  void removeNode(Node node) => blueprint.removeNode(node);

  void connect(Socket a, Socket b) => blueprint.connect(a, b);
  void disconnect(Socket a, Socket b) => blueprint.disconnect(a, b);
}
