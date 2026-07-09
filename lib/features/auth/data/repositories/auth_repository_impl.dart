import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/features/auth/domain/entities/merchant.dart';
import 'package:flowpay/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, Merchant>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final merchantModel = await remoteDatasource.loginWithEmail(
        email: email,
        password: password,
      );
      return Right(merchantModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Merchant>> loginWithGoogle() async {
    try {
      final merchantModel = await remoteDatasource.loginWithGoogle();
      return Right(merchantModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Merchant>> checkAuthSession() async {
    try {
      final merchantModel = await remoteDatasource.checkAuthSession();
      return Right(merchantModel.toEntity());
    } on AuthException catch (_) {
      // It's normal to fail this if the user is simply not logged in.
      return const Left(AuthFailure(message: 'Não autenticado'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDatasource.logout();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
