import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' hide Account;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/providers.dart';
import 'package:frontend/repositories/repository_exception.dart';

final _authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref));

class AuthRepository with RepositoryExceptionMixin {
  // const AuthRepository(this._reader);
  const AuthRepository(this._ref);

  static Provider<AuthRepository> get provider => _authRepositoryProvider;

  // final Reader _reader;
  final Ref _ref;

  // Account get _account => _reader(Dependency.account);
  Account get _account => _ref.read(Dependency.account);

  Future<Account> create({
    required String email,
    required String password,
    required String name,
  }) {
    return exceptionHandler(
      _account.create(
        userId: 'unique()',
        email: email,
        password: password,
        name: name,
      ),
    );
  }

  Future<Session> createSession({
    required String email,
    required String password,
  }) {
    return exceptionHandler(
      _account.createEmailSession(email: email, password: password),
    );
  }

  Future<Account> get() {
    return exceptionHandler(
      _account.get(),
    );
  }

  Future<void> deleteSession({required String sessionId}) {
    return exceptionHandler(
      _account.deleteSession(sessionId: sessionId),
    );
  }
}
