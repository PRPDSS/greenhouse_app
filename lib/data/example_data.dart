import 'package:greenhouse_app/domain/crop_zone.dart';
import 'package:greenhouse_app/domain/device_controller.dart';
import 'package:greenhouse_app/domain/greenhouse.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor_manager.dart';

class ExampleData {
  static List<Greenhouse> greenhouses = [
    Greenhouse(
      id: 1,
      title: 'Greenhouse 1',
      zones: [
        CropZone(
          id: 1,
          title: 'Zone 1',
          definitions: Pair(5, 5),
          deviceController: DeviceController(),
          sensorManager: SensorManager(),
        ),
        CropZone(
          id: 2,
          title: 'Zone 2',
          definitions: Pair(4, 4),
          deviceController: DeviceController(),
          sensorManager: SensorManager(),
        ),
      ],
    ),
    Greenhouse(
      id: 2,
      title: 'Greenhouse 2',
      zones: [
        CropZone(
          id: 3,
          title: 'Zone 3',
          definitions: Pair(6, 6),
          deviceController: DeviceController(),
          sensorManager: SensorManager(),
        ),
      ],
    ),
  ];
}
