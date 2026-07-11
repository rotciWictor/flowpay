import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/core/usecases/usecase.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/features/transactions/domain/repositories/transactions_repository.dart';

class GetTransactions implements UseCase<List<TransactionEntity>, GetTransactionsParams> {
  final TransactionsRepository repository;

  GetTransactions(this.repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(GetTransactionsParams params) async {
    return await repository.getTransactions(
      limit: params.limit,
      startDate: params.startDate,
      endDate: params.endDate,
      statuses: params.statuses,
      paymentMethod: params.paymentMethod,
      transactionTypes: params.transactionTypes,
    );
  }
}

class GetTransactionsParams extends Equatable {
  final int? limit;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<TransactionStatus>? statuses;
  final PaymentMethod? paymentMethod;
  final List<TransactionType>? transactionTypes;

  const GetTransactionsParams({
    this.limit,
    this.startDate,
    this.endDate,
    this.statuses,
    this.paymentMethod,
    this.transactionTypes,
  });

  @override
  List<Object?> get props => [limit, startDate, endDate, statuses, paymentMethod, transactionTypes];
}
