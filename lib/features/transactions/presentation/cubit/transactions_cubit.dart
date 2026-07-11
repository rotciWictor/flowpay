import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/features/transactions/domain/usecases/get_transactions.dart';
import 'package:flowpay/features/transactions/presentation/cubit/transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactions getTransactions;
  
  Map<String, dynamic>? lastUiFilterState;

  TransactionsCubit({
    required this.getTransactions,
  }) : super(TransactionsInitial());

  Future<void> fetchTransactions({
    bool isRefresh = false,
    DateTime? startDate,
    DateTime? endDate,
    TransactionStatus? status,
    List<TransactionStatus>? statuses,
    PaymentMethod? paymentMethod,
    List<TransactionType>? transactionTypes,
    Map<String, dynamic>? uiFilterState,
  }) async {
    if (uiFilterState != null) {
      lastUiFilterState = uiFilterState;
    }

    if (!isRefresh) {
      emit(TransactionsLoading());
    }

    final params = GetTransactionsParams(
      startDate: startDate,
      endDate: endDate,
      statuses: statuses ?? (status != null ? [status] : null),
      paymentMethod: paymentMethod,
      transactionTypes: transactionTypes,
    );

    final result = await getTransactions(params);

    result.fold(
      (failure) => emit(const TransactionsError(message: 'Falha ao carregar transações.')),
      (transactions) => emit(TransactionsLoaded(
        transactions: transactions,
        startDate: startDate,
        endDate: endDate,
        currentStatusFilter: statuses?.isNotEmpty == true ? statuses!.first : null,
        currentMethodFilter: paymentMethod,
      )),
    );
  }
}
