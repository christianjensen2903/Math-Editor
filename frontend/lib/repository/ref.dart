import 'package:firebase_database/firebase_database.dart';

String REF_USER = 'users';
String REF_NOTEBOOK = 'notebooks';
String REF_NOTEBOOK_OVERVIEW = 'notebook_overview';
String REF_NOTEBOOK_CONTENT = 'notebook_content';

class Ref {
  final DatabaseReference _databaseRoot = FirebaseDatabase.instance.ref();

  DatabaseReference get databaseRoot => _databaseRoot;

  DatabaseReference get databaseUsers => _databaseRoot.child(REF_USER);

  DatabaseReference databaseSpecificUser(String uid) =>
      _databaseRoot.child(REF_USER).child(uid);

  DatabaseReference get databaseNotebooks => _databaseRoot.child(REF_NOTEBOOK);

  DatabaseReference databaseSpecificNotebook(String notebookId) =>
      _databaseRoot.child(REF_NOTEBOOK).child(notebookId);

  DatabaseReference get databaseNotebookContent =>
      _databaseRoot.child(REF_NOTEBOOK_CONTENT);

  DatabaseReference databaseSpecificNotebookContent(String notebookId) =>
      _databaseRoot.child(REF_NOTEBOOK_CONTENT).child(notebookId);

  DatabaseReference get databaseNotebookOverview =>
      _databaseRoot.child(REF_NOTEBOOK_OVERVIEW);

  DatabaseReference databaseNotebookOverviewForUser(String uid) =>
      _databaseRoot.child(REF_NOTEBOOK_OVERVIEW).child(uid);
}
