import 'package:server/imports.dart';

final logger = Logger('server');

Future<void> main() async {
  Logger.root.onRecord.listen(logColorized);
  Logger.root.level = switch (env.mode) {
    .development => .FINER,
    .production => .INFO,
  };

  final server = Server.create(services: []);
  await server.serve(port: env.port);
  logger.info('server listening on port ${server.port}');
}
