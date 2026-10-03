import 'dart:io';

import 'package:shared/shared.dart';
import 'package:sync/server.dart' as sync;
import 'package:sync_server/network/gateway.dart';
import 'package:sync_server/storage.dart';

final logger = Logger('server');

enum ServerMode(final String value) {
  development('development'),
  production('production');

  static ServerMode fromString(String? value) => switch (value) {
    'development' => .development,
    'production' => .production,
    _ => throw ArgumentError.value(value, 'value', 'invalid ServerMode value'),
  };
}

abstract interface class Env {
  ServerMode get mode;
  int get port;
}

final class DevelopmentEnv implements Env {
  @override
  ServerMode get mode => ServerMode.development;

  @override
  int get port => 8085;
}

final class ExternalEnv {
  ServerMode get mode => ServerMode.fromString(const String.fromEnvironment('ENV'));
  int get port => int.parse(const String.fromEnvironment('PORT'));
}

final env = DevelopmentEnv();

Future<void> main() async {
  hierarchicalLoggingEnabled = true;
  logger.onRecord.listen(logColorizedStdout);
  logger.level = switch (env.mode) {
    .development => .FINEST,
    .production => .INFO,
  };

  final manager = await createStorageManager(rootDirectory: 'data');
  final indexStorage = SqliteIndexStorage(manager);
  await indexStorage.initialize();

  final server = sync.Server(indexStorage);

  final gateway = ServerHttpGateway(server);
  final port = await gateway.listen(.anyIPv4, env.port);
  logger.info('Server listening on port $port');

  ProcessSignal.sigint.watch().first.then((_) async {
    await gateway.close();
    await server.close();
    exit(0);
  });
}
