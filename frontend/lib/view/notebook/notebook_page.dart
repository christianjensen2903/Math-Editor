import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NotebookArguments {
  final String notebookId;

  NotebookArguments(this.notebookId);
}

class NotebookPage extends StatelessWidget {
  const NotebookPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final NotebookArguments args =
    //     ModalRoute.of(context)!.settings.arguments as NotebookArguments;

    final String notebookId =
        ModalRoute.of(context)!.settings.arguments as String;
    return Container();
  }
}
