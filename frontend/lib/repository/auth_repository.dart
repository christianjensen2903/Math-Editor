import 'package:appwrite/appwrite.dart';
import 'package:frontend/utils/constants.dart';

class AuthRepository {
  late Client client;
  late Account account;

  AuthRepository() {
    client = Client()
        .setEndpoint(appwriteEndpoint)
        .setProject(appwriteProjectId)
        .setSelfSigned();
    account = Account(client);
  }

  void getSession() async {
    account.get();
  }

  void signIn({
    required String email,
    required String password,
  }) {
    account.createEmailSession(email: email, password: password);
  }

  void register({
    required String email,
    required String password,
  }) {
    account.create(
      userId: ID.unique(),
      email: email,
      password: password,
    );
  }

  void signOut() async {
    await account.deleteSessions();
  }
}
