import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  setupLogger();

  await dotenv.load(fileName: '.env');

  runApp(const ProviderScope(child: MathEditorApp()));
}
