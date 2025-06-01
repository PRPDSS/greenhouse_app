import 'package:greenhouse_app/domain/crop.dart';
import 'package:greenhouse_app/domain/crop_zone.dart';
import 'package:greenhouse_app/domain/device.dart';
import 'package:greenhouse_app/domain/device_controller.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor.dart';
import 'package:greenhouse_app/domain/sensor_manager.dart';

class ExampleData {
  static List<CropZone> cropZones = List.generate(
    10,
    (index) => CropZone(
      id: index,
      title: 'Zone ${index + 1}',
      crop: Crop(
        title: 'Crop ${index + 1}',
        temperature: [index * 2.0, index * 2.5],
        humidity: [index * 5.0, index * 5.5],
        ligntning: [index * 10.0, index * 10.5],
        wateringFrequency: [index * 3.0, index * 3.5],
        wateringLevel: [index * 1.0, index * 1.5],
        growthTime: index * 10,
      ),
      definitions: Pair(10.0 + index, 5.0 + index),
      sensorManager: SensorManager(
        sensors: [
          // Example sensors
          Sensor(
            id: index,
            position: Pair(index * 1.0, index * 1.0),
            type: SensorType.temperature,
          ),
          Sensor(
            id: index + 1,
            position: Pair(index * 1.5, index * 1.5),
            type: SensorType.humidity,
          ),
        ],
      ),
      deviceController: DeviceController(
        devices: [
          // Example devices
          Device(
            id: index,
            position: Pair(index * 2.0, index * 2.0),
            type: DeviceType.heater,
          ),
          Device(
            id: index + 1,
            position: Pair(index * 2.5, index * 2.5),
            type: DeviceType.fertilizer,
          ),
        ],
      ),
    ),
  );
}
