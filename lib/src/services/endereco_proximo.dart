import 'package:flutter/foundation.dart';
import 'package:teste_rodovia/src/services/calculo_distancia.dart';
import 'package:teste_rodovia/src/services/obter_rodovia.dart';
import 'package:teste_rodovia/src/services/verifica_coordenadas_services.dart';

Future<String?> enderecoProximo(String userLatitude, String userLongitude) async {
  final rodoviasEncontradas = await verificarCoordenadasNoBanco(userLatitude, userLongitude, );

  if (rodoviasEncontradas.isNotEmpty) {
    final rodovia = rodoviasEncontradas.first;
    return "Rodovia: ${rodovia.sgRodovia}, KM: ${rodovia.nuKm}, Trecho: ${rodovia.cdTrecho}, Distância: ${rodovia.distancia}";
  } else {
    return "Nenhuma rodovia encontrada.";
  }

  // final enderecos = await obterInfoRodovia();
  // double distanciaProxima = double.infinity;
  // String? enderecoProximo;
  //
  // for (final endereco in enderecos) {
  //   final distancia = calculateDistance(
  //     userLatitude,
  //     userLongitude,
  //     endereco.latitude,
  //     endereco.longitude,
  //   );
  //
  //   if (distancia <= raio && distancia < distanciaProxima) {
  //     distanciaProxima = distancia;
  //     if (kDebugMode) {
  //       print(distanciaProxima);
  //     }
  //     enderecoProximo = "Latitude: ${endereco.latitude}, Longitude: ${endereco.longitude}";
  //   }
  // }
  //
  // if (enderecoProximo != null) {
  //   return "Endereços mais próximos: $enderecoProximo";
  // }else {
  //   if (kDebugMode) {
  //     print('Nenhum endereço próximo encontrado.');
  //   }
  //   return "Nenhum endereço próximo encontrado";
  // }
}
