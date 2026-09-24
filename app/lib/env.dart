abstract class Env {
  Uri get serverUri;
}

final class ExternalEnv extends Env {
  static const String serverUrl = 'https://motif.kz';

  @override
  Uri get serverUri => Uri.parse(serverUrl);
}

final class DevelopmentEnv extends Env {
  @override
  Uri get serverUri => Uri.parse('http://localhost:8080');
}

Env? envOverride;

final env = switch (const String.fromEnvironment('ENV')) {
  'external' => ExternalEnv(),
  'development' => DevelopmentEnv(),
  _ => envOverride ?? DevelopmentEnv(),
};
