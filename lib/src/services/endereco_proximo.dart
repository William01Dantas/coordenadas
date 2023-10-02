import 'package:teste_rodovia/src/services/verifica_coordenadas_services.dart';

Future<String?> enderecoProximo(String userLatitude, String userLongitude) async {
  final rodoviasEncontradas = await verificarCoordenadasNoBanco(userLatitude, userLongitude, );

  if (rodoviasEncontradas.isNotEmpty) {
    final rodovia = rodoviasEncontradas.first;
    return "Rodovia: ${rodovia.sgRodovia}, KM: ${rodovia.nuKm}, Trecho: ${rodovia.cdTrecho}, Distância: ${rodovia.distancia}";
  } else {
    return "Nenhuma rodovia encontrada.";
  }
}
