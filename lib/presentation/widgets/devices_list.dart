import 'package:flutter/material.dart';
import 'package:greenhouse_app/domain/device.dart';

class DevicesList extends StatelessWidget {
  final List<Device> devices;
  const DevicesList({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(devices.length, (index) {
        final sensor = devices[index];
        return ListTile(
          leading: Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              color: Device.deviceTypeToColor(devices[index].type),
            ),
          ),
          title: Text('${sensor.id}'),
          subtitle: Text('Type: ${sensor.type.name}'),
          trailing: Text(
            'Position: ${sensor.position.first}, ${sensor.position.second}',
          ),
          onTap: () {
            // Handle sensor tap
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Tapped on ${sensor.id}')));
          },
        );
      }),
    );
  }
}
