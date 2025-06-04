import 'dart:convert';
import 'package:greenhouse_app/domain/sensor.dart';

class SensorManager {
  final List<Sensor> _sensors;
  SensorManager({List<Sensor>? sensors}) : _sensors = sensors ?? [];

  List<Sensor> get sensors => _sensors;

  String toJson() {
    return jsonEncode({
      'sensors': _sensors.map((sensor) => jsonDecode(sensor.toJson())).toList(),
    });
  }

  factory SensorManager.fromJson(Map<String, dynamic> json) {
    return SensorManager(
      sensors: (json['sensors'] as List)
          .map((sensorJson) => Sensor.fromJson(sensorJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
