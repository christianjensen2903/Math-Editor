import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:frontend/model/notebook.dart';
import 'package:frontend/view_model/notebook_view_model.dart';
import 'package:provider/provider.dart';

class NotebookPage extends StatefulWidget {
  final Future<Notebook> notebook;

  const NotebookPage({Key? key, required this.notebook}) : super(key: key);

  @override
  State<NotebookPage> createState() => _NotebookPageState(notebook);
}

class _NotebookPageState extends State<NotebookPage> {
  final Future<Notebook> _notebook;

  final NotebookViewModel _notebookViewModel = NotebookViewModel();

  @override
  void initState() {
    super.initState();
    _notebookViewModel.loadNotebook(_notebook);
  }

  _NotebookPageState(this._notebook);

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
              if (!_notebookViewModel.isLoaded()) {
                return const Center(child: CircularProgressIndicator());
              }

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
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
