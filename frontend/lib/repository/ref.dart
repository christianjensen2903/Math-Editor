import 'package:firebase_database/firebase_database.dart';

String REF_USER = 'users';
String REF_NOTEBOOK = 'notebooks';

class Ref {
  final DatabaseReference _databaseRoot = FirebaseDatabase.instance.ref();

  DatabaseReference get databaseRoot => _databaseRoot;

  DatabaseReference get databaseUsers => _databaseRoot.child(REF_USER);

  DatabaseReference databaseSpecificUser(String uid) =>
      _databaseRoot.child(REF_USER).child(uid);

  DatabaseReference get databaseNotebooks => _databaseRoot.child(REF_NOTEBOOK);

  DatabaseReference databaseNotebooksForUser(String uid) =>
      _databaseRoot.child(REF_NOTEBOOK).child(uid);

  DatabaseReference databaseSpecificNotebook(String uid, String notebookId) =>
      _databaseRoot.child(REF_NOTEBOOK).child(uid).child(notebookId);
}
