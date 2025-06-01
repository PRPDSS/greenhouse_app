/// Синглтон класс для логирования
class Logger {
  static final Logger _instance = Logger._internal();
  Logger._internal();

  factory Logger() {
    return _instance;
  }

  static void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] - $message');
  }
}