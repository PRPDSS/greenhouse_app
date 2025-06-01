import 'package:flutter/material.dart';
import 'package:greenhouse_app/domain/climate_data.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor_listener.dart';

class Sensor {
  final int _id;
  SensorType _type;
  Pair<double> _position;
  double _value = 0.0;
  final double _criticalMin;
  final double _criticalMax;
  final List<SensorListener> _listeners = [];

  Sensor({
    required int id,
    required SensorType type,
    required Pair<double> position,
    double criticalMin = 0.0,
    double criticalMax = 100.0,
  }) : _id = id,
       _type = type,
       _position = position,
       _criticalMin = criticalMin,
       _criticalMax = criticalMax;

  int get id => _id;
  SensorType get type => _type;
  Pair<double> get position => _position;

  set value(double newValue) {
    _value = newValue;
    _notifyListeners();
  }

  set position(Pair<double> newPosition) {
    _position = newPosition;
  }

  set type(SensorType newType) {
    _type = newType;
  }

  void addListener(SensorListener listener) {
    _listeners.add(listener);
  }

  void removeListener(SensorListener listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener.onSensorUpdated(ClimateData(sensorId: id, value: _value, type: _type, timestamp: DateTime.now()));
    }
  }

  String toJson() {
    return '''
    {
      "id": $_id,
      "type": "${_type.toString().split('.').last}",
      "position": ${_position.toJson()},
      "value": $_value,
      "criticalMin": $_criticalMin,
      "criticalMax": $_criticalMax
    }
    ''';
  }

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] as int,
      type: SensorType.values.firstWhere(
        (e) => e.toString() == 'SensorType.${json['type']}',
        orElse: () => SensorType.temperature,
      ),
      position: Pair<double>.fromJson(json['position'] as Map<String, dynamic>),
      criticalMin: (json['criticalMin'] as num).toDouble(),
      criticalMax: (json['criticalMax'] as num).toDouble(),
    );
  }

  static Color sensorTypeToColor(SensorType type) {
    switch (type) {
      case SensorType.temperature:
        return Colors.red;
      case SensorType.humidity:
        return Colors.blue;
      case SensorType.acidity:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

enum SensorType { temperature, humidity, acidity }
