import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hint;
  final TextInputType textInputType;

  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      this.isPass = false,
      required this.hint,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final InputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder,
        focusedBorder: InputBorder,
        enabledBorder: InputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
