import 'dart:convert';
import 'package:greenhouse_app/domain/device_controller.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor_manager.dart';

class CropZone {
  final int _id;
  final String title;
  final int? _cropId;
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
    int? cropId,
    this.definitions = const Pair(10.0, 10.0),
    this.day = 0,
    SensorManager? sensorManager,
    DeviceController? deviceController,
  }) : _id = id,
       _cropId = cropId,
       sensorManager = sensorManager ?? SensorManager(),
       deviceController = deviceController ?? DeviceController();

  int get id => _id;
  int? get cropId => _cropId;
  double get area => definitions.first * definitions.second;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CropZone &&
            runtimeType == other.runtimeType &&
            _id == other._id &&
            title == other.title &&
            _cropId == other._cropId &&
            day == other.day &&
            definitions == other.definitions &&
            sensorManager == other.sensorManager &&
            deviceController == other.deviceController);
  }

  @override
  int get hashCode => _id.hashCode;

  void updateDefinitions(double width, double height) {
    if (width > 0 && height > 0) {
      definitions = Pair(width, height);
    } else {
      throw ArgumentError('Width and height must be greater than zero');
    }
  }

  CropZone copyWith({
    int? id,
    String? title,
    int? cropId,
    /// сначала ширина потом высота
    Pair<double>? definitions,
    double? day,
    SensorManager? sensorManager,
    DeviceController? deviceController,
  }) {
    return CropZone(
      id: id ?? _id,
      title: title ?? this.title,
      cropId: cropId ?? _cropId,
      definitions: definitions ?? this.definitions,
      day: day ?? this.day,
      sensorManager: sensorManager ?? this.sensorManager,
      deviceController: deviceController ?? this.deviceController,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'title': title,
      'cropId': _cropId,
      'day': day,
      'definitions': {
        'width': definitions.first,
        'height': definitions.second,
      },
      'sensorManager': jsonDecode(sensorManager.toJson()),
      'deviceController': jsonDecode(deviceController.toJson()),
    };
  }

  factory CropZone.fromMap(Map<String, dynamic> map) {
    return CropZone(
      id: map['id'] as int,
      title: map['title'] as String,
      cropId: map['cropId'] as int?,
      day: (map['day'] as num).toDouble(),
      definitions: Pair(
        (map['definitions'] as Map<String, dynamic>)['width'] as double,
        (map['definitions'] as Map<String, dynamic>)['height'] as double,
      ),
      sensorManager: SensorManager.fromJson(
        map['sensorManager'] as Map<String, dynamic>,
      ),
      deviceController: DeviceController.fromJson(
        map['deviceController'] as Map<String, dynamic>,
      ),
    );
  }
}
