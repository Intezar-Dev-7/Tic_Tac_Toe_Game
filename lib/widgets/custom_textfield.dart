import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;
  final bool isReadOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.focusNode,
    this.isReadOnly = false,
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
        hintText: hintText,
      ),
    );
  }
}
