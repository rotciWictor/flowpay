import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/components/lists/flow_list_tile.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/l10n/app_localizations.dart';

class LatestTransactionsList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final VoidCallback onSeeAll;
  final Function(TransactionEntity) onTransactionTap;

  const LatestTransactionsList({
    super.key,
    required this.transactions,
    required this.onSeeAll,
    required this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: FlowSpacing.xxl),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.receipt_long, size: 48, color: Colors.grey.shade800),
                const SizedBox(height: FlowSpacing.md),
                Text(
                  'Nenhuma transação recente',
                  style: FlowTypography.bodyMedium.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.dashboardLatestTransactions,
                  style: FlowTypography.titleLarge,
                ),
                TextButton(
                  onPressed: onSeeAll,
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.dashboardSeeAll, style: FlowTypography.bodyMedium),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final tx = transactions[index];
              final isIncome = tx.amount.minorUnits.toInt() > 0 && tx.status == TransactionStatus.approved;
              final amountColor = isIncome ? FlowColors.successLight : Colors.white;

              return FlowListTile(
                title: tx.amount.toString(),
                subtitle: tx.status.displayName,
                icon: isIncome ? Icons.arrow_downward : Icons.credit_card,
                iconColor: isIncome ? FlowColors.primary : Colors.grey,
                iconBackgroundColor: isIncome ? FlowColors.primary.withValues(alpha: 0.1) : FlowColors.surfaceVariant,
                valueColor: amountColor,
                trailingText: '${tx.createdAt.day.toString().padLeft(2, '0')}/${tx.createdAt.month.toString().padLeft(2, '0')}',
                onTap: () => onTransactionTap(tx),
              );
            },
            childCount: transactions.length,
          ),
        ),
      ],
    );
  }
}
