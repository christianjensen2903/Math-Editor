export 'utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/navigation/routes.dart';
import 'package:routemaster/routemaster.dart';

class MathEditorApp extends ConsumerStatefulWidget {
  const MathEditorApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MathEditorAppState();
}

class _MathEditorAppState extends ConsumerState<MathEditorApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        return routesLoggedOut;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
