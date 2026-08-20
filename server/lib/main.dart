import 'package:server/imports.dart';
import 'package:server/service.dart';

final logger = Logger('server');

Future<void> main() async {
  Logger.root.onRecord.listen(logColorized);
  Logger.root.level = switch (env.mode) {
    .development => .FINER,
    .production => .INFO,
  };

  await SceneSyncServer().serve(port: env.port);
  logger.info('server listening on port ${env.port}');
}
