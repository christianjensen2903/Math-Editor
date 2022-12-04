import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:frontend/model/block.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/view/notebook/widgets/block_widget.dart';
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
              if (!_notebookViewModel.isLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (var i = 0; i < _notebookViewModel.blocks.length; i++)
                      Column(
                        children: [
                          BlockWidget(
                            controller: _notebookViewModel.blockControllers[
                                _notebookViewModel.blocks[i].id]!,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _notebookViewModel.createBlock(
                                      BlockType.text, i + 1);
                                },
                                child: const Text('Text'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _notebookViewModel.createBlock(
                                      BlockType.code, i + 1);
                                },
                                child: const Text('Code'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _notebookViewModel.createBlock(
                                      BlockType.math, i + 1);
                                },
                                child: const Text('Math'),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ));
            },
          )),
    );
  }
}
