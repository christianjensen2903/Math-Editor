import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/repository/ref.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/repository/repository.dart';

class FirebaseAuthRepo implements AuthRepository {
  @override
  String currentUserUid() {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser!.uid;
    } else {
      throw Exception('No active session');
    }
  }

  @override
  Future<void> signUp(String email, String password, Function() onSuccess,
      Function(String errorMessage) onError) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      try {
        await Ref().user.child(currentUserUid()).set({
          'email': email,
          'name': email.split('@')[0],
        });
        onSuccess();
      } catch (e) {
        await FirebaseAuth.instance.currentUser!.delete();
        onError(e.toString());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        onError('The account already exists for that email.');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  @override
  Future<void> signIn(String email, String password, Function() onSuccess,
      Function(String errorMessage) onError) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        onError('Wrong password provided for that user.');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email, Function() onSuccess,
      Function(String errorMessage) onError) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError('No user found for that email.');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // Check if user is signed in
  @override
  bool haveActiveSession() {
    try {
      currentUserUid();
      return true;
    } catch (e) {
      return false;
    }
  }
}
