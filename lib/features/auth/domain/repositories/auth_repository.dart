import 'package:dartz/dartz.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/features/auth/domain/entities/merchant.dart';

/// Abstract contract for authentication actions.
abstract class AuthRepository {
  /// Authenticates a merchant using email and password.
  Future<Either<Failure, Merchant>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Initiates the OAuth flow for Google Login.
  /// If it's a new user, they will be redirected to complete their profile
  /// (providing handle, document, and segment) before a full [Merchant] is returned.
  Future<Either<Failure, Merchant>> loginWithGoogle();

  /// Checks if there is a valid active session.
  /// Used by SplashPage to auto-login the user.
  Future<Either<Failure, Merchant>> checkAuthSession();

  /// Ends the current user session.
  Future<Either<Failure, void>> logout();
}
