import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  factory Log({bool excludeDebug = false, List<Level>? excludedLevels}) {
    if (kDebugMode) {
      _logger ??= Logger(
        filter: excludeDebug ? ExcludeByLevelLogFilter(excludedLevels: excludedLevels ?? <Level>[Level.debug]) : null,
        printer: PrettyPrinter(
          methodCount: 4, // number of method calls to be displayed
        ),
      );
    }
    return _instance;
  }

  Log._internal();

  static final Log _instance = Log._internal();

  static Log getInstance() => _instance;

  static Logger? _logger;
  static String tag = 'default:';

/*logger.v("Verbose log");

logger.d("Debug log");

logger.i("Info log");

logger.w("Warning log");

logger.e("Error log");

logger.wtf("What a terrible failure log");*/

  void d([dynamic msg, String? tag]) {
    _logger?.d(_messageWithTag(msg, tag));
  }

  void v([dynamic msg, String? tag]) {
    _logger?.v(_messageWithTag(msg, tag));
  }

  void i([dynamic msg, String? tag]) {
    _logger?.i(_messageWithTag(msg, tag));
  }

  void w([dynamic msg, String? tag]) {
    _logger?.w(_messageWithTag(msg, tag));
  }

  void e([dynamic msg, StackTrace? stk, String? tag]) {
    _logger?.e(_messageWithTag(msg, tag), _messageWithTag(msg), stk);
  }

  void wtf([dynamic msg, String? tag]) {
    _logger?.wtf(_messageWithTag(msg, tag));
  }

  String _messageWithTag(dynamic msg, [String? customTag]) => '${customTag ?? tag} $msg';
}

class ExcludeByLevelLogFilter extends LogFilter {
  ExcludeByLevelLogFilter({this.excludedLevels});

  final List<Level>? excludedLevels;

  @override
  bool shouldLog(LogEvent event) => !(excludedLevels?.contains(event.level) ?? false);
}

/*
class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      print(line);
    }
  }
}*/
