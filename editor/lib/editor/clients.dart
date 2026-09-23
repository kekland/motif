part of '../editor.dart';

final class SceneClient {
  new({
    required this.id,
    required this.pointerPosition,
    required this.pointerType,
  });

  final String id;
  final Vec2? pointerPosition;
  final String? pointerType;
}

final class EditorClients with ChangeNotifier, ChangeNotifierDisposable {
  EditorClients();

  String? ownId;
  late final clients = <SceneClient>[];

  void setClients(List<SceneClient> newClients) {
    clients
      ..clear()
      ..addAll(newClients);
    notifyListeners();
  }
}
