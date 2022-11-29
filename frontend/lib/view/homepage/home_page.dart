import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/model/notebook.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/view/auth/auth.dart';
import 'package:frontend/view_model/auth_view_model.dart';
import 'package:frontend/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    HomeViewModel homeViewModel = context.watch<HomeViewModel>();

    if (!authViewModel.isSignedIn) {
      return SignInPage();
    }
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
                  notebookRoute,
                  arguments: 'notebookId',
                );
              },
              child: const Text('Open Notebook'),
            ),
            // Button to create notebook
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  notebookRoute,
                  arguments: homeViewModel.createNotebook(),
                );
              },
              child: const Text('Create Notebook'),
            ),
            // Logout button
            TextButton(
              onPressed: () {
                authViewModel.logout();
              },
              child: const Text('Logout'),
            ),
            // List of notebooks from future
            FutureBuilder(
              future: homeViewModel.getNotebooks(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].title),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            notebookRoute,
                            arguments: Future.value(snapshot.data![index]),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
