import 'package:dartz/dartz.dart';
import 'package:flowpay/core/error/exceptions.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/core/utils/currency_format.dart';
import 'package:flowpay/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:flowpay/features/transactions/domain/entities/dashboard_data.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:money2/money2.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDatasource remoteDatasource;

  TransactionsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    int? limit,
  }) async {
    try {
      final transactions = await remoteDatasource.getTransactions(
        limit: limit,
      );
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Money>> getAvailableBalance() async {
    try {
      final transactions = await remoteDatasource.getTransactions();
      
      var total = Money.fromIntWithCurrency(0, brlCurrency);
      for (var t in transactions) {
        if (t.status == TransactionStatus.approved) {
          total = total + t.netAmount;
        }
      }
      return Right(total);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DashboardDataEntity>> getDashboardData() async {
    try {
      final transactions = await remoteDatasource.getDashboardTransactions();
      
      var availableBalance = Money.fromIntWithCurrency(0, brlCurrency);
      var nextSettlementAmount = Money.fromIntWithCurrency(0, brlCurrency);
      DateTime? nextSettlementDate;
      
      // Calculate available balance (all approved transactions)
      for (var t in transactions) {
        if (t.status == TransactionStatus.approved) {
          availableBalance = availableBalance + t.netAmount;
        }
      }

      DateTime getNextBusinessDay(DateTime date) {
        DateTime nextDay = date.add(const Duration(days: 1));
        while (nextDay.weekday == DateTime.saturday || nextDay.weekday == DateTime.sunday) {
          nextDay = nextDay.add(const Duration(days: 1));
        }
        return nextDay;
      }

      // Calculate next settlement (sum of pending transactions)
      for (var t in transactions) {
        if (t.status == TransactionStatus.pending) {
          nextSettlementAmount = nextSettlementAmount + t.netAmount;
        }
      }
      
      // O recebimento sempre cai no próximo dia útil
      nextSettlementDate = getNextBusinessDay(DateTime.now());

      // Calculate weekly sales (9 days to allow chart bleed: 8 days ago to tomorrow)
      final now = DateTime.now();
      final Map<int, Money> salesByDay = {};
      for (int i = 7; i >= -1; i--) {
        salesByDay[i] = Money.fromIntWithCurrency(0, brlCurrency);
      }

      for (var t in transactions) {
        if (t.status == TransactionStatus.approved || t.status == TransactionStatus.pending) {
          final difference = now.difference(t.createdAt).inDays;
          if (difference >= -1 && difference <= 7) {
            salesByDay[difference] = (salesByDay[difference] ?? Money.fromIntWithCurrency(0, brlCurrency)) + t.amount;
          }
        }
      }

      final List<DailySale> weeklySales = [];
      for (int i = 7; i >= -1; i--) {
        weeklySales.add(DailySale(
          date: now.subtract(Duration(days: i)),
          totalAmount: salesByDay[i]!,
        ));
      }

      // Recent transactions
      final recentTransactions = transactions.take(5).toList();

      final dashboardData = DashboardDataEntity(
        availableBalance: availableBalance,
        weeklySales: weeklySales,
        recentTransactions: recentTransactions,
        nextSettlementAmount: nextSettlementAmount,
        nextSettlementDate: nextSettlementDate,
      );

      return Right(dashboardData);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
