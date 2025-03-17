import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/colors.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final FocusNode focusNode;
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.text,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
        fillColor: bgColor,
        filled: true,
        hintText: text,
      ),
    );
  }
}
