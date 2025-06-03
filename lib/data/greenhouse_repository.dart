import 'dart:convert';

import 'package:greenhouse_app/domain/crop_zone.dart';
import 'package:greenhouse_app/domain/greenhouse.dart';
import 'package:sqflite/sqflite.dart';

class GreenhouseRepository {
  final Database _db;
  const GreenhouseRepository({required Database db}) : _db = db;

  Future<List<Greenhouse>> loadGreenhouses() async {
    final List<Map<String, dynamic>> maps = await _db.query('greenhouse');
    return maps.map((map) {
      final String zonesJson = map['zonesJson'] as String;
      final List<CropZone> zones =
          zonesJson
              .split(',')
              .map((z) => CropZone.fromMap(jsonDecode(z)))
              .toList();

      return Greenhouse(
        id: map['id'] as int,
        title: map['title'] as String,
        zones: zones,
      );
    }).toList();
  }

  Future<Greenhouse> createGreenhouse(String title) async {
    final greenhouse = Greenhouse(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      zones: [],
    );
    await saveGreenhouse(greenhouse);
    return greenhouse;
  }

  Future<void> saveGreenhouse(Greenhouse greenhouse) async {
    final String zonesJson = greenhouse.zones.map((z) => z.toMap()).join(',');
    await _db.insert('greenhouse', {
      'id': greenhouse.id,
      'title': greenhouse.title,
      'zonesJson': zonesJson,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Greenhouse?> loadGreenhouse(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'greenhouse',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final Map<String, dynamic> map = maps.first;
    final String zonesJson = map['zonesJson'] as String;
    final List<CropZone> zones =
        zonesJson
            .split(',')
            .map((z) => CropZone.fromMap(jsonDecode(z)))
            .toList();

    return Greenhouse(
      id: map['id'] as int,
      title: map['title'] as String,
      zones: zones,
    );
  }
}
