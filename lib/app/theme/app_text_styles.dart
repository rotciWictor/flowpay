import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';

/// Typography system using Inter from Google Fonts.
///
/// Inter is widely used in fintech apps for its clean, professional look
/// and excellent support for tabular figures (number alignment).
abstract class FlowTypography {
  // ── Display ──
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: FlowColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: FlowColors.textPrimary,
        height: 1.2,
      );

  // ── Headings ──
  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.3,
      );

  // ── Title ──
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.4,
      );

  // ── Body ──
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: FlowColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: FlowColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: FlowColors.textSecondary,
        height: 1.5,
      );

  // ── Label ──
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: FlowColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.3,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: FlowColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.3,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: FlowColors.textTertiary,
        height: 1.4,
        letterSpacing: 0.5,
      );

  // ── Monetary values (tabular figures for alignment) ──
  static TextStyle get moneyLarge => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: FlowColors.textPrimary,
        height: 1.2,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get moneyMedium => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.3,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get moneySmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: FlowColors.textPrimary,
        height: 1.4,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
