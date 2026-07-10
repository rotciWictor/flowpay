import 'package:flutter/material.dart';

/// FlowPay color system.
///
/// Dark fintech palette designed to convey trust and professionalism.
/// All colors are defined here — widgets never use hardcoded hex values.
abstract class AppColors {
  // ── Backgrounds ──
  static const background = Color(0xFF0D0D0D); // Charcoal/Dark lead
  static const surface = Color(0xFF1A1A1A); // Slightly lighter for cards
  static const surfaceVariant = Color(0xFF242424);
  static const surfaceHighlight = Color(0xFF2D2D2D);

  // ── Brand ──
  static const primary = Color(0xFF00E676); // Neon Green
  static const primaryGradientEnd = Color(0xFF00E5FF); // Cyan Blue
  static const primaryDark = Color(0xFF00B248);

  // ── Semantic ──
  static const successMint = Color(0xFF4ADE80); // Mint Green for text/lists
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
