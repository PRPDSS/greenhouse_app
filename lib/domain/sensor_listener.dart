import 'package:greenhouse_app/domain/climate_data.dart';

abstract class SensorListener {
  /// Уведомление слушателя
  void onSensorUpdated(ClimateData climateData){}
}
