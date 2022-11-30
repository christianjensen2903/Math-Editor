import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart';

class BlockWidget extends StatelessWidget {
  final QuillController controller;

  const BlockWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.blueAccent)),
      padding: const EdgeInsets.all(15.0),
      child: QuillEditor.basic(
        controller: controller,
        readOnly: false, // true for view only mode
      ),
    );
  }
}
