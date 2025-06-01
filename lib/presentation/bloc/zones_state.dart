import 'package:greenhouse_app/domain/crop_zone.dart';

abstract class ZonesState {
  const ZonesState();
}

class ZonesInitialState extends ZonesState {
  const ZonesInitialState();
}
class ZonesLoadingState extends ZonesState {
  const ZonesLoadingState();
}
class ZonesLoadedState extends ZonesState {
  final List<CropZone> zones;

  const ZonesLoadedState({required this.zones});
}

class ZonesErrorState extends ZonesState {
  final String message;

  const ZonesErrorState({required this.message});
}
