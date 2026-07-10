import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flowpay/app/theme/app_colors.dart';
import 'package:flowpay/app/theme/app_spacing.dart';

class NextSettlementCard extends StatelessWidget {
  final String amountStr;
  final DateTime? date;
  final VoidCallback onTap;

  const NextSettlementCard({
    super.key,
    required this.amountStr,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = date != null
        ? '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}'
        : '--/--';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.20),
                AppColors.primaryGradientEnd.withValues(alpha: 0.10),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: AppColors.primary.withValues(alpha: 0.2),
            highlightColor: AppColors.primary.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flash_on, color: AppColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'A receber no próx. dia útil',
                            style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        amountStr,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.0,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          dateStr,
                          style: GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
