import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/data/database_service.dart';
import 'package:greenhouse_app/data/greenhouse_repository.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';

class GreenhouseBloc extends Bloc<GreenhouseEvent, GreenhouseState> {
  late GreenhouseRepository _repository;

  GreenhouseBloc()
      :
        super(const GreenhouseInitialState()) {
    on<LoadGreenhousesEvent>(_onLoadGreenhousesEvent);
    on<LoadGreenhouseEvent>(_onLoadGreenhouseEvent);
    on<CreateGreenhouseEvent>(_onCreateGreenhouseEvent);
    on<UpdateZoneDefinitionsEvent>(_onUpdateZoneDefinitionsEvent);
    on<UpdateZoneEvent>(_onUpdateZoneEvent);
    on<UpdateSensorEvent>(_onUpdateSensorEvent);
    on<UpdateDeviceEvent>(_onUpdateDeviceEvent);
  }

  FutureOr<void> _onLoadGreenhousesEvent(
    LoadGreenhousesEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    final db = await DatabaseService.database;
    _repository = GreenhouseRepository(db: db);
    emit(const GreenhouseLoadingState());
    try {
      final greenhouses = await _repository.loadGreenhouses();
      emit(GreenhousesLoadedState(greenhouses: greenhouses));
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onCreateGreenhouseEvent(
    CreateGreenhouseEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    emit(const GreenhouseLoadingState());
    try {
      final greenhouse = await _repository.createGreenhouse(event.title);
      emit(GreenhouseLoadedState(greenhouse: greenhouse));
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadGreenhouseEvent(
    LoadGreenhouseEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    emit(const GreenhouseLoadingState());
    try {
      final greenhouse = await _repository.loadGreenhouse(event.greenhouseId);
      if (greenhouse != null) {
        emit(GreenhouseLoadedState(greenhouse: greenhouse));
      } else {
        emit(const GreenhouseErrorState(message: 'Greenhouse not found'));
      }
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateZoneDefinitionsEvent(
    UpdateZoneDefinitionsEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    try {
      if (event.height > 0 && event.width > 0) {
        final currentState = state as GreenhouseLoadedState;
        final greenhouse = currentState.greenhouse;
        final zone = greenhouse.zones.firstWhere((z) => z.id == event.zoneId);
        zone.updateDefinitions(event.width, event.height);
        await _repository.saveGreenhouse(greenhouse);
        emit(GreenhouseLoadedState(greenhouse: greenhouse));
      }
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateZoneEvent(
    UpdateZoneEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    try {
      if (state is GreenhouseLoadedState) {
        final greenhouse = (state as GreenhouseLoadedState).greenhouse;
        await _repository.saveGreenhouse(greenhouse);
        emit(GreenhouseLoadedState(greenhouse: greenhouse));
      }
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateSensorEvent(
    UpdateSensorEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    try {
      final greenhouse = (state as GreenhouseLoadedState).greenhouse;
      final zone = greenhouse.zones.firstWhere((z) => z.id == event.zoneId);
      final sensor = zone.sensorManager.sensors.firstWhere(
        (s) => s.id == event.sensorId,
      );
      sensor.type = event.type;
      sensor.position = event.position;
      await _repository.saveGreenhouse(greenhouse);
      emit(GreenhouseLoadedState(greenhouse: greenhouse));
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateDeviceEvent(
    UpdateDeviceEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    try {
      final greenhouse = (state as GreenhouseLoadedState).greenhouse;
      final zone = greenhouse.zones.firstWhere((z) => z.id == event.zoneId);
      final device = zone.deviceController.devices.firstWhere(
        (d) => d.id == event.deviceId,
      );
      device.type = event.type;
      device.position = event.position;
      await _repository.saveGreenhouse(greenhouse);
      emit(GreenhouseLoadedState(greenhouse: greenhouse));
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }
}
