import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/domain/crop_zone.dart';
import 'package:greenhouse_app/domain/device_controller.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor_manager.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/widgets/devices_list.dart';
import 'package:greenhouse_app/presentation/widgets/sensors_list.dart';
import 'package:greenhouse_app/presentation/widgets/zone_scheme.dart';
import 'package:greenhouse_app/presentation/widgets/zone_size_selector.dart';

class CreateZoneScreen extends StatefulWidget {
  final int greenhouseId;
  const CreateZoneScreen({required this.greenhouseId, super.key});

  @override
  State<CreateZoneScreen> createState() => _CreateZoneScreenState();
}

class _CreateZoneScreenState extends State<CreateZoneScreen> {
  late CropZone zoneDraft;

  @override
  void initState() {
    super.initState();
    // Initialize the zoneDraft with default values
    zoneDraft = CropZone(
      id: -1,
      title: '',
      sensorManager: SensorManager(),
      deviceController: DeviceController(),
    );
  }

  void _updateZoneDimensions({double? width, double? height}) {
    setState(() {
      zoneDraft = zoneDraft.copyWith(
        definitions: Pair(
          width ?? zoneDraft.definitions.first,
          height ?? zoneDraft.definitions.second,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GreenhouseBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create zone'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                bloc.add(
                  SaveZoneEvent(
                    greenhouseId: widget.greenhouseId,
                    zone: zoneDraft,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            ZoneScheme(
              sensorManager: zoneDraft.sensorManager,
              deviceController: zoneDraft.deviceController,
              definitions: zoneDraft.definitions,
            ),
            const SizedBox(height: 16),
            ZoneSizeSelector(
              definitions: zoneDraft.definitions,
              onHeightChanged: (value) {
                final height = double.tryParse(value);
                if (height != null) {
                  _updateZoneDimensions(height: height);
                }
              },
              onWidthChanged: (value) {
                final width = double.tryParse(value);
                if (width != null) {
                  _updateZoneDimensions(width: width);
                }
              },
            ),
            const SizedBox(height: 16),
            SensorsList(sensors: zoneDraft.sensorManager.sensors),
            const SizedBox(height: 16),
            DevicesList(devices: zoneDraft.deviceController.devices),
          ],
        ),
      ),
    );
  }
}
