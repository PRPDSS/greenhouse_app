import 'package:greenhouse_app/domain/crop_zone.dart';

class Greenhouse {
  final int id;
  final String title;
  List<CropZone> zones;

  Greenhouse({required this.id, required this.title, this.zones = const []});

  toJson() {
    return '''
    {
      "id": $id,
      "title": "$title",
      "zones": ${zones.map((zone) => zone.toMap()).toList()}
    }
    ''';
  }

  factory Greenhouse.fromMap(Map<String, dynamic> json) {
    return Greenhouse(
      id: json['id'],
      title: json['title'],
      zones:
          (json['zones'] as List)
              .map((zone) => CropZone.fromMap(zone))
              .toList(),
    );
  }
}
