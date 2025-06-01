import 'package:flutter/material.dart';

class Crop {
  final String title;
  final Image? image;
  final List<double> _temperature;
  final List<double> _humidity;
  final List<double> _ligntning;
  final List<double> _wateringFrequency;
  final List<double> _wateringLevel;
  final int _growthTime;

  Crop({
    required this.title,
    this.image,
    required List<double> temperature,
    required List<double> humidity,
    required List<double> ligntning,
    required List<double> wateringFrequency,
    required List<double> wateringLevel,
    required int growthTime,
  }) : _temperature = temperature,
       _humidity = humidity,
       _ligntning = ligntning,
       _wateringFrequency = wateringFrequency,
       _wateringLevel = wateringLevel,
       _growthTime = growthTime;

  String toJson() {
    return '''
    {
      "title": "$title",
      "temperature": ${_temperature.toString()},
      "humidity": ${_humidity.toString()},
      "ligntning": ${_ligntning.toString()},
      "wateringFrequency": ${_wateringFrequency.toString()},
      "wateringLevel": ${_wateringLevel.toString()}
      "growthTime": $_growthTime
    }
    ''';
  }

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      title: json['title'] as String,
      temperature: List<double>.from(json['temperature'] as List),
      humidity: List<double>.from(json['humidity'] as List),
      ligntning: List<double>.from(json['ligntning'] as List),
      wateringFrequency: List<double>.from(json['wateringFrequency'] as List),
      wateringLevel: List<double>.from(json['wateringLevel'] as List),
      growthTime: json['growthTime'] as int,
    );
  }
}
