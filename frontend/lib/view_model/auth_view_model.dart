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
    try {
      AuthRepository().getSession();
      return true;
    } catch (e) {
      return false;
    }
  }

  void signIn() {
    if (_emailController.text.isEmpty) {
      _isError = true;
      _errorMessage = 'Email is required';
      notifyListeners();
      return;
    }

    if (_passwordController.text.isEmpty) {
      _isError = true;
      _errorMessage = 'Password is required';
      notifyListeners();
      return;
    }

    if (!_isValidEmail(emailController.text)) {
      _isError = true;
      _errorMessage = 'Email is not valid';
      notifyListeners();
      return;
    }

    if (!_isValidPassword(passwordController.text)) {
      _isError = true;
      _errorMessage = 'Password is not valid';
      notifyListeners();
      return;
    }

    try {
      AuthRepository().signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _isSignedIn = true;
      notifyListeners();
    } catch (e) {
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void signOut() {
    try {
      AuthRepository().signOut();
      _isSignedIn = false;
      notifyListeners();
    } catch (e) {
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void register() {
    if (_emailController.text.isEmpty) {
      _isError = true;
      _errorMessage = 'Email is required';
      notifyListeners();
      return;
    }

    if (_passwordController.text.isEmpty) {
      _isError = true;
      _errorMessage = 'Password is required';
      notifyListeners();
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      _isError = true;
      _errorMessage = 'Confirm Password is required';
      notifyListeners();
      return;
    }

    if (!_isValidEmail(emailController.text)) {
      _isError = true;
      _errorMessage = 'Email is not valid';
      notifyListeners();
      return;
    }

    if (!_isValidPassword(passwordController.text)) {
      _isError = true;
      _errorMessage = 'Password is not valid';
      notifyListeners();
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _isError = true;
      _errorMessage = "Passwords don't match";
      notifyListeners();
      return;
    }

    try {
      AuthRepository().register(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _isSignedIn = true;
      notifyListeners();
    } catch (e) {
      _isError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void forgotPassword() {
    _isSignedIn = false;
    notifyListeners();
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
