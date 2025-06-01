import 'package:greenhouse_app/domain/device.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor.dart';

abstract class ZonesEvent {
  const ZonesEvent();
}

class LoadZonesEvent extends ZonesEvent {
  const LoadZonesEvent();
}

class AddZoneEvent extends ZonesEvent {
  final String title;
  final int cropId;

  const AddZoneEvent({required this.title, required this.cropId});
}

class UpdateZoneEvent extends ZonesEvent {
  const UpdateZoneEvent();
}

class UpdateZoneDefinitionsEvent extends ZonesEvent {
  final int zoneId;
  final double width;
  final double height;

  const UpdateZoneDefinitionsEvent({
    required this.zoneId,
    required this.width,
    required this.height,
  });
}

class DeleteZoneEvent extends ZonesEvent {
  final int zoneId;

  const DeleteZoneEvent({required this.zoneId});
}

class UpdateSensorEvent extends ZonesEvent {
  final int zoneId;
  final int sensorId;
  final SensorType type;
  final Pair<double> position;

  const UpdateSensorEvent({
    required this.zoneId,
    required this.sensorId,
    required this.type,
    required this.position,
  });
}

class UpdateDeviceEvent extends ZonesEvent {
  final int zoneId;
  final int deviceId;
  final DeviceType type;
  final Pair<double> position;

  const UpdateDeviceEvent({
    required this.zoneId,
    required this.deviceId,
    required this.type,
    required this.position,
  });
}
