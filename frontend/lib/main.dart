import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/app.dart';

void main() {
  setupLogger();

  runApp(const ProviderScope(child: MathEditorApp()));
}
