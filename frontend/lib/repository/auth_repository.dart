abstract class AuthRepository {
  Future<void> register(String email, String password);

  Future<void> login(String email, String password);

  Future<void> logout();

  String? currentUserUid();

  bool haveActiveSession();
}
