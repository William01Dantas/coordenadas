import 'package:flutter/foundation.dart';
import 'package:teste_rodovia/src/db/db.dart';
import 'package:teste_rodovia/src/services/calculo_distancia.dart';

class RodoviasInfoCalc{
  late final String sgRodovia;
  late final double nuKm;
  late final int cdTrecho;
  late final double distancia;

  RodoviasInfoCalc({
    required this.sgRodovia,
    required this.nuKm,
    required this.cdTrecho,
    required this.distancia,
  });
}

Future<List<RodoviasInfoCalc>> verificarCoordenadasNoBanco(String latitude, String longitude) async {
  final db = await DatabaseHelper().database;
  final result = await db.rawQuery('''
    SELECT SGRODOVIA, NUKM, CDTRECHO, VLLATITUDE, VLLONGITUDE
    FROM ETRECOORDENADASROD
  ''');

  final userLat = double.parse(latitude);
  final userLong = double.parse(longitude);

  final List<RodoviasInfoCalc> rodoviasEncontradas = [];

  print(rodoviasEncontradas);

  for (final row in result) {
    final rodoviaLat = row['VLLATITUDE'] as double;
    final rodoviaLong = row['VLLONGITUDE'] as double;

    final distancia = calculateDistance(userLat, userLong, rodoviaLat, rodoviaLong);

    if (distancia <= 0.10) {
      final rodoviasInfoCalc = RodoviasInfoCalc(
        sgRodovia: row['SGRODOVIA'] as String,
        nuKm: row['NUKM'] as double,
        cdTrecho: row['CDTRECHO'] as int,
        distancia: distancia * 1000,
      );
      rodoviasEncontradas.add(rodoviasInfoCalc);
    }
  }

  if (rodoviasEncontradas.isNotEmpty) {
    return rodoviasEncontradas;
  } else {
    if (kDebugMode) {
      print('Coordenadas não encontradas no banco de dados.');
    }
    return [];
  }
}