import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/data/database_service.dart';
import 'package:greenhouse_app/data/greenhouse_repository.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';

class GreenhouseBloc extends Bloc<GreenhouseEvent, GreenhouseState> {
  late GreenhouseRepository _repository;

  GreenhouseBloc() : super(const GreenhouseInitialState()) {
    on<LoadGreenhousesEvent>(_onLoadGreenhousesEvent);
    on<CreateGreenhouseEvent>(_onCreateGreenhouseEvent);
    on<UpdateZoneEvent>(_onUpdateZoneEvent);
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
      final greenhouses = await _repository.loadGreenhouses();
      if (greenhouses.any((g) => g.title == event.title)) {
        print('Greenhouse ${event.title} already exist');
        return;
      }
      final greenhouse = await _repository.createGreenhouse(event.title);
      greenhouses.add(greenhouse);
      emit(
        GreenhousesLoadedState(
          greenhouses: greenhouses,
          selectedGreenhouseId: greenhouse.id,
        ),
      );
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }


  FutureOr<void> _onUpdateZoneEvent(
    UpdateZoneEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    try {
      if (state is GreenhousesLoadedState) {
        final currentState = state as GreenhousesLoadedState;
        final greenhouse = currentState.greenhouses.firstWhere(
          (g) => g.id == event.greenhouseId,
          orElse: () => throw Exception('Greenhouse not found'),
        );

        final updatedZones = greenhouse.zones.map((zone) {
          if (zone.id == event.zoneId) {
            return event.zone; // Update the zone
          }
          return zone; // Keep the existing zone
        }).toList();

        final updatedGreenhouse = greenhouse.copyWith(zones: updatedZones);
        await _repository.saveGreenhouse(updatedGreenhouse);

        emit(GreenhousesLoadedState(
          greenhouses: currentState.greenhouses.map((g) {
            if (g.id == event.greenhouseId) {
              return updatedGreenhouse;
            }
            return g;
          }).toList(),
          selectedGreenhouseId: currentState.selectedGreenhouseId,
        ));
      } else {
        emit(GreenhouseErrorState(message: 'No greenhouses loaded'));
      }
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }
}
