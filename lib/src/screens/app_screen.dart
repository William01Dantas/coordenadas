import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teste_rodovia/src/db/db.dart';

import '../services/calculo_haversine.dart';
import 'components/alert_location_widget.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  // Variável para armazenar a localização atual do usuário
  late Position? _location;
  // Variável para armazenar as coordenadas atuais do usuário
  late List<double> _coordinates = [];
  // Variáveis para armazenar os controladores dos campos de texto
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  // Estado para controlar se a localização foi detectada
  bool _locationDetected = false;
  // Adicione uma variável para controlar se o banco de dados foi inicializado
  bool _databaseInitialized = false;

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String? roadName;
  double? km;

  List<Map<String, dynamic>> _nearbyRoads = [];

  @override
  void initState() {
    super.initState();
    // Solicita permissão para usar a localização do dispositivo
    Geolocator.requestPermission();
    // Inicializa os controladores dos campos de texto
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initDatabase();
    _getLocation();
  }

  Future<void> _initDatabase() async {
    try {
      await _databaseHelper.initDatabase('assets/etrecoordenadasprod.json' as Map<String, dynamic>);
      setState(() {
        _databaseInitialized = true;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getLocation() async {
    try {
      // Obtém a localização atual do usuário, mesmo com a internet desligada
      _location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );

      // Atualiza as coordenadas atuais do usuário
      _coordinates = [_location!.latitude, _location!.longitude];
      // Atualiza os controladores dos campos de texto
      _latitudeController.text = _coordinates[0].toString();
      _longitudeController.text = _coordinates[1].toString();
      // Atualiza o estado da localização
      setState(() {
        _locationDetected = true;
      });
    } catch (e) {
      // Exibe um erro se ocorrer algum problema
      debugPrint(e.toString());
      // Mostra o AlertDialog de erro de localization
      //alertLocation(context); // Método para exibir o AlertDialog de erro de localização
    }
  }

  // Função que consulta o db para obter todas as coordenadas
  Future<List<Map<String, dynamic>>> encontrarRodovias(double latitude, double longitude, double radius) async {
    final db = await _databaseHelper.database;
    final result = await db.query('ETRECOORDENADASROD');
    final List<Map<String, dynamic>> nearbyRoads = [];

    for (final row in result) {
      final roadLatitude = row['VLLATITUDE'] != null ? row['VLLATITUDE'] as double : 0.0;
      final roadLongitude = row['VLLONGITUDE'] != null ? row['VLLONGITUDE'] as double : 0.0;

      final distance = calculateDistance(latitude, longitude, roadLatitude, roadLongitude);

      if (distance <= radius) {
        nearbyRoads.add(row);
      }
    }
    return nearbyRoads;
  }

  void _checkCoordinates() async {
    final latitude = double.tryParse(_latitudeController.text);
    final longitude = double.tryParse(_longitudeController.text);

    if (latitude != null && longitude != null) {
      final nearbyRoads = await encontrarRodovias(latitude, longitude, 0.06);

      if (nearbyRoads.isNotEmpty) {
        final firstNearbyRoad = nearbyRoads[0];
        final userLatitude = latitude;
        final userLongitude = longitude;
        final roadLatitude = firstNearbyRoad['VLLATITUDE'] as double;
        final roadLongitude = firstNearbyRoad['VLLONGITUDE'] as double;
        if (kDebugMode) {
          print('Coordenadas da rodovia: Latitude $roadLatitude, Longitude $roadLongitude');
        }
        final distanceInKm = calculateDistance(userLatitude, userLongitude, roadLatitude, roadLongitude);
        final distanceInMeters = distanceInKm * 1000.0;

        setState(() {
          _nearbyRoads.clear();
          _nearbyRoads.add({'error': 'Endereço não encontrado'});
          //roadName = null;
          roadName = firstNearbyRoad['SGRODOVIA'];
          km = firstNearbyRoad['NUKM'];

        });
      } else {
        setState(() {
          roadName = null;
          km = null;
        });
      }
      if (kDebugMode) {
        print('Rodovia: $roadName, Km: $km');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Onde estou?',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Caso queira pode digitar suas coordenadas manualmente."),
              const SizedBox(height: 10,),

              Text(_locationDetected ? 'Latitude: ${_location!.latitude}' : 'Latitude: Aguardando localização...'),
              Text(_locationDetected ? 'Longitude: ${_location!.longitude}' : 'Longitude: Aguardando localização...'),
              const SizedBox(height: 10,),

              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(labelText: "Latitude"),
                //keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(labelText: "Longitude"),
                //keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10,),

              ElevatedButton(
                onPressed: _checkCoordinates,
                child: const Text("Verificar Coordenadas"),
              ),
              const SizedBox(height: 10,),

              if (_nearbyRoads.isNotEmpty)
               SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DropdownButton<String>(
                    items: _nearbyRoads.map((road) {
                      final roadName = road['SGRODOVIA'] as String?;
                      final km = road['NUKM'].toString();
                      // Obtém as coordenadas da rodovia
                      final roadLatitude = road['VLLATITUDE'] as double;
                      final roadLongitude = road['VLLONGITUDE'] as double;
                      // Calcula a distância entre o usuário e a rodovia
                      final distanceInKm = calculateDistance(_coordinates[0], _coordinates[1], roadLatitude, roadLongitude);

                      return DropdownMenuItem<String>(
                        value: '$roadName, Km: $km - Distância: ${distanceInKm.toStringAsFixed(2)} metros',
                        child: Text(_nearbyRoads.isNotEmpty ? '$roadName, Km: $km - Distância: ${distanceInKm.toStringAsFixed(2)} metros'
                            : 'Nenhuma rodovia próxima encontrada.'),
                      );
                    }).toList(),
                    onChanged: (selectedValue){
                      // Tratamento
                    },
                    hint: const Text('Selecione uma rodovia'),
                  ),
                ),

              Text('Rodovia: ${roadName ?? "Não encontrado"}, Km: ${km ?? "Não encontrado"}'),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: () async {
                  try {
                    final databaseHelper = DatabaseHelper();
                    await databaseHelper.deleteDatabase();
                    setState(() {
                      _databaseInitialized = false; // Marque o banco de dados como não inicializado novamente
                      roadName = null; // Limpe os dados exibidos, se houver
                      km = null;
                    });
                  } catch (e) {
                    debugPrint('Erro ao deletar o banco de dados: $e');
                  }
                },
                child: const Text("Deletar Banco de Dados"),
              )

            ],
          ),
        ),
      ),
    );
  }
}