import 'package:dartz/dartz.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/core/usecases/usecase.dart';
import 'package:flowpay/features/auth/domain/repositories/auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
