import 'package:greenhouse_app/domain/crop_zone.dart';
import 'package:greenhouse_app/domain/device.dart';
import 'package:greenhouse_app/domain/device_controller.dart';
import 'package:greenhouse_app/domain/greenhouse.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor.dart';
import 'package:greenhouse_app/domain/sensor_manager.dart';

class ExampleData {
  static List<Greenhouse> greenhouses = [
    Greenhouse(
      id: 1,
      title: 'Greenhouse 1',
      zones: List.generate(2, (zoneIndex) {
        return CropZone(
          id: zoneIndex + 1,
          title: 'Zone ${zoneIndex + 1}',
          definitions: Pair(4 + zoneIndex * 1.0, 4 + zoneIndex * 1.0),
          deviceController: DeviceController(
            devices: List.generate(
              2,
              (deviceIndex) => Device(
                id: deviceIndex + 1,
                type: DeviceType.values[deviceIndex % DeviceType.values.length],
                position: Pair(
                  deviceIndex + zoneIndex * 1.0,
                  deviceIndex + zoneIndex * 1.0,
                ),
              ),
            ),
          ),
          sensorManager: SensorManager(
            sensors: List.generate(
              2,
              (sensorIndex) => Sensor(
                id: sensorIndex,
                type: SensorType.acidity,
                position: Pair(
                  sensorIndex + zoneIndex * 1.0,
                  sensorIndex + zoneIndex * 1.0,
                ),
              ),
            ),
          ),
        );
      }),
    ),
  ];
}
