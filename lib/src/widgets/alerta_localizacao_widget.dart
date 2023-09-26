import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/location_provider.dart';

class OndeEstouWidget extends StatelessWidget {
  const OndeEstouWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizacaoUsuarioProvider =
        Provider.of<LocalizacaoUsuarioProvider>(context);
    final localizacaoUsuario = localizacaoUsuarioProvider.localizacaoUsuario;

    return AlertDialog(
      title: const Text('Sua localização'),
      content: localizacaoUsuario != null
          ? Text('Latitude: ${localizacaoUsuario.latitude}, Longitude: ${localizacaoUsuario.longitude}')
          : const Text('Localização não disponível'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
