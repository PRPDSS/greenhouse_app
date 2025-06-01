import 'package:greenhouse_app/domain/device.dart';
import 'package:greenhouse_app/domain/sensor_listener.dart';

/// Контроллер для управления устройствами
class DeviceController extends SensorListener{
  /// Список устройств
  final List<Device> _devices;

  DeviceController({List<Device>? devices}) : _devices = devices ?? [];

  List<Device> get devices => _devices;

  /// Добавить устройство в список
  void addDevice(Device device) {
    _devices.add(device);
  }

  /// Удалить устройство из списка
  void removeDevice(Device device) {
    _devices.remove(device);
  }

  String toJson() {
    return '''
    {
      "devices": ${_devices.map((device) => device.toJson()).toList()}
    }
    ''';
  }
  factory DeviceController.fromJson(Map<String, dynamic> json) {
    return DeviceController(
      devices: (json['devices'] as List<dynamic>)
          .map((deviceJson) => Device.fromJson(deviceJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
