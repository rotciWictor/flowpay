import 'package:dartz/dartz.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/features/transactions/domain/entities/dashboard_data.dart';
import 'package:money2/money2.dart';

abstract class TransactionsRepository {
  /// Fetches the recent transactions for a given merchant.
  /// If [limit] is provided, it limits the number of transactions returned.
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    List<TransactionStatus>? statuses,
    PaymentMethod? paymentMethod,
    List<TransactionType>? transactionTypes,
  });

  /// Calculates the total available balance for a given merchant.
  /// Typically sums up the `netAmount` of `approved` transactions.
  Future<Either<Failure, Money>> getAvailableBalance();

  /// Fetches all data necessary for the dashboard in a single call.
  Future<Either<Failure, DashboardDataEntity>> getDashboardData();
}
