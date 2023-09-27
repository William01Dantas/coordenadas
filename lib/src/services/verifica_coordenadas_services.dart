import 'package:teste_rodovia/src/db/db.dart';

Future<String> verificarCoordenadasNoBanco(String latitude, String longitude) async {
  final db = await DatabaseHelper().database;
  final result = await db.rawQuery('''
    SELECT SGRODOVIA, NUKM, CDTRECHO
    FROM ETRECOORDENADASROD
    WHERE VLLATITUDE = ? AND VLLONGITUDE = ?
  ''', [latitude, longitude]);

  if (result.isNotEmpty) {
    final row = result.first;
    return "Rodovia: ${row['SGRODOVIA']}, NUKM: ${row['NUKM']}, CDTRECHO: ${row['CDTRECHO']}";
  } else {
    print('Coordenadas não encontradas no banco de dados.');
    return "Coordenadas não encontradas no banco de dados";
  }
}