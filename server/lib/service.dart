import 'dart:io';

import 'package:schema/schema.dart' as pb;

final class SceneSyncServer {
  final scene = pb.Scene(program: pb.Program());
  final _clients = <WebSocket>{};

  Future<void> serve({int port = 8085}) async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print('scene sync on ws://localhost:$port');

    await for (final request in server) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        _handle(await WebSocketTransformer.upgrade(request));
      } else {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..close();
      }
    }
  }

  void _handle(WebSocket socket) {
    _clients.add(socket);
    socket.add(pb.ServerEvent(snapshot: scene).writeToBuffer());

    socket.listen(
      (data) {
        if (data is! List<int>) return;
        final delta = pb.DeltaBatch.fromBuffer(data);
        _apply(delta);

        final frame = pb.ServerEvent(delta: delta).writeToBuffer();
        for (final client in _clients) {
          if (client != socket) client.add(frame);
        }
      },
      onDone: () => _clients.remove(socket),
      onError: (_) => _clients.remove(socket),
      cancelOnError: true,
    );
  }

  void _apply(pb.DeltaBatch batch) {
    for (final delta in batch.deltas) {
      if (delta.hasProgram()) _applyProgramDelta(delta.program);
    }
  }

  void _applyProgramDelta(pb.ProgramDelta delta) {
    final statements = scene.program.statements;

    for (final id in delta.removed) {
      statements.removeWhere((s) => _idOf(s) == id.value);
    }

    var at = statements.length;
    final anchor = delta.anchor;
    if (anchor.hasStart()) at = 0;
    if (anchor.hasAt()) {
      final i = statements.indexWhere((s) => _idOf(s) == anchor.at.value);
      if (i != -1) at = i;
    }
    if (anchor.hasAfter()) {
      final i = statements.indexWhere((s) => _idOf(s) == anchor.after.value);
      if (i != -1) at = i + 1;
    }

    for (final statement in delta.inserted) {
      final id = _idOf(statement);
      statements.removeWhere((s) => _idOf(s) == id); // LWW on id collision
    }
    statements.insertAll(at.clamp(0, statements.length), delta.inserted);
  }

  String _idOf(pb.Statement s) => switch (s.whichStatement()) {
    pb.Statement_Statement.frame => s.frame.id.value,
    pb.Statement_Statement.vertex => s.vertex.id.value,
    pb.Statement_Statement.edge => s.edge.id.value,
    pb.Statement_Statement.face => s.face.id.value,
    pb.Statement_Statement.cutEdge => s.cutEdge.id.value,
    pb.Statement_Statement.glueVertices => s.glueVertices.id.value,
    pb.Statement_Statement.circle => s.circle.id.value,
    pb.Statement_Statement.rectangle => s.rectangle.id.value,
    pb.Statement_Statement.triangle => s.triangle.id.value,
    pb.Statement_Statement.container => s.container.id.value,
    pb.Statement_Statement.notSet => '',
  };
}
