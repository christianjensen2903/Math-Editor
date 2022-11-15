import 'package:frontend/repository/auth_repository.dart';

abstract class AuthRepository {
  void signUp(String email, String password, Function() onSuccess,
      Function(String errorMessage) onError);

  void signIn(String email, String password, Function() onSuccess,
      Function(String errorMessage) onError);

  void signOut();

  String currentUserUid();

  bool haveActiveSession();
}

class Repository {
  final AuthRepository _authRepository = FirebaseAuthRepo();

  AuthRepository get auth => _authRepository;
}
