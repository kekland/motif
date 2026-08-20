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
