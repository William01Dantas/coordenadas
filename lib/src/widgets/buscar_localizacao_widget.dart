import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> getUserLocation() async {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  try {
    final Position position = await geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        forceLocationManager: true,
      ),
    );
    return position;
  } catch (e) {
    if (kDebugMode) {
      print("Erro ao obter a localização do usuário: $e");
    }
    return null;
  }
}
