import 'dart:math';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // Raio médio da Terra em quilômetros

  double radians(double degrees) {
    return degrees * (pi / 180.0);
  }

  // Converter graus para radianos
  lat1 = radians(lat1);
  lon1 = radians(lon1);
  lat2 = radians(lat2);
  lon2 = radians(lon2);

  // Diferença de latitude e longitude
  final double dLat = lat2 - lat1;
  final double dLon = lon2 - lon1;

  // Fórmula de Haversine
  final double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final double distance = earthRadius * c;

  return distance;
}
