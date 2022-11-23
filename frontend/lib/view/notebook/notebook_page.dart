import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:frontend/view_model/notebook_view_model.dart';
import 'package:provider/provider.dart';

// class NotebookPage extends StatefulWidget {
//   const NotebookPage({super.key});

//   @override
//   State<NotebookPage> createState() => _NotebookPageState();
// }

class NotebookPage extends StatelessWidget {
  final NotebookViewModel _notebookViewModel = NotebookViewModel();

  final String notebookId;

  NotebookPage({super.key, required this.notebookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notebook Page'),
      ),
      body: ChangeNotifierProvider(
          create: (_) => _notebookViewModel,
          child: Consumer<NotebookViewModel>(
            builder: (context, value, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Notebook Page'),
                    QuillToolbar.basic(
                        controller: _notebookViewModel.controller),
                    Expanded(
                      child: Container(
                        child: QuillEditor.basic(
                          controller: _notebookViewModel.controller,
                          readOnly: false, // true for view only mode
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
