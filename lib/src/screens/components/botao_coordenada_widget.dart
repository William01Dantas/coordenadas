import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teste_rodovia/src/services/clipboard_service.dart';

class BotaoCoordenadas extends StatelessWidget {
  final String label;
  final String coordenada;
  final String copiaMensagem;

  const BotaoCoordenadas({
    super.key,
    required this.label,
    required this.coordenada,
    required this.copiaMensagem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(coordenada.isNotEmpty ? coordenada : "Sem coordenadas"),
        IconButton(
          onPressed: () async {
            await ClipboardService.copiar(coordenada);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(copiaMensagem),
              ),
            );
          },
          icon: const Icon(Icons.copy),
        ),
      ],
    );
  }
}
