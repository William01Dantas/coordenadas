import 'package:teste_rodovia/src/services/calculo_haversine.dart';
import 'package:teste_rodovia/src/services/obter_rodovia.dart';

Future<String?> enderecoProximo(double userLatitude, userLongitude) async {
  final enderecos = await obterInfoRodovia();
  double distanciaProxima = double.infinity;
  String? enderecosProximos;

  for (final endereco in enderecos) {
    final distancia = calculateDistance(
      userLatitude,
      userLongitude,
      endereco.latitude,
      endereco.longitude,
    );

    if (distancia < 0.09 && distancia < distanciaProxima) {
      distanciaProxima = distancia;
      enderecosProximos = enderecos.enderecosText;
    }
  }
}
