import 'package:flutter/material.dart';

class Crop {
  final int id;
  final String title;
  final Image? image;
  final List<double> _temperature;
  final List<double> _humidity;
  final List<double> _lightning;
  final List<double> _wateringFrequency;
  final List<double> _wateringLevel;
  final int _growthTime;

  Crop({
    required this.id,
    required this.title,
    this.image,
    required List<double> temperature,
    required List<double> humidity,
    required List<double> lightning,
    required List<double> wateringFrequency,
    required List<double> wateringLevel,
    required int growthTime,
  }) : _temperature = temperature,
       _humidity = humidity,
       _lightning = lightning,
       _wateringFrequency = wateringFrequency,
       _wateringLevel = wateringLevel,
       _growthTime = growthTime;

  List<double> get temperature => List.unmodifiable(_temperature);
  List<double> get humidity => List.unmodifiable(_humidity);
  List<double> get lightning => List.unmodifiable(_lightning);
  List<double> get wateringFrequency => List.unmodifiable(_wateringFrequency);
  List<double> get wateringLevel => List.unmodifiable(_wateringLevel);
  int get growthTime => _growthTime;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'temperature': _temperature,
      'humidity': _humidity,
      'lightning': _lightning,
      'wateringFrequency': _wateringFrequency,
      'wateringLevel': _wateringLevel,
      'growthTime': _growthTime,
    };
  }

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      id: map['id'] as int,
      title: map['title'] as String,
      temperature: List<double>.from(map['temperature'] as List),
      humidity: List<double>.from(map['humidity'] as List),
      lightning: List<double>.from(map['lightning'] as List),
      wateringFrequency: List<double>.from(map['wateringFrequency'] as List),
      wateringLevel: List<double>.from(map['wateringLevel'] as List),
      growthTime: map['growthTime'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Crop && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
