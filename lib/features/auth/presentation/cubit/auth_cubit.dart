import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flowpay/core/usecases/usecase.dart';
import 'package:flowpay/features/auth/domain/usecases/check_auth.dart';
import 'package:flowpay/features/auth/domain/usecases/login_with_email.dart';
import 'package:flowpay/features/auth/domain/usecases/login_with_google.dart';
import 'package:flowpay/features/auth/domain/usecases/logout.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CheckAuth _checkAuth;
  final LoginWithEmail _loginWithEmail;
  final LoginWithGoogle _loginWithGoogle;
  final Logout _logout;

  AuthCubit({
    required CheckAuth checkAuth,
    required LoginWithEmail loginWithEmail,
    required LoginWithGoogle loginWithGoogle,
    required Logout logout,
  })  : _checkAuth = checkAuth,
        _loginWithEmail = loginWithEmail,
        _loginWithGoogle = loginWithGoogle,
        _logout = logout,
        super(AuthInitial());

  Future<void> checkSession() async {
    emit(AuthLoading());
    final result = await _checkAuth(const NoParams());
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (merchant) => emit(AuthAuthenticated(merchant)),
    );
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _loginWithEmail(LoginWithEmailParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (merchant) => emit(AuthAuthenticated(merchant)),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    final result = await _loginWithGoogle(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (merchant) => emit(AuthAuthenticated(merchant)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _logout(const NoParams());
    emit(AuthUnauthenticated());
  }
}
