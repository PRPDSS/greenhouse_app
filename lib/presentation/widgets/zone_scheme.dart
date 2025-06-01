import 'package:flutter/material.dart';
import 'package:greenhouse_app/domain/device.dart';
import 'package:greenhouse_app/domain/sensor.dart';
import 'package:greenhouse_app/domain/device_controller.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor_manager.dart';

class ZoneScheme extends StatelessWidget {
  final SensorManager sensorManager;
  final DeviceController deviceController;

  /// Размеры схемы зоны в метрах (ширина, высота)
  final Pair<double> definitions;
  const ZoneScheme({
    super.key,
    required this.sensorManager,
    required this.deviceController,
    this.definitions = const Pair(10, 10),
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    final height = width * definitions.second / definitions.first;
    final double markerSize = width / definitions.first * 0.7;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: _GridPainter(
              heightMeters: definitions.second,
              widthMeters: definitions.first,
            ),
          ),
          ...List.generate(sensorManager.sensors.length, (index) {
            final sensor = sensorManager.sensors[index];
            return Positioned(
              left:
                  sensor.position.first * width / definitions.first -
                  markerSize / 2,
              top:
                  sensor.position.second * height / definitions.second -
                  markerSize / 2,
              child: Container(
                height: markerSize,
                width: markerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Sensor.sensorTypeToColor(sensor.type),
                ),
                child: Text('${sensor.id}', textAlign: TextAlign.center),
              ),
            );
          }),
          ...List.generate(deviceController.devices.length, (index) {
            final device = deviceController.devices[index];
            return Positioned(
              left:
                  device.position.first * width / definitions.first -
                  markerSize / 2,
              top:
                  device.position.second * height / definitions.second -
                  markerSize / 2,
              child: Container(
                height: markerSize,
                width: markerSize,
                decoration: BoxDecoration(
                  color: Device.deviceTypeToColor(device.type),
                ),
                child: Text('${device.id}', textAlign: TextAlign.center),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  double gridSpacing = 1.0;
  final double widthMeters;
  final double heightMeters;
  _GridPainter({required this.widthMeters, required this.heightMeters});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withAlpha(100)
          ..strokeWidth = 1;

    // Вертикальные линии
    for (int i = 1; i < widthMeters; i++) {
      final dx = i * size.width / widthMeters;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }
    // Горизонтальные линии
    for (int i = 1; i < heightMeters; i++) {
      final dy = i * size.height / heightMeters;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
