import 'package:dartz/dartz.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/core/usecases/usecase.dart';
import 'package:flowpay/features/transactions/domain/entities/dashboard_data.dart';
import 'package:flowpay/features/transactions/domain/repositories/transactions_repository.dart';

class GetDashboardData implements UseCase<DashboardDataEntity, NoParams> {
  final TransactionsRepository repository;

  GetDashboardData(this.repository);

  @override
  Future<Either<Failure, DashboardDataEntity>> call(NoParams params) async {
    return await repository.getDashboardData();
  }
}
