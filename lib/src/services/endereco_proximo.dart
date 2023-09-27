import 'package:teste_rodovia/src/services/calculo_distancia.dart';
import 'package:teste_rodovia/src/services/obter_rodovia.dart';

Future<String?> enderecoProximo(double userLatitude, userLongitude) async {
  final enderecos = await obterInfoRodovia();
  double distanciaProxima = double.infinity;
  String? enderecoProximo;

  for (final endereco in enderecos) {
    final distancia = calculateDistance(
      userLatitude,
      userLongitude,
      endereco.latitude,
      endereco.longitude,
    );

    if (distancia <= 0.09 && distancia < distanciaProxima) {
      distanciaProxima = distancia;
      print(distanciaProxima);
      enderecoProximo = "Latitude: ${endereco.latitude}, Longitude: ${endereco.longitude}";
    }
  }

  if (enderecoProximo != null) {
    return "Endereços mais próximos: $enderecoProximo";
  }else {
    print('Nenhum endereço próximo encontrado.');
    return "Nenhum endereço próximo encontrado";
  }
}
