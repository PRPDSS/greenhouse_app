import 'package:flutter/material.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor.dart';

class SensorsList extends StatefulWidget {
  final List<Sensor> sensors;
  final Function()? onSensorUpdated;
  const SensorsList({super.key, required this.sensors, this.onSensorUpdated});

  @override
  State<SensorsList> createState() => _SensorsListState();
}

class _SensorsListState extends State<SensorsList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.sensors.length, (index) {
        final sensor = widget.sensors[index];
        return Column(
          children: [
            ListTile(
              leading: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Sensor.sensorTypeToColor(sensor.type),
                ),
              ),
              title: Text('${sensor.id}'),
              subtitle: Text('Type: ${sensor.type.name}'),
              trailing: Text(
                'Position: ${sensor.position.first}, ${sensor.position.second}',
              ),
              onTap: () {
                setState(() {
                  selectedIndex = selectedIndex == index ? null : index;
                });
              },
            ),
            if (selectedIndex == index)
              _SensorConfig(
                sensor: sensor,
                onClose: () => setState(() => selectedIndex = null),
                onSensorUpdated: widget.onSensorUpdated ?? () {},
              ),
          ],
        );
      }),
    );
  }
}

class _SensorConfig extends StatefulWidget {
  final Sensor sensor;
  final VoidCallback onClose;
  final VoidCallback onSensorUpdated;

  const _SensorConfig({
    required this.sensor,
    required this.onClose,
    required this.onSensorUpdated,
  });

  @override
  State<_SensorConfig> createState() => _SensorConfigState();
}

class _SensorConfigState extends State<_SensorConfig> {
  late double posX;
  late double posY;
  late SensorType selectedType;

  @override
  void initState() {
    super.initState();
    posX = widget.sensor.position.first;
    posY = widget.sensor.position.second;
    selectedType = widget.sensor.type;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Настройки сенсора',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.close), onPressed: widget.onClose),
              ],
            ),
            const SizedBox(height: 8),
            Text('ID: ${widget.sensor.id}'),
            DropdownButton<SensorType>(
              value: selectedType,
              onChanged: (value) {
                if (value != null) setState(() => selectedType = value);
              },
              items:
                  SensorType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        ),
                      )
                      .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Позиция X'),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: TextEditingController(
                      text: posX.toStringAsFixed(2),
                    ),
                    onSubmitted: (v) {
                      final x = double.tryParse(v);
                      if (x != null) setState(() => posX = x);
                      widget.onSensorUpdated();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Позиция Y'),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: TextEditingController(
                      text: posY.toStringAsFixed(2),
                    ),
                    onSubmitted: (v) {
                      final y = double.tryParse(v);
                      if (y != null) setState(() => posY = y);
                      widget.onSensorUpdated();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Здесь можно добавить сохранение изменений в sensor
                widget.sensor.type = selectedType;
                widget.sensor.position = Pair<double>(posX, posY);
                widget.onSensorUpdated();
                widget.onClose();
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
