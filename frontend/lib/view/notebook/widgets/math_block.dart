import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class MathBlock extends StatefulWidget {
  const MathBlock({super.key, required this.controller});

  final QuillController controller;

  @override
  State<MathBlock> createState() => _MathBlockState();
}

class _MathBlockState extends State<MathBlock> {
  bool render = false;

  void toggleRender() {
    setState(() {
      render = !render;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (render) ...[
          Math.tex(
            widget.controller.plainTextEditingValue.text,
          )
        ] else ...[
          QuillEditor.basic(
            controller: widget.controller,
            readOnly: false, // true for view only mode
          )
        ],
        ElevatedButton(
          onPressed: toggleRender,
          child: const Text('Render'),
        ),
      ],
    );
  }
}
