import 'package:flutter_dotenv/flutter_dotenv.dart';

final appwriteEndpoint = dotenv.env['APPWRITE_ENDPOINT']!;
final appwriteProjectId = dotenv.env['APPWRITE_PROJECT_ID']!;
