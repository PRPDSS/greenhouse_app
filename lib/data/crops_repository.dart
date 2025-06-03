import 'dart:convert';
import 'package:greenhouse_app/data/database_service.dart';
import 'package:greenhouse_app/domain/crop.dart';
import 'package:sqflite/sqflite.dart';

class CropsRepository {
  late Database _db;
  CropsRepository();

  Future<List<Crop>> loadCrops() async {
    _db = await DatabaseService.database;

    final List<Map<String, dynamic>> maps = await _db.query('crops');
    return maps.map((map) {
      final cropMap = Map<String, dynamic>.from(map);
      cropMap['temperature'] = jsonDecode(map['temperature'] as String);
      cropMap['humidity'] = jsonDecode(map['humidity'] as String);
      cropMap['lightning'] = jsonDecode(map['lightning'] as String);
      cropMap['wateringFrequency'] = jsonDecode(
        map['wateringFrequency'] as String,
      );
      cropMap['wateringLevel'] = jsonDecode(map['wateringLevel'] as String);
      return Crop.fromMap(cropMap);
    }).toList();
  }

  Future<Crop?> loadCrop(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'crops',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final map = maps.first;
    final cropMap = Map<String, dynamic>.from(map);
    cropMap['temperature'] = jsonDecode(map['temperature'] as String);
    cropMap['humidity'] = jsonDecode(map['humidity'] as String);
    cropMap['lightning'] = jsonDecode(map['lightning'] as String);
    cropMap['wateringFrequency'] = jsonDecode(
      map['wateringFrequency'] as String,
    );
    cropMap['wateringLevel'] = jsonDecode(map['wateringLevel'] as String);
    return Crop.fromMap(cropMap);
  }

  Future<void> saveCrop(Crop crop) async {
    final cropMap = crop.toMap();
    cropMap['temperature'] = jsonEncode(cropMap['temperature']);
    cropMap['humidity'] = jsonEncode(cropMap['humidity']);
    cropMap['lightning'] = jsonEncode(cropMap['lightning']);
    cropMap['wateringFrequency'] = jsonEncode(cropMap['wateringFrequency']);
    cropMap['wateringLevel'] = jsonEncode(cropMap['wateringLevel']);

    await _db.insert(
      'crops',
      cropMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String> getCropTitle(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'crops',
      columns: ['title'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return '';

    return maps.first['title'] as String;
  }

  Future<void> deleteCrop(int id) async {
    await _db.delete('crops', where: 'id = ?', whereArgs: [id]);
  }
}
