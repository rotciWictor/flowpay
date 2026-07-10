import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flowpay/core/error/exceptions.dart';
import 'package:flowpay/features/transactions/data/models/transaction_model.dart';

abstract class TransactionsRemoteDatasource {
  Future<List<TransactionModel>> getTransactions({int? limit});
  Future<List<TransactionModel>> getDashboardTransactions();
}

class TransactionsRemoteDatasourceImpl implements TransactionsRemoteDatasource {
  final SupabaseClient supabaseClient;

  TransactionsRemoteDatasourceImpl({required this.supabaseClient});

  @override
  Future<List<TransactionModel>> getTransactions({int? limit}) async {
    try {
      var query = supabaseClient
          .from('transactions')
          .select()
          .order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
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
          .select()
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
