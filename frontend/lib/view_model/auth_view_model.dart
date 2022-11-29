import 'package:flutter/material.dart';
import 'package:frontend/repository/firebase_auth.dart';
import 'package:frontend/repository/repository.dart';

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
    return Repository().auth.haveActiveSession();
  }

  void login() {
    if (!_fieldsAreValid(isSigningUp: false)) {
      return;
    }

    Repository()
        .auth
        .login(_emailController.text, _passwordController.text)
        .then((value) {
      _isSignedIn = true;
      notifyListeners();
    }).catchError((error) {
      _isSignedIn = false;
      _isError = true;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }

  void logout() {
    Repository().auth.logout().then((value) {
      _isSignedIn = false;
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      notifyListeners();
    }).catchError((error) {
      _isSignedIn = true;
      _isError = true;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }

  void register() {
    if (!_fieldsAreValid(isSigningUp: true)) {
      return;
    }

    Repository()
        .auth
        .register(_emailController.text, _passwordController.text)
        .then((value) {
      _isSignedIn = true;
      notifyListeners();
    }).catchError((error) {
      _isSignedIn = false;
      _isError = true;
      _errorMessage = error.toString();
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
