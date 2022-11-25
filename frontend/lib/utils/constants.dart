import 'package:flutter_dotenv/flutter_dotenv.dart';

final appwriteEndpoint = dotenv.env['APPWRITE_ENDPOINT']!;
final appwriteProjectId = dotenv.env['APPWRITE_PROJECT_ID']!;

/// All the routes used in the app.

const String homeRoute = '/';
const String registerRoute = '/register';
const String loginRoute = '/login';
const String notebookRoute = '/notebook';
