import 'package:equatable/equatable.dart';
import 'package:money2/money2.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';

class DailySale extends Equatable {
  final DateTime date;
  final Money totalAmount;

  const DailySale({required this.date, required this.totalAmount});

  @override
  List<Object?> get props => [date, totalAmount];
}

class DashboardDataEntity extends Equatable {
  final Money availableBalance;
  final List<DailySale> weeklySales;
  final List<TransactionEntity> recentTransactions;
  final Money nextSettlementAmount;
  final DateTime? nextSettlementDate;

  const DashboardDataEntity({
    required this.availableBalance,
    required this.weeklySales,
    required this.recentTransactions,
    required this.nextSettlementAmount,
    this.nextSettlementDate,
  });

  @override
  List<Object?> get props => [
        availableBalance,
        weeklySales,
        recentTransactions,
        nextSettlementAmount,
        nextSettlementDate,
      ];
}
