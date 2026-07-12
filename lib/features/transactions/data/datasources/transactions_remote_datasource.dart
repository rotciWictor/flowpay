import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flowpay/core/error/exceptions.dart';
import 'package:flowpay/features/transactions/data/models/transaction_model.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';

abstract class TransactionsRemoteDatasource {
  Future<List<TransactionModel>> getTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    List<TransactionStatus>? statuses,
    PaymentMethod? paymentMethod,
    List<TransactionType>? transactionTypes,
  });
  Future<List<TransactionModel>> getDashboardTransactions();
}

class TransactionsRemoteDatasourceImpl implements TransactionsRemoteDatasource {
  final SupabaseClient supabaseClient;

  TransactionsRemoteDatasourceImpl({required this.supabaseClient});

  @override
  Future<List<TransactionModel>> getTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    List<TransactionStatus>? statuses,
    PaymentMethod? paymentMethod,
    List<TransactionType>? transactionTypes,
  }) async {
    try {
      // PRO-TIP: Nunca usar select() vazio (que vira SELECT *). Especificar apenas as colunas usadas.
      var query = supabaseClient.from('transactions').select('''
        id, 
        merchant_id, 
        transaction_type, 
        amount, 
        net_amount, 
        fee_amount, 
        status, 
        payment_method, 
        card_brand, 
        installments, 
        customer_name, 
        card_last_four, 
        authorization_code, 
        return_code,
        nsu, 
        description, 
        created_at, 
        updated_at
      ''');

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }
      if (statuses != null && statuses.isNotEmpty) {
        final statusNames = statuses.map((s) => s.name).toList();
        query = query.filter('status', 'in', statusNames);
      }
      if (paymentMethod != null) {
        query = query.eq('payment_method', paymentMethod.name);
      }
      
      if (transactionTypes != null && transactionTypes.isNotEmpty) {
        final dbTypes = transactionTypes.map((t) {
          if (t == TransactionType.transferOut) return 'transfer_out';
          if (t == TransactionType.transferIn) return 'transfer_in';
          return 'sale';
        }).toList();
        query = query.filter('transaction_type', 'in', dbTypes);
      }

      var transformQuery = query.order('created_at', ascending: false);

      if (limit != null) {
        transformQuery = transformQuery.limit(limit);
      }

      final response = await transformQuery;
      return (response as List).map((json) => TransactionModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Falha no banco de dados: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Erro inesperado ao buscar transações: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getDashboardTransactions() async {
    try {
      // Fetching last 30 days of transactions for the dashboard to calculate available balance, weekly sales, and recents
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
      
      final response = await supabaseClient
          .from('transactions')
          .select('''
            id, merchant_id, transaction_type, amount, net_amount, fee_amount, status, payment_method, card_brand, installments, customer_name, card_last_four, authorization_code, return_code, nsu, description, created_at, updated_at
          ''')
          .gte('created_at', thirtyDaysAgo)
          .order('created_at', ascending: false);

      return (response as List).map((json) => TransactionModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: 'Falha no banco de dados: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Erro inesperado ao buscar dados do painel: $e');
    }
  }
}
