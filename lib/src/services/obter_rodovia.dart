import 'package:teste_rodovia/src/db/db.dart';
import 'package:teste_rodovia/src/widgets/buscar_localizacao_widget.dart';

Future<String> obterInfoRodovia() async {
  final position = await getUserLocation();
  if (position != null) {
    final infoRodovia = await DatabaseHelper().getRoadInfo(position.latitude, position.longitude);
    if (infoRodovia != null) {
      return "Rodovia: ${infoRodovia['SGRODOVIA']}, NUKM: ${infoRodovia['NUKM']}, CDTRECHO: ${infoRodovia['CDTRECHO']}";
    } else {
      return "Rodovia não encontrada";
    }
  }
  return "";
}