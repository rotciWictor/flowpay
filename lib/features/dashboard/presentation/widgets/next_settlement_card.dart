import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/components/cards/flow_card.dart';
import 'package:flowpay/l10n/app_localizations.dart';

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

    return FlowCard(
      onTap: onTap,
      padding: const EdgeInsets.all(FlowSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.flash_on, color: FlowColors.primary, size: 16),
                  const SizedBox(width: FlowSpacing.xs),
                  Text(
                    AppLocalizations.of(context)!.dashboardNextSettlement,
                    style: FlowTypography.labelMedium.copyWith(color: FlowColors.textTertiary),
                  ),
                ],
              ),
              const SizedBox(height: FlowSpacing.xs),
              Text(
                amountStr,
                style: FlowTypography.moneyLarge.copyWith(color: FlowColors.primary),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.md, vertical: FlowSpacing.sm),
                decoration: BoxDecoration(
                  color: FlowColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(FlowSpacing.radiusLg),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Text(
                  dateStr,
                  style: FlowTypography.labelMedium,
                ),
              ),
              const SizedBox(width: FlowSpacing.sm),
              Icon(
                Icons.chevron_right,
                color: FlowColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
