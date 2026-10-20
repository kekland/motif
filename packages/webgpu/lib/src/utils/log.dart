extension type const LogLevel._(int value) {
  static const off = LogLevel._(0);
  static const error = LogLevel._(1);
  static const warn = LogLevel._(2);
  static const info = LogLevel._(3);
  static const debug = LogLevel._(4);
  static const trace = LogLevel._(5);

  String get name => switch (this) {
    .off => 'off',
    .error => 'error',
    .warn => 'warn',
    .info => 'info',
    .debug => 'debug',
    .trace => 'trace',
    _ => throw ArgumentError.value(this, 'this', 'unknown enum entry for LogLevel'),
  };
}

typedef LogCallback = void Function(LogLevel level, String message);
