import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page'),
            // Button to open notebook
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/notebook',
                  arguments: 'notebookId',
                );
              },
              child: const Text('Open Notebook'),
            ),
          ],
        ),
      ),
    );
  }
}
