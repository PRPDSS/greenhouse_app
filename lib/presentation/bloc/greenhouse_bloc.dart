import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/data/example_data.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';

class GreenhouseBloc extends Bloc<GreenhouseEvent, GreenhouseState> {
  GreenhouseBloc(super.initialState) {
    on<LoadGreenhouseEvent>((event, emit) async {
      emit(const GreenhouseLoadingState());
      try {
        final greenhouse = ExampleData.greenhouse;
        emit(GreenhouseLoadedState(greenhouse: greenhouse));
      } catch (e) {
        emit(GreenhouseErrorState(message: e.toString()));
      }
    });

    on<UpdateZoneDefinitionsEvent>((event, emit) {
      try {
        if (event.height > 0 && event.width > 0) {
          final greenhouse = (state as GreenhouseLoadedState).greenhouse;
          final zone = greenhouse.zones.firstWhere((z) => z.id == event.zoneId);
          zone.updateDefinitions(event.width, event.height);
          emit(GreenhouseLoadedState(greenhouse: greenhouse));
        }
      } catch (e) {
        emit(GreenhouseErrorState(message: e.toString()));
      }
    });

    on<UpdateZoneEvent>((event, emit) {
      try {
        emit(state);
      } catch (e) {
        emit(GreenhouseErrorState(message: e.toString()));
      }
    });

    on<UpdateSensorEvent>((event, emit) {
      try {
        final greenhouse = (state as GreenhouseLoadedState).greenhouse;
        final zone = greenhouse.zones.firstWhere((z) => z.id == event.zoneId);
        final sensor = zone.sensorManager.sensors.firstWhere(
          (s) => s.id == event.sensorId,
        );
        sensor.type = event.type;
        sensor.position = event.position;
        emit(GreenhouseLoadedState(greenhouse: greenhouse));
      } catch (e) {
        emit(GreenhouseErrorState(message: e.toString()));
      }
    });

    on<UpdateDeviceEvent>((event, emit) {
      try {
        final greenhouse = (state as GreenhouseLoadedState).greenhouse;
        final zone = greenhouse.zones.firstWhere((z) => z.id == event.zoneId);
        final device = zone.deviceController.devices.firstWhere(
          (d) => d.id == event.deviceId,
        );
        device.type = event.type;
        device.position = event.position;
        emit(GreenhouseLoadedState(greenhouse: greenhouse));
      } catch (e) {
        emit(GreenhouseErrorState(message: e.toString()));
      }
    });
  }
} 