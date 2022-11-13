import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/providers.dart';
import 'package:frontend/components/controller_state_base.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/repositories/repositories.dart';

final _loginControllerProvider =
    StateNotifierProvider<LoginController, ControllerStateBase>(
  (ref) => LoginController(ref),
);

class LoginController extends StateNotifier<ControllerStateBase> {
  LoginController(this._ref) : super(const ControllerStateBase());

  static StateNotifierProvider<LoginController, ControllerStateBase>
      get provider => _loginControllerProvider;

  static AlwaysAliveRefreshable<LoginController> get notifier =>
      provider.notifier;

  final Ref _ref;

  Future<void> createSession({
    required String email,
    required String password,
  }) async {
    try {
      await _ref
          .read(Repository.auth)
          .createSession(email: email, password: password);

      final user = await _ref.read(Repository.auth).get();

      /// Sets the global app state user.
      _ref.read(AppState.auth.notifier).setUser(user as Account);
    } on RepositoryException catch (e) {
      state = state.copyWith(error: AppError(message: e.message));
    }
  }
}
