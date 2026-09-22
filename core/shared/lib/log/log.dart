import 'dart:developer' as developer;

import 'package:colorize/colorize.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:logging/logging.dart';

export 'package:logging/logging.dart';

final stackLogger = Logger('stack');

Frame? getTraceAtLevel([int level = 0, Type? runtimeType]) {
  final trace = Trace.current(level);

  if (trace.frames.isEmpty) return null;

  for (final frame in trace.frames) {
    if (frame.member!.contains(runtimeType.toString())) {
      return frame;
    }
  }

  return trace.frames.first;
}

var _lastLogTime = DateTime.now();
void logColorized(LogRecord record) {
  var message = Colorize(record.message);
  message = switch (record.level) {
    Level.FINEST => message.black().dark(),
    Level.FINER => message.darkGray().dark(),
    Level.FINE => message.lightGray().dark(),
    Level.INFO => message.white(),
    Level.WARNING => message.yellow(),
    Level.SEVERE => message.red(),
    Level.SHOUT => message.red().bold(),
    _ => message.white(),
  };

  final levelString = switch (record.level) {
    Level.FINEST => Colorize('FINEST'.padRight(7)).black().dark(),
    Level.FINER => Colorize('FINER'.padRight(7)).darkGray().dark(),
    Level.FINE => Colorize('FINE'.padRight(7)).lightGray().dark(),
    Level.INFO => Colorize('INFO'.padRight(7)).white(),
    Level.WARNING => Colorize('WARNING'.padRight(7)).yellow(),
    Level.SEVERE => Colorize('SEVERE'.padRight(7)).red(),
    Level.SHOUT => Colorize('SHOUT'.padRight(7)).red().bold(),
    _ => Colorize(record.level.name.padRight(7)).white(),
  };

  final loggerName = Colorize(record.loggerName).dark();

  final timeString = Colorize('[${record.time.toString().split(' ').last.split('.').first}]').dark();

  final timeDifference = record.time.difference(_lastLogTime);
  _lastLogTime = record.time;

  final timeDifferenceString = Colorize('(+${timeDifference.inMilliseconds}ms)').dark();
  var str = '$levelString $loggerName'.padRight(64);
  str += ' $timeString $message';

  if (record.error != null) {
    str += Colorize(': ${record.error}').dark().toString();
  }
  str += ' $timeDifferenceString';

  developer.log(
    str,
    time: record.time,
    level: record.level.value,
    name: record.loggerName,
    error: record.error,
    stackTrace: record.stackTrace,
  );
}

extension WrapExtension on Logger {
  T wrap<T>(T Function() invocation, {int level = 0}) {
    final member = getTraceAtLevel(level + 2)?.member;
    finest('$member()');

    try {
      return invocation();
    } catch (e, stackTrace) {
      severe('$member() threw:', e, stackTrace);
      rethrow;
    }
  }

  Future<T> wrapAsync<T>(Future<T> Function() invocation, {int level = 0}) async {
    final stopwatch = Stopwatch()..start();
    final member = getTraceAtLevel(level + 2)?.member;
    finest('$member()');

    try {
      return await invocation();
    } catch (e, stackTrace) {
      severe('$member() threw:', e, stackTrace);
      rethrow;
    } finally {
      finest('$member() completed:, ${stopwatch.elapsedMilliseconds}ms');
    }
  }
}

extension LoggerChild on Logger {
  Logger child(String name) => Logger('${this.name}/$name');
}
