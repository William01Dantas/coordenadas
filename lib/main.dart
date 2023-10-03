import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teste_rodovia/app.dart';
import 'package:teste_rodovia/src/db/db.dart';
import 'package:teste_rodovia/src/services/location_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseHelper = DatabaseHelper();

  try {
    // Carrega os dados do arquivo JSON existente
    final jsonString = await rootBundle.loadString('assets/etrecoordenadasprod.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    // Inicializa o banco de dados com os dados do JSON existente
    await databaseHelper.initDatabase(jsonData);

    // Carrega os dados do novo arquivo JSON (se existir)
    final newJsonString = await rootBundle.loadString('assets/etrecoordenadasrodsc110.json');
    final newJsonData = jsonDecode(newJsonString) as Map<String, dynamic>;

    // Insere os dados do novo JSON no banco de dados
    if (newJsonData.containsKey('ETRECOORDENADASROD')) {
      final List<dynamic> newdataList = newJsonData['ETRECOORDENADASROD'];
      for (final data in newdataList) {
        await (await databaseHelper.database).insert('ETRECOORDENADASROD', data);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erro ao inicializar o banco de dados: $e');
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocalizacaoUsuarioProvider(),
      child: const MyApp(),
    ),
  );
}
