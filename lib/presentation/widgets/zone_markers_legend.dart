import 'package:flutter/material.dart';
import 'package:greenhouse_app/domain/device.dart';
import 'package:greenhouse_app/domain/sensor.dart';

class ZoneMarkersLegend extends StatelessWidget {
  const ZoneMarkersLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zone Markers Legend'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sensors'),
          ...List.generate(SensorType.values.length, (index) {
            final sensorType = SensorType.values[index];
            return _buildLegendItem(
              color: Sensor.sensorTypeToColor(sensorType),
              label: sensorType.name,
              isCircle: true,
            );
          }),
          Text('Devices'),
          ...List.generate(DeviceType.values.length, (index) {
            final deviceType = DeviceType.values[index];
            return _buildLegendItem(
              color: Device.deviceTypeToColor(deviceType),
              label: deviceType.name,
              isCircle: false,
            );
          }),
        ],
      ),
    );
  }

  _buildLegendItem({
    required Color color,
    required String label,
    required bool isCircle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            ),
            height: 20,
            width: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
