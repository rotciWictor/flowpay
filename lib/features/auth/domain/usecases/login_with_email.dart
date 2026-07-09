import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/core/usecases/usecase.dart';
import 'package:flowpay/features/auth/domain/entities/merchant.dart';
import 'package:flowpay/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmailParams extends Equatable {
  final String email;
  final String password;

  const LoginWithEmailParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LoginWithEmail implements UseCase<Merchant, LoginWithEmailParams> {
  final AuthRepository repository;

  LoginWithEmail(this.repository);

  @override
  Future<Either<Failure, Merchant>> call(LoginWithEmailParams params) async {
    // Basic business validation before hitting the repository
    if (params.email.trim().isEmpty || !params.email.contains('@')) {
      return Left(InvalidInputFailure('Por favor, informe um email válido.'));
    }
    if (params.password.trim().isEmpty) {
      return Left(InvalidInputFailure('Por favor, informe a senha.'));
    }

    return await repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}
