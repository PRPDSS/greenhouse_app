import 'package:greenhouse_app/domain/crop.dart';
import 'package:greenhouse_app/domain/device_controller.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor_manager.dart';

class CropZone {
  final int _id;
  final String title;
  final Crop _crop;
  double day;
  /// Размеры зоны в метрах (ширина, высота).
  /// 
  /// По умолчанию 10x10 метров.
  /// 
  /// Сначала ширина, потом высота.
  Pair<double> definitions;
  final SensorManager sensorManager;
  final DeviceController deviceController;

  CropZone({
    required int id,
    required this.title,
    required Crop crop,
    this.definitions = const Pair(10.0, 10.0),
    this.day = 0,
    SensorManager? sensorManager,
    DeviceController? deviceController,
  }) : _id = id,
       _crop = crop,
       sensorManager = sensorManager ?? SensorManager(),
       deviceController = deviceController ?? DeviceController();

  int get id => _id;
  Crop get crop => _crop;
  double get area => definitions.first * definitions.second;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CropZone &&
            runtimeType == other.runtimeType &&
            _id == other._id &&
            title == other.title &&
            _crop == other._crop &&
            day == other.day &&
            definitions == other.definitions &&
            sensorManager == other.sensorManager &&
            deviceController == other.deviceController);
  }

  void updateDefinitions(double width, double height) {
    if (width > 0 && height > 0) {
      definitions = Pair(width, height);
    } else {
      throw ArgumentError('Width and height must be greater than zero');
    }
  }

  String toJson() {
    return '''
    {
      "id": $_id,
      "title": "$title",
      "crop": ${_crop.toJson()},
      "sensorManager": ${sensorManager.toJson()},
      "deviceController": ${deviceController.toJson()}
    }
    ''';
  }

  factory CropZone.fromJson(Map<String, dynamic> json) {
    return CropZone(
      id: json['id'] as int,
      title: json['title'] as String,
      crop: Crop.fromJson(json['crop'] as Map<String, dynamic>),
      sensorManager: SensorManager.fromJson(
        json['sensorManager'] as Map<String, dynamic>,
      ),
      deviceController: DeviceController.fromJson(
        json['deviceController'] as Map<String, dynamic>,
      ),
    );
  }
}
