import 'package:flutter/foundation.dart';
import 'package:teste_rodovia/src/db/db.dart';
import 'package:teste_rodovia/src/widgets/buscar_localizacao_widget.dart';

class Endereco {
  final double latitude;
  final double longitude;

  Endereco({required this.latitude, required this.longitude});
}

Future<List<Endereco>> obterInfoRodovia() async {
  final position = await getUserLocation();
  if (position != null) {
    final infoRodovia = await DatabaseHelper().getRoadInfo(
      position.latitude,
      position.longitude,
    );
    if (infoRodovia != null) {
      final endereco = Endereco(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      return [endereco];
    } else {
      if (kDebugMode) {
        print('Nenhuma rodovia encontrada no banco de dados.');
      }
      return [];
    }
  }
  if (kDebugMode) {
    print('Posição do usuário não encontrada.');
  }
  return [];
}
