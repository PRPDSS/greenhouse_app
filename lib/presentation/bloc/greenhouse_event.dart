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

class DeleteGreenhouseEvent extends GreenhouseEvent {
  final int id;
  const DeleteGreenhouseEvent({required this.id});
}

class SaveZoneEvent extends GreenhouseEvent {
  final int greenhouseId;
  final int? zoneId;
  final CropZone zone;

  const SaveZoneEvent({
    required this.greenhouseId,
    this.zoneId,
    required this.zone,
  });
}

class DeleteZoneEvent extends GreenhouseEvent {
  final int greenhouseId;
  final int zoneId;

  const DeleteZoneEvent({required this.greenhouseId, required this.zoneId});
}
