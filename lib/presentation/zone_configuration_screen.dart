import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/domain/crop_zone.dart';
import 'package:greenhouse_app/domain/device_controller.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/domain/sensor_manager.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';
import 'package:greenhouse_app/presentation/widgets/devices_list.dart';
import 'package:greenhouse_app/presentation/widgets/sensors_list.dart';
import 'package:greenhouse_app/presentation/widgets/zone_markers_legend.dart';
import 'package:greenhouse_app/presentation/widgets/zone_scheme.dart';
import 'package:greenhouse_app/presentation/widgets/zone_size_selector.dart';

class ZoneConfigurationScreen extends StatefulWidget {
  final int? zoneId;
  final GreenhouseBloc bloc;
  const ZoneConfigurationScreen({
    required this.zoneId,
    required this.bloc,
    super.key,
  });

  @override
  State<ZoneConfigurationScreen> createState() =>
      _ZoneConfigurationScreenState();
}

class _ZoneConfigurationScreenState extends State<ZoneConfigurationScreen> {
  late CropZone? zoneDraft;

  @override
  void initState() {
    super.initState();
    zoneDraft = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GreenhouseBloc, GreenhouseState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is! GreenhouseLoadedState) {
          return Scaffold(
            appBar: AppBar(title: Text('Zone Configuration')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        CropZone? zone;
        if (widget.zoneId != null) {
          zone = state.greenhouse.zones.firstWhere(
            (z) => z.id == widget.zoneId,
            orElse: () => throw Exception('Zone not found'),
          );
        }

        // Если zoneId == null, создаём временную зону для конфигурации
        zoneDraft ??=
            zone ??
            CropZone(
              id: -1,
              title: 'New Zone',
              crop: state.greenhouse.zones.isNotEmpty ? state.greenhouse.zones.first.crop : null,
              day: 30,
              definitions: Pair(10.0, 10.0),
              sensorManager: SensorManager(sensors: []),
              deviceController: DeviceController(devices: []),
            );

        return Scaffold(
          appBar: AppBar(
            title: Text(zoneDraft!.title),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ZoneMarkersLegend();
                    },
                  );
                },
              ),
              if (widget.zoneId == null)
                IconButton(
                  icon: Icon(Icons.check),
                  tooltip: 'Сохранить',
                  onPressed: () {
                    // TODO: добавить событие создания новой зоны
                    // Например:
                    // widget.bloc.add(AddZoneEvent(...));
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ZoneScheme(
                sensorManager: zoneDraft!.sensorManager,
                deviceController: zoneDraft!.deviceController,
                definitions: zoneDraft!.definitions,
              ),
              SizedBox(height: 16),
              ZoneSizeSelector(
                definitions: zoneDraft!.definitions,
                onWidthChanged: (value) {
                  final width = double.tryParse(value) ?? 10;
                  setState(() {
                    zoneDraft = zoneDraft!.copyWith(
                      definitions: Pair(width, zoneDraft!.definitions.second),
                    );
                  });
                  if (widget.zoneId != null) {
                    widget.bloc.add(
                      UpdateZoneDefinitionsEvent(
                        zoneId: zoneDraft!.id,
                        width: width,
                        height: zoneDraft!.definitions.second,
                      ),
                    );
                  }
                },
                onHeightChanged: (value) {
                  final height = double.tryParse(value) ?? 10;
                  setState(() {
                    zoneDraft = zoneDraft!.copyWith(
                      definitions: Pair(zoneDraft!.definitions.first, height),
                    );
                  });
                  if (widget.zoneId != null) {
                    widget.bloc.add(
                      UpdateZoneDefinitionsEvent(
                        zoneId: zoneDraft!.id,
                        width: zoneDraft!.definitions.first,
                        height: height,
                      ),
                    );
                  }
                },
              ),
              SensorsList(
                sensors: zoneDraft!.sensorManager.sensors,
                onSensorUpdated: () {
                  if (widget.zoneId != null) {
                    widget.bloc.add(UpdateZoneEvent());
                  }
                  setState(() {});
                },
              ),
              DevicesList(devices: zoneDraft!.deviceController.devices),
            ],
          ),
        );
      },
    );
  }
}
