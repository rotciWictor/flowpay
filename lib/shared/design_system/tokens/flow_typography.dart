import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';

/// FlowPay Typography System (Tokens)
///
/// Utiliza a fonte Outfit (já configurada) no lugar da Inter,
/// mantendo compatibilidade com as regras de tipografia e legibilidade.
abstract class FlowTypography {
  
  static String get fontFamily => GoogleFonts.outfit().fontFamily ?? 'sans-serif';

  // ===========================================================================
  // 1. DISPLAY (Telas de Boas Vindas, Valores gigantes)
  // ===========================================================================
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: FlowColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: FlowColors.textPrimary,
        height: 1.2,
      );

  // ===========================================================================
  // 2. HEADINGS (Títulos de seções, Cards principais)
  // ===========================================================================
  static TextStyle get headlineLarge => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.3,
      );

  // ===========================================================================
  // 3. TITLE (Títulos de listas, subtítulos menores)
  // ===========================================================================
  static TextStyle get titleLarge => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.4,
      );

  // ===========================================================================
  // 4. BODY (Texto de parágrafos, descrições)
  // ===========================================================================
  static TextStyle get bodyLarge => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: FlowColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: FlowColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: FlowColors.textSecondary,
        height: 1.5,
      );

  // ===========================================================================
  // 5. LABEL (Pequenos textos utilitários, badges, overline)
  // ===========================================================================
  static TextStyle get labelLarge => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: FlowColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.3,
      );

  static TextStyle get labelMedium => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: FlowColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.3,
      );

  static TextStyle get labelSmall => GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: FlowColors.textTertiary,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // ===========================================================================
  // 6. MONETARY (Números tabulares para alinhar extratos e saldos)
  // ===========================================================================
  static TextStyle get moneyLarge => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: FlowColors.textPrimary,
        height: 1.2,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get moneyMedium => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.3,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get moneySmall => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.4,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
