import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:frontend/view_model/notebook_view_model.dart';
import 'package:provider/provider.dart';

class NotebookPage extends StatelessWidget {
  const NotebookPage({super.key});

  @override
  Widget build(BuildContext context) {
    NotebookViewModel notebookViewModel = context.watch<NotebookViewModel>();

    final String notebookId =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notebook Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Notebook Page'),
            QuillToolbar.basic(controller: notebookViewModel.controller),
            Expanded(
              child: Container(
                child: QuillEditor.basic(
                  controller: notebookViewModel.controller,
                  readOnly: false, // true for view only mode
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
