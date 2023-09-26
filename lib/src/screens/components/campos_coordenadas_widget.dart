import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CamposCoordenadas extends StatefulWidget {
  final IconData? icon;
  final String label;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? inicialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;

  const CamposCoordenadas({
    super.key,
    this.icon,
    required this.label,
    this.isSecret = false,
    this.inputFormatters,
    this.inicialValue,
    this.readOnly = false,
    this.validator,
    this.controller,
    this.initialValue,
  });

  @override
  State<CamposCoordenadas> createState() => _CamposCoordenadasState();
}

class _CamposCoordenadasState extends State<CamposCoordenadas> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: widget.controller,
        readOnly: widget.readOnly,
        initialValue: widget.inicialValue,
        inputFormatters: widget.inputFormatters,
        obscureText: isObscure,
        validator: widget.validator,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.arrow_forward_ios),
          labelText: widget.label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        ),
      ),
    );
  }
}
