import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/data/crops_repository.dart';
import 'package:greenhouse_app/domain/crop.dart';

sealed class CropsState {
  const CropsState();
}

class CropsInitial extends CropsState {
  const CropsInitial();
}

class CropsLoading extends CropsState {
  const CropsLoading();
}

class CropsLoaded extends CropsState {
  final List<Crop> crops;
  const CropsLoaded(this.crops);
}

class CropsError extends CropsState {
  final String message;
  const CropsError(this.message);
}

class CropsCubit extends Cubit<CropsState> {
  final CropsRepository _repository;

  CropsCubit({required CropsRepository repository})
      : _repository = repository,
        super(const CropsInitial());

  Future<void> loadCrops() async {
    emit(const CropsLoading());
    try {
      final crops = await _repository.loadCrops();
      emit(CropsLoaded(crops));
    } catch (e) {
      emit(CropsError(e.toString()));
    }
  }

  Future<void> addCrop(Crop crop) async {
    final currentState = state;
    if (currentState is CropsLoaded) {
      try {
        await _repository.saveCrop(crop);
        final crops = await _repository.loadCrops();
        emit(CropsLoaded(crops));
      } catch (e) {
        emit(CropsError(e.toString()));
      }
    }
  }

  Future<void> deleteCrop(int id) async {
    final currentState = state;
    if (currentState is CropsLoaded) {
      try {
        await _repository.deleteCrop(id);
        final crops = await _repository.loadCrops();
        emit(CropsLoaded(crops));
      } catch (e) {
        emit(CropsError(e.toString()));
      }
    }
  }

  Future<Crop?> getCrop(int id) async {
    try {
      return await _repository.loadCrop(id);
    } catch (e) {
      emit(CropsError(e.toString()));
      return null;
    }
  }
} 