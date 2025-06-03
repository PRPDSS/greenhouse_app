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

class GreenhouseLoadedState extends GreenhouseState {
  final Greenhouse greenhouse;

  const GreenhouseLoadedState({required this.greenhouse});
}

class GreenhouseErrorState extends GreenhouseState {
  final String message;

  const GreenhouseErrorState({required this.message});
} 