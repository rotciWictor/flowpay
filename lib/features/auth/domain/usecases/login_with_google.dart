import 'package:dartz/dartz.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/core/usecases/usecase.dart';
import 'package:flowpay/features/auth/domain/entities/merchant.dart';
import 'package:flowpay/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogle implements UseCase<Merchant, NoParams> {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  @override
  Future<Either<Failure, Merchant>> call(NoParams params) async {
    return await repository.loginWithGoogle();
  }
}
