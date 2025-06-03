import 'package:greenhouse_app/domain/device.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor.dart';

abstract class GreenhouseEvent {
  const GreenhouseEvent();
}

class LoadGreenhouseEvent extends GreenhouseEvent {
  final int greenhouseId;
  const LoadGreenhouseEvent({required this.greenhouseId});
}

class CreateGreenhouseEvent extends GreenhouseEvent {
  final String title;
  const CreateGreenhouseEvent({required this.title});
}

class LoadGreenhousesEvent extends GreenhouseEvent {
  const LoadGreenhousesEvent();
}

class UpdateZoneDefinitionsEvent extends GreenhouseEvent {
  final int zoneId;
  final double width;
  final double height;

  const UpdateZoneDefinitionsEvent({
    required this.zoneId,
    required this.width,
    required this.height,
  });
}

class UpdateZoneEvent extends GreenhouseEvent {
  const UpdateZoneEvent();
}

class UpdateSensorEvent extends GreenhouseEvent {
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

class UpdateDeviceEvent extends GreenhouseEvent {
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