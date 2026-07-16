import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class ReportService {
  final SupabaseClient _supabase;

  ReportService({SupabaseClient? supabase}) : _supabase = supabase ?? Supabase.instance.client;

  Future<String> generateReport({
    required String format, // 'pdf' ou 'xml'
    Map<String, dynamic>? filters,
  }) async {
    try {
      debugPrint('ReportService: Preparando payload para "generate-report" (Format: $format, Filters: $filters)');
      
      // 1. Chamar a Edge Function
      debugPrint('ReportService: Disparando _supabase.functions.invoke() ...');
      final response = await _supabase.functions.invoke(
        'generate-report',
        body: {
          'format': format,
          'filters': filters ?? {},
        },
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        debugPrint('ReportService: TIMEOUT! A função demorou mais de 15 segundos.');
        throw Exception('Tempo limite excedido ao processar no servidor. Tente novamente.');
      });

      debugPrint('ReportService: Resposta recebida! Status: ${response.status}');
      final data = response.data;
      debugPrint('ReportService: Dados da Resposta: $data');

      if (data == null || data['url'] == null) {
        debugPrint('ReportService: Erro - Resposta não conteve a propriedade "url"');
        throw Exception('Falha ao gerar o relatório. URL não recebida.');
      }

      // 2. Retornar a Signed URL pública temporária para o Flutter abrir
      debugPrint('ReportService: Sucesso! Devolvendo URL para a UI.');
      return data['url'] as String;
    } catch (e) {
      debugPrint('Erro ao solicitar relatório: $e');
      if (e is FunctionException) {
        if (e.details != null && e.details.toString().contains('Bucket not found')) {
          throw Exception('Infraestrutura incompleta: O bucket "reports" não existe no Supabase. Por favor, crie-o no painel ou rode o seed.');
        }
        throw Exception('Falha no servidor: ${e.reasonPhrase ?? e.details ?? "Erro desconhecido"}');
      }
      throw Exception('Ocorreu um erro inesperado ao solicitar o relatório.');
    }
  }
}
