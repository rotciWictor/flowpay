import 'package:equatable/equatable.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<TransactionEntity> transactions;
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionStatus? currentStatusFilter;
  final PaymentMethod? currentMethodFilter;

  const TransactionsLoaded({
    required this.transactions,
    this.startDate,
    this.endDate,
    this.currentStatusFilter,
    this.currentMethodFilter,
  });

  @override
  List<Object?> get props => [
        transactions,
        startDate,
        endDate,
        currentStatusFilter,
        currentMethodFilter,
      ];
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError({required this.message});

  @override
  List<Object> get props => [message];
}
