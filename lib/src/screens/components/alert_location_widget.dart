import 'package:flutter/material.dart';

Future<void> alertLocation(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: const Text('Erro de Localização'),
          content: const Text('Não foi possível detectar sua localização.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      });
}
