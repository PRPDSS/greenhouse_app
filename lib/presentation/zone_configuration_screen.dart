import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/domain/crop_zone.dart';
import 'package:greenhouse_app/domain/pair.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';
import 'package:greenhouse_app/presentation/widgets/devices_list.dart';
import 'package:greenhouse_app/presentation/widgets/sensors_list.dart';
import 'package:greenhouse_app/presentation/widgets/zone_scheme.dart';
import 'package:greenhouse_app/presentation/widgets/zone_size_selector.dart';

class ZoneConfigurationScreen extends StatefulWidget {
  final int zoneId;
  final int greenhouseId;
  const ZoneConfigurationScreen({super.key, required this.zoneId, required this.greenhouseId});

  @override
  State<ZoneConfigurationScreen> createState() => _ZoneConfigurationScreenState();
}

class _ZoneConfigurationScreenState extends State<ZoneConfigurationScreen> {
  late CropZone _zoneDraft;
  bool _isInitialized = false;

  void _updateZoneDimensions({double? width, double? height}) {
    setState(() {
      _zoneDraft = _zoneDraft.copyWith(
        definitions: Pair(
          width ?? _zoneDraft.definitions.first,
          height ?? _zoneDraft.definitions.second,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GreenhouseBloc>(context);

    return BlocBuilder<GreenhouseBloc, GreenhouseState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is! GreenhousesLoadedState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final greenhouse = state.greenhouses.firstWhere(
          (g) => g.id == widget.greenhouseId,
          orElse: () => throw Exception('Greenhouse not found'),
        );
        
        final zone = greenhouse.zones.firstWhere(
          (z) => z.id == widget.zoneId,
          orElse: () => CropZone(id: 0, title: ''),
        );

        // Инициализируем _zoneDraft только один раз при первом построении
        if (!_isInitialized) {
          _zoneDraft = zone;
          _isInitialized = true;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Zone ${_zoneDraft.title}'),
            actions: [
              IconButton(icon: Icon(Icons.delete), onPressed: () {
                Navigator.pop(context);
                bloc.add(DeleteZoneEvent(greenhouseId: widget.greenhouseId, zoneId: widget.zoneId));
              },)
              ,
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    bloc.add(
                      SaveZoneEvent(
                        greenhouseId: widget.greenhouseId,
                        zoneId: widget.zoneId,
                        zone: _zoneDraft,
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
                  sensorManager: _zoneDraft.sensorManager,
                  deviceController: _zoneDraft.deviceController,
                  definitions: _zoneDraft.definitions,
                ),
                const SizedBox(height: 16),
                ZoneSizeSelector(
                  definitions: _zoneDraft.definitions,
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
                SensorsList(sensors: _zoneDraft.sensorManager.sensors),
                const SizedBox(height: 16),
                DevicesList(devices: _zoneDraft.deviceController.devices),
              ],
            ),
          ),
        );
      },
    );
  }
}
