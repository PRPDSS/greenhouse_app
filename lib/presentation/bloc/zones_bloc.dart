import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/data/example_data.dart';
import 'package:greenhouse_app/presentation/bloc/zones_event.dart';
import 'package:greenhouse_app/presentation/bloc/zones_state.dart';

class ZonesBloc extends Bloc<ZonesEvent, ZonesState> {
  ZonesBloc(super.initialState) {
    on<LoadZonesEvent>((event, emit) async {
      emit(const ZonesLoadingState());
      try {
        // Simulate loading zones from a repository or service
        // await Future.delayed(const Duration(seconds: 2));
        final zones = ExampleData.cropZones;
        emit(ZonesLoadedState(zones: zones));
      } catch (e) {
        emit(ZonesErrorState(message: e.toString()));
      }
    });
    on<UpdateZoneDefinitionsEvent>((event, emit) {
      try {
        if (event.height > 0 && event.width > 0) {
          final zones = (state as ZonesLoadedState).zones;
          final zone = zones.firstWhere((z) => z.id == event.zoneId);
          zone.updateDefinitions(event.width, event.height);
          emit(ZonesLoadedState(zones: zones));
        }
      } catch (e) {
        emit(ZonesErrorState(message: e.toString()));
      }
    });
    on<UpdateSensorEvent>((event, emit) {
      try {
        final zones = (state as ZonesLoadedState).zones;
        final zone = zones.firstWhere((z) => z.id == event.zoneId);
        final sensor = zone.sensorManager.sensors.firstWhere((s) => s.id == event.sensorId);
        sensor.type = event.type;
        sensor.position = event.position;
        emit(ZonesLoadedState(zones: zones));
      } catch (e) {
        emit(ZonesErrorState(message: e.toString()));
      }
    });
    on<UpdateDeviceEvent>((event, emit) {
      try {
        final zones = (state as ZonesLoadedState).zones;
        final zone = zones.firstWhere((z) => z.id == event.zoneId);
        final device = zone.deviceController.devices.firstWhere((d) => d.id == event.deviceId);
        device.type = event.type;
        device.position = event.position;
        emit(ZonesLoadedState(zones: zones));
      } catch (e) {
        emit(ZonesErrorState(message: e.toString()));
      }
    });
  }
}
