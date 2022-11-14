import 'package:flutter/material.dart';
import 'package:frontend/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isSignedIn = false;
  bool _isError = false;
  String _errorMessage = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  AuthViewModel() {
    _isSignedIn = haveActiveSession();
  }

  bool get isSignedIn => _isSignedIn;
  bool get isError => _isError;
  String get errorMessage => _errorMessage;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  bool haveActiveSession() {
    return AuthRepository().haveActiveSession();
  }

  void signIn() {
    if (!_fieldsAreValid(isSigningUp: false)) {
      return;
    }

    AuthRepository().signIn(emailController.text, passwordController.text, () {
      _isSignedIn = true;
      _isError = false;
      _errorMessage = '';
      notifyListeners();
    }, (error) {
      _isError = true;
      _errorMessage = error;
      notifyListeners();
    });
  }

  void signOut() {
    AuthRepository().signOut();
  }

  void signUp() {
    if (!_fieldsAreValid(isSigningUp: true)) {
      return;
    }

    AuthRepository().signUp(emailController.text, passwordController.text, () {
      _isSignedIn = true;
      _isError = false;
      _errorMessage = '';
      notifyListeners();
    }, (error) {
      _isError = true;
      _errorMessage = error;
      notifyListeners();
    });
  }

  void forgotPassword() {
    _isSignedIn = false;
    notifyListeners();
  }

  bool _fieldsAreValid({bool isSigningUp = true}) {
    if (_emailController.text.isEmpty) {
      _isError = true;
      _errorMessage = 'Email is required';
      notifyListeners();
      return false;
    }

    if (_passwordController.text.isEmpty) {
      _isError = true;
      _errorMessage = 'Password is required';
      notifyListeners();
      return false;
    }

    if (isSigningUp && _confirmPasswordController.text.isEmpty) {
      _isError = true;
      _errorMessage = 'Confirm Password is required';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(emailController.text)) {
      _isError = true;
      _errorMessage = 'Email is not valid';
      notifyListeners();
      return false;
    }

    if (!_isValidPassword(passwordController.text)) {
      _isError = true;
      _errorMessage = 'Password is not valid';
      notifyListeners();
      return false;
    }

    if (isSigningUp &&
        _passwordController.text != _confirmPasswordController.text) {
      _isError = true;
      _errorMessage = "Passwords don't match";
      notifyListeners();
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }
}
