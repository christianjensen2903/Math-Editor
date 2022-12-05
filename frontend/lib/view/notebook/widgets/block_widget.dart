import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:frontend/model/block.dart';
import 'package:frontend/view/notebook/widgets/math_block.dart';

class BlockWidget extends StatelessWidget {
  final QuillController controller;
  final BlockType type;

  const BlockWidget({super.key, required this.controller, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BlockType.text:
        return QuillEditor.basic(
          controller: controller,
          readOnly: false, // true for view only mode
        );
      case BlockType.code:
        return QuillEditor.basic(
          controller: controller,
          readOnly: false, // true for view only mode
        );
      case BlockType.math:
        return MathBlock(controller: controller);
    }
    // return Container(
    //   decoration: BoxDecoration(
    //       color: Colors.grey[200],
    //       borderRadius: BorderRadius.all(Radius.circular(10)),
    //       border: Border.all(color: Colors.blueAccent)),
    //   padding: const EdgeInsets.all(15.0),
    //   child: QuillEditor.basic(
    //     controller: controller,
    //     readOnly: false, // true for view only mode
    //   ),
    // );
  }
}
