import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/core/usecases/usecase.dart';
import 'package:flowpay/features/transactions/domain/entities/dashboard_data.dart';
import 'package:flowpay/features/transactions/domain/repositories/transactions_repository.dart';

class GetDashboardData implements UseCase<DashboardDataEntity, GetDashboardDataParams> {
  final TransactionsRepository repository;

  GetDashboardData(this.repository);

  @override
  Future<Either<Failure, DashboardDataEntity>> call(GetDashboardDataParams params) async {
    return await repository.getDashboardData(merchantId: params.merchantId);
  }
}

class GetDashboardDataParams extends Equatable {
  final String merchantId;

  const GetDashboardDataParams({required this.merchantId});

  @override
  List<Object?> get props => [merchantId];
}
