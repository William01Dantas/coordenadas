import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    throw Exception('Banco de dados não inicializado');
  }

  Future<Map<String, dynamic>> loadJsonData() async {
    final jsonString = await rootBundle.loadString('assets/etrecoordenadasprod.json');
    final jsonData = jsonDecode(jsonString);
    if (kDebugMode) {
      print('JSON carregando: $jsonData');
    }
    return jsonData;
  }

  // Função para inicializar o banco de dados
  Future<void> initDatabase(Map<String, dynamic> jsonData) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath,
        'ETRECOORDENADASROD.db'); // Defina o nome do seu banco de dados aqui

    _database = await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE IF NOT EXISTS ETRECOORDENADASROD (
  id INTEGER PRIMARY KEY,
  SGRODOVIA TEXT,
  NUSEQCOORD INTEGER,
  CDORGAOSETOR INTEGER,
  CDMUNICIPIO INTEGER,
  VLLATITUDE REAL,
  VLLONGITUDE REAL,
  VLALTITUDE REAL,
  NUKM REAL,
  CDTRECHO INTEGER,
  FLSENTIDO TEXT,
  CDSISTCOORDENADA INTEGER,
  VLCOORDENADAE REAL,
  VLCOORDENADAN REAL,
  VLCOORDENADAH INTEGER,
  NUUTMZONA INTEGER,
  FLLEVANTAMENTO TEXT,
  FLNOVOEIXO TEXT
)
''');
        // Verifique e adicione colunas ausentes, se necessário
        final expectedColumns = [
          'SGRODOVIA',
          'NUSEQCOORD',
          'CDORGAOSETOR',
          'CDMUNICIPIO',
          'VLLATITUDE',
          'VLLONGITUDE',
          'VLALTITUDE',
          'NUKM',
          'CDTRECHO',
          'FLSENTIDO',
          'CDSISTCOORDENADA',
          'VLCOORDENADAE',
          'VLCOORDENADAN',
          'VLCOORDENADAH',
          'NUUTMZONA',
          'FLLEVANTAMENTO',
          'FLNOVOEIXO',
        ];

        final existingColumns = await db.rawQuery('PRAGMA table_info(ETRECOORDENADASROD)');
        final existingColumnNames = existingColumns.map((column) => column['name'] as String).toList();

        for (final columnName in expectedColumns) {
          if (!existingColumnNames.contains(columnName)) {
            // A coluna está faltando, então a adicionamos
            await db.execute('ALTER TABLE ETRECOORDENADASROD ADD COLUMN $columnName');
          }
        }

        // Insira seus dados iniciais aqui, se necessário.
        if (jsonData.containsKey('ETRECOORDENADASROD')) {
          final List<dynamic> dataList = jsonData['ETRECOORDENADASROD'];
          for (final data in dataList) {
            await db.insert('ETRECOORDENADASROD', data);
          }
        }
      },
    );
  }

  Future<Map<String, dynamic>?> getRoadInfo(
      double latitude, double longitude) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT SGRODOVIA, NUKM
    FROM ETRECOORDENADASROD
    WHERE VLLATITUDE = ? AND VLLONGITUDE = ?
  ''', [latitude, longitude]);

    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'SGRODOVIA': row['SGRODOVIA'] as String,
        'NUKM': row['NUKM'] as double,
      };
    }
    return null;
  }

  Future<void> deleteDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'ETRECOORDENADASROD.db');
      final file = File(path);

      if (await file.exists()){
        await file.delete();
      }
    }catch (e) {
      throw Exception('Erro ao deletar o banco de dados: $e');
    }
  }

}
