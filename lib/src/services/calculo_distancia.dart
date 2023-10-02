import 'dart:math';

double calculaDistancia(double lat1, double lon1, double lat2, double lon2) {
  // Fórmula de distância euclidiana
  final double distance = sqrt(pow(lat1 - lat2, 2) + pow(lon1 - lon2, 2));

  return distance;
}
