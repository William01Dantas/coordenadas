import 'package:teste_rodovia/src/services/verifica_coordenadas_services.dart';

Future<List<String?>> enderecoProximo(String userLatitude, String userLongitude) async {
  final rodoviasEncontradas = await verificarCoordenadasNoBanco(userLatitude, userLongitude, );

  if (rodoviasEncontradas.isNotEmpty) {
    final List<String?> enderecos = [];
    for (final rodovia in rodoviasEncontradas){
      enderecos.add("Rodovia: ${rodovia.sgRodovia}, KM: ${rodovia.nuKm}, Trecho: ${rodovia.cdTrecho}, Distância: ${rodovia.distancia}");
    }
    return enderecos;
  } else {
    return ["Nenhuma rodovia encontrada."];
  }
}
