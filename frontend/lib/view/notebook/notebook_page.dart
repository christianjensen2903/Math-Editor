import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/view_model/notebook_view_model.dart';
import 'package:provider/provider.dart';
import 'package:appflowy_editor_plugins/appflowy_editor_plugins.dart';

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
                    child: AppFlowyEditor(
                      editorState: _notebookViewModel.editorState!,
                      // themeData: themeData,
                      autoFocus:
                          _notebookViewModel.editorState!.document.isEmpty,
                      customBuilders: {
                        // Divider
                        kDividerType: DividerWidgetBuilder(),
                        // Math Equation
                        kMathEquationType: MathEquationNodeWidgetBuidler(),
                        // Code Block
                        kCodeBlockType: CodeBlockNodeWidgetBuilder(),
                      },
                      shortcutEvents: [
                        // Divider
                        insertDividerEvent,
                        // Code Block
                        enterInCodeBlock,
                        ignoreKeysInCodeBlock,
                        pasteInCodeBlock,
                      ],
                      selectionMenuItems: [
                        // Divider
                        dividerMenuItem,
                        // Math Equation
                        mathEquationMenuItem,
                        // Code Block
                        codeBlockMenuItem,
                      ],
                    )
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     for (var i = 0; i < _notebookViewModel.blocks.length; i++)
                    //       Column(
                    //         children: [
                    //           const SizedBox(height: 40),
                    //           BlockWidget(
                    //             controller: _notebookViewModel.blockControllers[
                    //                 _notebookViewModel.blocks[i].id]!,
                    //             type: _notebookViewModel.blocks[i].type,
                    //           ),
                    //           const SizedBox(height: 20),
                    //           NewBlockButtons(
                    //               notebookViewModel: _notebookViewModel, i: i),
                    //         ],
                    //       ),
                    // ],
                    // ),
                    ),
              );
            },
          )),
    );
  }
}
