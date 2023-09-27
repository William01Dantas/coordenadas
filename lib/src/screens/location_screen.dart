import 'package:flutter/material.dart';
import 'package:teste_rodovia/src/services/endereco_proximo.dart';
import 'package:teste_rodovia/src/services/obter_rodovia.dart';
import 'package:teste_rodovia/src/widgets/buscar_localizacao_widget.dart';
import 'package:teste_rodovia/src/widgets/permissao_localizacao_widget.dart';

import '../services/verifica_coordenadas_services.dart';
import 'components/botao_coordenada_widget.dart';
import 'components/campos_coordenadas_widget.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String latitude = "-27.23660573";
  String longitude = "-48.87444514";
  String rodoviaInfo = "";
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    permissaoLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Verifique sua localização antes de começar"),
              const SizedBox(
                width: 20.0,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final position = await getUserLocation();
                  if (position != null) {
                    final rodoviaInfoList = await obterInfoRodovia();
                    setState(() {
                      latitude = position.latitude.toString();
                      longitude = position.longitude.toString();
                      this.rodoviaInfo = rodoviaInfoList as String;
                      print('Rodovia Info: $rodoviaInfoList');

                    });
                  }
                },
                icon: const Icon(Icons.location_searching),
                label: const Text('Onde estou?'),
              ),
              BotaoCoordenadas(
                label: latitude,
                coordenada: latitude,
                copiaMensagem: 'Latitude copiada.',
              ),
              const SizedBox(
                height: 15.0,
              ),
              BotaoCoordenadas(
                label: longitude,
                coordenada: longitude,
                copiaMensagem: 'Longitude copiada.',
              ),
              const SizedBox(
                height: 15.0,
              ),
              CamposCoordenadas(
                label: 'Latitude',
                initialValue: latitude,
                controller: latitudeController,
              ),
              CamposCoordenadas(
                label: 'Longitude',
                initialValue: longitude,
                controller: longitudeController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final latitude = double.parse(latitudeController.text);
                    final longitude = double.parse(longitudeController.text);
                    // final rodoviaInfo =
                    //     await verificarCoordenadasNoBanco(latitude, longitude);
                    final proximidade = await enderecoProximo(latitude, longitude);
                    setState(() {
                      rodoviaInfo = proximidade!;
                    });
                  },
                  child: const Text('Verificar Coordenadas'),
                ),
              ),
              Text('Rodovia: $rodoviaInfo'),
            ],
          ),
        ),
      ),
    );
  }
}
