import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:teste_rodovia/src/widgets/buscar_localizacao_widget.dart';

Future<void> permissaoLocalizacao() async {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  final LocationPermission permission = await geolocator.checkPermission();

  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
      final position = await getUserLocation();
      if (position != null){
        if (kDebugMode) {
          print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        }
      }
  } else {
    final LocationPermission newPermission = await geolocator.requestPermission();

    if (newPermission == LocationPermission.always ||
        newPermission == LocationPermission.whileInUse) {
      final position = await getUserLocation();
      if (position != null){
        if (kDebugMode) {
          print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        }
      }
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(
          content: Text('A permissão de localização foi negada.'),
        ),
      );
    }
  }
}
