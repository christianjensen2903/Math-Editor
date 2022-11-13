import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/providers.dart';
import 'package:frontend/components/controller_state_base.dart';
import 'package:frontend/models/app_error.dart';
import 'package:frontend/repositories/repositories.dart';

final _registerControllerProvider =
    StateNotifierProvider<RegisterController, ControllerStateBase>(
  (ref) => RegisterController(ref),
);

class RegisterController extends StateNotifier<ControllerStateBase> {
  RegisterController(this._ref) : super(const ControllerStateBase());

  static StateNotifierProvider<RegisterController, ControllerStateBase>
      get provider => _registerControllerProvider;

  static AlwaysAliveRefreshable<RegisterController> get notifier =>
      provider.notifier;

  final Ref _ref;

  Future<void> create({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await _ref
          .read(Repository.auth)
          .create(email: email, password: password, name: name);

      await _ref
          .read(Repository.auth)
          .createSession(email: email, password: password);

      /// Sets the global app state user.
      _ref.read(AppState.auth.notifier).setUser(user as Account);
    } on RepositoryException catch (e) {
      state = state.copyWith(error: AppError(message: e.message));
    }
  }
}
