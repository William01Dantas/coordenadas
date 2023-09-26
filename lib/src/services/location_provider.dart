import 'package:flutter/material.dart';

class LocalizacaoUsuario{
  double? latitude;
  double? longitude;

  LocalizacaoUsuario({this.latitude, this.longitude});
}

class LocalizacaoUsuarioProvider extends ChangeNotifier{
  LocalizacaoUsuario? _localizacaoUsuario;

  LocalizacaoUsuario? get localizacaoUsuario => _localizacaoUsuario;

  void atualizaLocalizacaoUsuario(double latitude, double longitude) {
    _localizacaoUsuario = LocalizacaoUsuario(latitude: latitude, longitude: longitude);
    notifyListeners();
  }
}