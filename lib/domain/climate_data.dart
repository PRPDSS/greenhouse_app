import 'package:greenhouse_app/domain/sensor.dart';

/// Представляет данные о климате, полученные от датчиков.
class ClimateData {
  final int _sensorId;
  final double _value;
  final SensorType _type;
  final DateTime _timestamp;

  ClimateData({
    required int sensorId,
    required double value,
    required SensorType type,
    required DateTime timestamp,
  }) : _sensorId = sensorId,
       _value = value,
       _type = type,
       _timestamp = timestamp;

  /// Получает идентификатор датчика.
  int get sensorId => _sensorId;

  /// Получает значение, полученное от датчика.
  double get value => _value;

  /// Получает тип датчика.
  SensorType get type => _type;

  /// Получает временную метку, когда были получены данные.
  DateTime get timestamp => _timestamp;

  @override
  String toString() {
    return 'ClimateData(sensorId: $_sensorId, value: $_value, type: $_type, timestamp: $_timestamp)';
  }
}
