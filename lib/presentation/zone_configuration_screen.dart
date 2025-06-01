import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/presentation/widgets/devices_list.dart';
import 'package:greenhouse_app/presentation/widgets/sensors_list.dart';
import 'package:greenhouse_app/presentation/bloc/zones_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/zones_event.dart';
import 'package:greenhouse_app/presentation/bloc/zones_state.dart';
import 'package:greenhouse_app/presentation/widgets/zone_markers_legend.dart';
import 'package:greenhouse_app/presentation/widgets/zone_scheme.dart';
import 'package:greenhouse_app/presentation/widgets/zone_size_selector.dart';

class ZoneConfigurationScreen extends StatelessWidget {
  final int zoneId;
  final ZonesBloc bloc;
  const ZoneConfigurationScreen({
    required this.zoneId,
    required this.bloc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZonesBloc, ZonesState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is! ZonesLoadedState) {
          return Scaffold(
            appBar: AppBar(title: Text('Zone Settings')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final zone = state.zones.firstWhere(
          (zone) => zone.id == zoneId,
          orElse: () => throw Exception('Zone not found'),
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(zone.title),
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
            ],
          ),
          body: BlocBuilder<ZonesBloc, ZonesState>(
            bloc: bloc,
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ZoneScheme(
                    sensorManager: zone.sensorManager,
                    deviceController: zone.deviceController,
                    definitions: zone.definitions,
                  ),
                  SizedBox(height: 16),
                  ZoneSizeSelector(
                    definitions: zone.definitions,
                    onWidthChanged: (value) {
                      final width = double.tryParse(value) ?? 10;
                      bloc.add(
                        UpdateZoneDefinitionsEvent(
                          zoneId: zone.id,
                          width: width,
                          height: zone.definitions.second,
                        ),
                      );
                    },
                    onHeightChanged: (value) {
                      final height = double.tryParse(value) ?? 10;
                      bloc.add(
                        UpdateZoneDefinitionsEvent(
                          zoneId: zone.id,
                          width: zone.definitions.first,
                          height: height,
                        ),
                      );
                    },
                  ),
                  SensorsList(sensors: zone.sensorManager.sensors),
                  DevicesList(devices: zone.deviceController.devices),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
