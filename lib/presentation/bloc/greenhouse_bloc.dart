import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/data/database_service.dart';
import 'package:greenhouse_app/data/greenhouse_repository.dart';
import 'package:greenhouse_app/domain/greenhouse.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';

class GreenhouseBloc extends Bloc<GreenhouseEvent, GreenhouseState> {
  late GreenhouseRepository _repository;

  GreenhouseBloc() : super(const GreenhouseInitialState()) {
    on<LoadGreenhousesEvent>(_onLoadGreenhousesEvent);
    on<CreateGreenhouseEvent>(_onCreateGreenhouseEvent);
    on<DeleteGreenhouseEvent>(_onDeleteGreenhouseEvent);
    on<SaveZoneEvent>(_onSaveZoneEvent);
    on<DeleteZoneEvent>(_onDeleteZoneEvent);
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
        emit(
          GreenhouseErrorState(
            message: 'Greenhouse with this title already exists',
          ),
        );
        return;
      }
      final greenhouse = await _repository.createGreenhouse(event.title);
      emit(GreenhousesLoadedState(greenhouses: [...greenhouses, greenhouse]));
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onDeleteGreenhouseEvent(
    DeleteGreenhouseEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    if (state is! GreenhousesLoadedState) {
      emit(GreenhouseErrorState(message: 'Invalid state for greenhouse deletion'));
      return;
    }

    final currentState = state as GreenhousesLoadedState;
    try {
      // Удаляем теплицу из базы данных
      await _repository.deleteGreenhouse(event.id);

      // Обновляем состояние без удаленной теплицы
      final updatedGreenhouses =
          currentState.greenhouses.where((g) => g.id != event.id).toList();

      emit(GreenhousesLoadedState(greenhouses: updatedGreenhouses));
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onSaveZoneEvent(
    SaveZoneEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    if (state is! GreenhousesLoadedState) {
      emit(GreenhouseErrorState(message: 'Invalid state for zone saving'));
      return;
    }

    final currentState = state as GreenhousesLoadedState;
    try {
      // Сохраняем зону в базе данных
      final zone = event.zone;
      final savedZone = await _repository.saveZone(event.greenhouseId, zone);

      // Обновляем состояние с новой зоной
      late List<Greenhouse> updatedGreenhouses;
      if (zone.id == -1) {
        updatedGreenhouses =
            currentState.greenhouses.map((greenhouse) {
              if (greenhouse.id == event.greenhouseId) {
                return greenhouse.copyWith(
                  zones: [...greenhouse.zones, savedZone],
                );
              }
              return greenhouse;
            }).toList();
      } else {
        updatedGreenhouses =
            currentState.greenhouses.map((greenhouse) {
              if (greenhouse.id == event.greenhouseId) {
                return greenhouse.copyWith(
                  zones:
                      greenhouse.zones.map((z) {
                        return z.id == savedZone.id ? savedZone : z;
                      }).toList(),
                );
              }
              return greenhouse;
            }).toList();
      }

      emit(GreenhousesLoadedState(greenhouses: updatedGreenhouses));
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onDeleteZoneEvent(
    DeleteZoneEvent event,
    Emitter<GreenhouseState> emit,
  ) async {
    if (state is! GreenhousesLoadedState) {
      emit(GreenhouseErrorState(message: 'Invalid state for zone deletion'));
      return;
    }

    final currentState = state as GreenhousesLoadedState;
    try {
      // Удаляем зону из базы данных
      await _repository.deleteZone(event.greenhouseId, event.zoneId);

      // Обновляем состояние без удаленной зоны
      final updatedGreenhouses =
          currentState.greenhouses.map((greenhouse) {
            if (greenhouse.id == event.greenhouseId) {
              return greenhouse.copyWith(
                zones:
                    greenhouse.zones
                        .where((z) => z.id != event.zoneId)
                        .toList(),
              );
            }
            return greenhouse;
          }).toList();

      emit(GreenhousesLoadedState(greenhouses: updatedGreenhouses));
    } catch (e) {
      emit(GreenhouseErrorState(message: e.toString()));
    }
  }
}
