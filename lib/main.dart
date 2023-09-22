import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teste_rodovia/app.dart';
import 'package:teste_rodovia/src/db/db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseHelper = DatabaseHelper();
  try {
    final jsonString = await rootBundle.loadString('assets/etrecoordenadasprod.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    await databaseHelper.initDatabase(jsonData);
  } catch (e) {
    if (kDebugMode) {
      print('Erro ao inicializar o banco de dados: $e');
    }
  }

  runApp(const MyApp());
}
