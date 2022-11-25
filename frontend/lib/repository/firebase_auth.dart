import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/repository/ref.dart';
import 'package:frontend/repository/repository.dart';

class FirebaseAuthRepo implements AuthRepository {
  @override
  bool haveActiveSession() {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  String? currentUserUid() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Future<void> login(String email, String password) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> register(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Create a new user in the database
    if (FirebaseAuth.instance.currentUser != null) {
      Ref().user.child(currentUserUid()!).set({
        'email': email,
        'name': email.split('@')[0],
      });
    } else {
      throw Exception('User not created');
    }
  }
}
