/// FlowPay Motion System (Tokens)
///
/// Define as curvas de animação (Easing) e durações padrão para
/// consistência em micro-interações, transições de tela e modais.
abstract class FlowMotion {
  // ===========================================================================
  // 1. DURAÇÕES (Durations)
  // ===========================================================================
  
  /// Extremamente rápido: 100ms. Usado para hover states, active states de botões.
  static const Duration durationInstant = Duration(milliseconds: 100);
  
  /// Rápido: 200ms. Usado para micro-interações (ligar switches, checkboxes).
  static const Duration durationFast = Duration(milliseconds: 200);
  
  /// Normal: 300ms. Padrão para abrir painéis pequenos, fade in/out de elementos.
  static const Duration durationNormal = Duration(milliseconds: 300);
  
  /// Lento: 500ms. Usado para transições de página ou modais complexos (bottom sheets).
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ===========================================================================
  // 2. CURVAS (Easing)
  // ===========================================================================
  // Em Flutter, usamos Curves padrão que refletem a natureza:
  // EaseOut: começa rápido e freia (bom para entrada).
  // EaseIn: começa devagar e acelera (bom para saída).
}
