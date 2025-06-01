import 'package:flutter/material.dart';
import 'package:greenhouse_app/domain/pair.dart';

/// Представляет устройство в теплице.
class Device {
  final int _id;
  DeviceType _type;
  Pair<double> _position;
  bool _isActive = false;

  Device({
    required int id,
    required DeviceType type,
    required Pair<double> position,
  }) : _id = id,
       _type = type,
       _position = position;

  /// Получает информацию об устройстве.
  int get id => _id;

  /// Получает тип устройства.
  DeviceType get type => _type;

  /// Получает позицию устройства в теплице.
  Pair<double> get position => _position;

  /// Получает состояние устройства (включено/выключено).
  ///
  /// Возвращает `true`, если устройство активно, иначе `false`.
  bool get isActive => _isActive;

  set type(DeviceType newType) {
    _type = newType;
  }

  set position(Pair<double> newPosition) {
    _position = newPosition;
  }

  void turnOn() {
    _isActive = true;
  }

  void turnOff() {
    _isActive = false;
  }

  String toJson() {
    return '''
    {
      "id": $_id,
      "type": "${_type.toString().split('.').last}",
      "position": ${_position.toJson()},
      "isActive": $_isActive
    }
    ''';
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      type: DeviceType.values.firstWhere(
        (e) => e.toString() == 'DeviceType.${json['type']}',
        orElse: () => DeviceType.heater,
      ),
      position: Pair<double>.fromJson(json['position'] as Map<String, dynamic>),
    );
  }

  static Color deviceTypeToColor(DeviceType type) {
    switch (type) {
      case DeviceType.heater:
        return Colors.red;
      case DeviceType.cooler:
        return Colors.blue;
      case DeviceType.humidifier:
        return Colors.green;
      case DeviceType.light:
        return Colors.yellow;
      case DeviceType.fertilizer:
        return Colors.purple;
    }
  }
}

enum DeviceType { heater, cooler, humidifier, light, fertilizer }
