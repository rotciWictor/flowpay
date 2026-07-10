import 'package:flutter/services.dart';

/// FlowPay Haptics System (Behavior)
///
/// Gerencia o feedback tátil da aplicação para que botões, erros e sucessos
/// passem a sensação física correta baseada no artigo "Behavior & The Feel".
abstract class FlowHaptics {
  /// Feedback leve. Usado para ações comuns como switches, checkboxes, tap simples.
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Feedback médio. Usado para confirmações primárias ou press actions em Cards.
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Feedback pesado / Erro. Padrão duplo de vibração alertando falhas ou ações destrutivas.
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Feedback de Sucesso. Usado quando uma transação completa com êxito.
  static Future<void> successImpact() async {
    // Simulando um padrão tátil de sucesso que se assemelha a "Ta-Da!"
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.lightImpact();
  }
}
