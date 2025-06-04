import 'package:greenhouse_app/domain/greenhouse.dart';

abstract class GreenhouseState {
  const GreenhouseState();
}

class GreenhouseInitialState extends GreenhouseState {
  const GreenhouseInitialState();
}

class GreenhouseLoadingState extends GreenhouseState {
  const GreenhouseLoadingState();
}

class GreenhousesLoadedState extends GreenhouseState {
  final List<Greenhouse> greenhouses;
  final int? selectedGreenhouseId;

  const GreenhousesLoadedState({
    required this.greenhouses,
    this.selectedGreenhouseId,
  });
}

class GreenhouseErrorState extends GreenhouseState {
  final String message;

  const GreenhouseErrorState({required this.message});
}
