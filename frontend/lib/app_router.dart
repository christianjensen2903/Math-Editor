import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/view/auth/auth.dart';
import 'package:frontend/view/homepage/home_page.dart';
import 'package:frontend/view/notebook/notebook_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case notebookRoute:
        return MaterialPageRoute(
            builder: (_) => NotebookPage(
                  notebookId: settings.arguments as String,
                ));
      case registerRoute:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => SignInPage());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                      child: Text(
                          'Could not find the page that you are looking for')),
                ));
    }
  }
}
