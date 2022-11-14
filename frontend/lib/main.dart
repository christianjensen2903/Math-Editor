import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/view/auth/auth.dart';
import 'package:frontend/view/homepage/home_page.dart';
import 'package:frontend/view/notebook/notebook_page.dart';
import 'package:frontend/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthViewModel()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => authViewModel.isSignedIn ? HomePage() : LoginPage(),
          '/register': (context) => RegisterPage(),
          '/notebook': (context) => NotebookPage(),
        });
  }
}
