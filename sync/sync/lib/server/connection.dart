import 'package:sync/schema.dart' as pb;

abstract class ServerConnection {
  Stream<pb.ClientEvent> get events;
  void send(pb.ServerEvent event);
  Future<void> close();
}
