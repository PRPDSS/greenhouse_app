import 'package:greenhouse_app/domain/crop_zone.dart';

abstract class GreenhouseEvent {
  const GreenhouseEvent();
}

class CreateGreenhouseEvent extends GreenhouseEvent {
  final String title;
  const CreateGreenhouseEvent({required this.title});
}

class LoadGreenhousesEvent extends GreenhouseEvent {
  const LoadGreenhousesEvent();
}

class AddZoneEvent extends GreenhouseEvent {
  final int greenhouseId;
  final CropZone zone;

  const AddZoneEvent({required this.greenhouseId, required this.zone});
}

class UpdateZoneEvent extends GreenhouseEvent {
  final int greenhouseId;
  final int zoneId;
  final CropZone zone;

  const UpdateZoneEvent({
    required this.greenhouseId,
    required this.zoneId,
    required this.zone,
  });
}