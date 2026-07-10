import 'package:flutter/material.dart';

/// FlowPay Color System (Tokens)
///
/// Implementa a separação estrita de tokens de design em duas camadas:
/// 1. Primitives: Valores brutos, intocáveis, definidos pela identidade da marca.
/// 2. Semantics: Valores com propósito lógico, que referenciam os primitivos.
abstract class FlowColors {
  // ===========================================================================
  // 1. PRIMITIVES (Não usar diretamente nos widgets!)
  // ===========================================================================
  static const _gray900 = Color(0xFF0D0D0D); // Charcoal/Dark lead
  static const _gray800 = Color(0xFF1A1A1A); // Slightly lighter
  static const _gray700 = Color(0xFF242424);
  static const _gray600 = Color(0xFF2D2D2D);
  static const _gray500 = Color(0xFF2D3142);
  static const _gray400 = Color(0xFF363A4E);
  
  static const _white50 = Color(0xFFF5F6FA);
  static const _gray100 = Color(0xFF8B8FA3);
  static const _gray200 = Color(0xFF5A5E72);

  static const _green400 = Color(0xFF4ADE80);
  static const _green500 = Color(0xFF00E676);
  static const _green600 = Color(0xFF00B248);
  
  static const _cyan500 = Color(0xFF00E5FF);
  
  static const _teal500 = Color(0xFF00B894);
  
  static const _red400 = Color(0xFFFF8A8A);
  static const _red500 = Color(0xFFFF6B6B);
  
  static const _yellow400 = Color(0xFFFEE9A0);
  static const _yellow500 = Color(0xFFFDCB6E);
  
  static const _blue500 = Color(0xFF74B9FF);

  // Brand Cards
  static const _visaBlue = Color(0xFF1A1F71);
  static const _masterRed = Color(0xFFEB001B);
  static const _eloBlue = Color(0xFF00A4E0);
  static const _pixTeal = Color(0xFF32BCAD);


  // ===========================================================================
  // 2. SEMANTICS (Tokens permitidos nos widgets)
  // ===========================================================================

  /// Background global da aplicação
  static const background = _gray900;
  
  /// Background para Cards, Modais e BottomSheets
  static const surface = _gray800;
  
  /// Inputs e áreas de destaque sutis no surface
  static const surfaceVariant = _gray700;
  
  /// Highlight para press states
  static const surfaceHighlight = _gray600;

  /// Cor principal da marca
  static const primary = _green500;
  static const primaryDark = _green600;
  
  /// Segunda cor primária (usada em gradientes ou neon effects)
  static const primaryGradientEnd = _cyan500;

  /// Textos de alta ênfase (Títulos, Valores Monetários)
  static const textPrimary = _white50;
  
  /// Textos de média ênfase (Subtítulos, labels)
  static const textSecondary = _gray100;
  
  /// Textos de baixa ênfase (Hint text, timestamps discretos)
  static const textTertiary = _gray200;

  /// Divisores e linhas sutis
  static const divider = _gray500;
  
  /// Bordas de inputs e botões outlined
  static const border = _gray400;

  // -- Feedback / Status --
  static const success = _teal500;
  static const successLight = _green400;
  static const error = _red500;
  static const errorLight = _red400;
  static const warning = _yellow500;
  static const warningLight = _yellow400;
  static const info = _blue500;

  // -- Backgrounds de Status (Chips e Badges) --
  static Color get statusApprovedBg => success.withValues(alpha: 0.15);
  static Color get statusDeclinedBg => error.withValues(alpha: 0.15);
  static Color get statusPendingBg => warning.withValues(alpha: 0.15);
  static Color get statusRefundedBg => info.withValues(alpha: 0.15);
  static Color get statusChargebackBg => _gray200.withValues(alpha: 0.15);

  // -- Marcas / Bandeiras (Exceções que mantêm a cor global) --
  static const brandVisa = _visaBlue;
  static const brandMastercard = _masterRed;
  static const brandElo = _eloBlue;
  static const brandPix = _pixTeal;
}
