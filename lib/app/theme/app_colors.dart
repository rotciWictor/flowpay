import 'package:flutter/material.dart';

/// FlowPay color system.
///
/// Dark fintech palette designed to convey trust and professionalism.
/// All colors are defined here — widgets never use hardcoded hex values.
abstract class AppColors {
  // ── Backgrounds ──
  static const background = Color(0xFF0F1117);
  static const surface = Color(0xFF1A1D27);
  static const surfaceVariant = Color(0xFF242836);
  static const surfaceHighlight = Color(0xFF2D3142);

  // ── Brand ──
  static const primary = Color(0xFF6C5CE7);
  static const primaryLight = Color(0xFFA29BFE);
  static const primaryDark = Color(0xFF5A4BD1);

  // ── Semantic ──
  static const success = Color(0xFF00B894);
  static const successLight = Color(0xFF00B894);
  static const error = Color(0xFFFF6B6B);
  static const errorLight = Color(0xFFFF8A8A);
  static const warning = Color(0xFFFDCB6E);
  static const warningLight = Color(0xFFFEE9A0);
  static const info = Color(0xFF74B9FF);

  // ── Text ──
  static const textPrimary = Color(0xFFF5F6FA);
  static const textSecondary = Color(0xFF8B8FA3);
  static const textTertiary = Color(0xFF5A5E72);

  // ── Dividers & Borders ──
  static const divider = Color(0xFF2D3142);
  static const border = Color(0xFF363A4E);

  // ── Card brand colors ──
  static const visa = Color(0xFF1A1F71);
  static const mastercard = Color(0xFFEB001B);
  static const elo = Color(0xFF00A4E0);
  static const pix = Color(0xFF32BCAD);

  // ── Status background colors (subtle, for chips) ──
  static Color get approvedBg => success.withValues(alpha: 0.15);
  static Color get declinedBg => error.withValues(alpha: 0.15);
  static Color get pendingBg => warning.withValues(alpha: 0.15);
  static Color get refundedBg => info.withValues(alpha: 0.15);
  static Color get chargebackBg => const Color(0xFF5A5E72).withValues(alpha: 0.15);
}
