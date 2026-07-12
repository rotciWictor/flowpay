import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class ReportService {
  final SupabaseClient _supabase;

  ReportService({SupabaseClient? supabase}) : _supabase = supabase ?? Supabase.instance.client;

  Future<void> generateAndShareReport({
    required String format, // 'pdf' ou 'xml'
    Map<String, dynamic>? filters,
  }) async {
    try {
      // 1. Chamar a Edge Function
      final response = await _supabase.functions.invoke(
        'generate-report',
        body: {
          'format': format,
          'filters': filters ?? {},
        },
      );

      final data = response.data;
      if (data == null || data['url'] == null) {
        throw Exception('Falha ao gerar o relatório. URL não recebida.');
      }

      final String downloadUrl = data['url'];

      // 2. Fazer o download do arquivo gerado via HTTP
      final fileResponse = await http.get(Uri.parse(downloadUrl));
      if (fileResponse.statusCode != 200) {
        throw Exception('Falha ao baixar o relatório.');
      }

      // 3. Salvar no diretório temporário
      final tempDir = await getTemporaryDirectory();
      final fileName = 'extrato_flowpay_${DateTime.now().millisecondsSinceEpoch}.$format';
      final file = File('${tempDir.path}/$fileName');
      
      await file.writeAsBytes(fileResponse.bodyBytes);

      // 4. Compartilhar o arquivo (WhatsApp, Email, etc)
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Segue o relatório de transações exportado do FlowPay.',
      );
    } catch (e) {
      debugPrint('Erro ao exportar relatório: $e');
      rethrow;
    }
  }
}
