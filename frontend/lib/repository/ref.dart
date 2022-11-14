import 'package:firebase_database/firebase_database.dart';

String REF_USER = 'users';

class Ref {
  DatabaseReference _databaseRoot = FirebaseDatabase.instance.ref();

  DatabaseReference get databaseRoot => _databaseRoot;

  DatabaseReference get user => _databaseRoot.child(REF_USER);
}
