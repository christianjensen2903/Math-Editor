import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolder;

  const CustomTextField(
      {super.key, required this.controller, this.placeHolder = ''});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: placeHolder,
      ),
    );
  }
}
