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
      if (zonesJson.isEmpty) {
        return Greenhouse(
          id: map['id'] as int,
          title: map['title'] as String,
          zones: [],
        );
      }

      final List<CropZone> zones = (jsonDecode(zonesJson) as List)
          .map((z) => CropZone.fromMap(z as Map<String, dynamic>))
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

  Future<void> deleteGreenhouse(int id) async {
    await _db.delete(
      'greenhouse',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> saveGreenhouse(Greenhouse greenhouse) async {
    final zonesJson = jsonEncode(greenhouse.zones.map((z) => z.toMap()).toList());
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
    if (zonesJson.isEmpty) {
      return Greenhouse(
        id: map['id'] as int,
        title: map['title'] as String,
        zones: [],
      );
    }

    final List<CropZone> zones = (jsonDecode(zonesJson) as List)
        .map((z) => CropZone.fromMap(z as Map<String, dynamic>))
        .toList();

    return Greenhouse(
      id: map['id'] as int,
      title: map['title'] as String,
      zones: zones,
    );
  }

  Future<CropZone> saveZone(int greenhouseId, CropZone zone) async {
    final greenhouse = await loadGreenhouse(greenhouseId);
    if (greenhouse == null) {
      throw Exception('Greenhouse not found');
    }

    // Добавляем или обновляем зону в списке
    final updatedZones = [...greenhouse.zones];
    final existingIndex = updatedZones.indexWhere((z) => z.id == zone.id);
    if (existingIndex != -1) {
      updatedZones[existingIndex] = zone; // Обновляем существующую зону
    } else {
      final newId = DateTime.now().millisecondsSinceEpoch;
      zone = zone.copyWith(id: newId); // Генерируем новый ID для новой зоны
      updatedZones.add(zone); // Добавляем новую зону
    }

    // Сохраняем обновленную теплицу
    await saveGreenhouse(greenhouse.copyWith(zones: updatedZones));

    return zone; // Возвращаем сохраненную зону
  }

  Future<void> deleteZone(int greenhouseId, int zoneId) async {
    final greenhouse = await loadGreenhouse(greenhouseId);
    if (greenhouse == null) {
      throw Exception('Greenhouse not found');
    }

    // Удаляем зону из списка
    final updatedZones = greenhouse.zones.where((z) => z.id != zoneId).toList();

    // Сохраняем обновленную теплицу
    await saveGreenhouse(greenhouse.copyWith(zones: updatedZones));
  }
}
