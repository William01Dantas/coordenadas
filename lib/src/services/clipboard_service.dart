import 'package:flutter/services.dart';

class ClipboardService{
  ClipboardService._();

  static Future<void> copiar(String value) async {
    await Clipboard.setData(
      ClipboardData(text: value),
    );
  }

  static Future<String> colar() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData?.text ?? '';
  }

  static Future<bool> hasData() async => Clipboard.hasStrings();
}