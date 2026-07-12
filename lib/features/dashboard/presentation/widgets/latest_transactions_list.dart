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
                Icon(Icons.receipt_long, size: 48, color: FlowColors.surface),
                const SizedBox(height: FlowSpacing.md),
                Text(
                  'Nenhuma transação recente',
                  style: FlowTypography.bodyMedium.copyWith(color: FlowColors.textTertiary),
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
              return _DashboardTransactionItem(
                transaction: tx,
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

/// Item de transação da Dashboard — espelha o design do Extrato
class _DashboardTransactionItem extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onTap;

  const _DashboardTransactionItem({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayAmount = transaction.amount;
    final amountColor = _getAmountColor();
    final badgeColor = _getBadgeColor();

    final isOutgoing = transaction.type == TransactionType.transferOut ||
        transaction.status == TransactionStatus.refunded ||
        transaction.status == TransactionStatus.chargeback;

    return FlowListTile(
      title: transaction.customerName ?? 'Cliente não identificado',
      subtitle: _getSubtitle(),
      leadingWidget: _buildLeadingIcon(),
      trailingWidget: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isOutgoing ? '- $displayAmount' : '+ $displayAmount',
                style: FlowTypography.moneySmall.copyWith(
                  color: amountColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: FlowSpacing.xs),
              _buildStatusBadge(badgeColor),
            ],
          ),
          const SizedBox(width: FlowSpacing.sm),
          const Icon(Icons.chevron_right, color: FlowColors.textTertiary, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }

  String _getSubtitle() {
    final method = transaction.paymentMethod.displayName;
    final timeStr = '${transaction.createdAt.hour.toString().padLeft(2, '0')}:${transaction.createdAt.minute.toString().padLeft(2, '0')}';

    if (transaction.cardBrand != null) {
      return '$timeStr • $method • ${transaction.cardBrand!.displayName}';
    }
    return '$timeStr • $method';
  }

  Color _getAmountColor() {
    if (transaction.status == TransactionStatus.declined) {
      return FlowColors.textSecondary;
    }
    if (transaction.status == TransactionStatus.pending) {
      return FlowColors.warning;
    }
    if (transaction.type == TransactionType.transferOut ||
        transaction.status == TransactionStatus.refunded ||
        transaction.status == TransactionStatus.chargeback) {
      return FlowColors.error;
    }
    return FlowColors.success;
  }

  Color _getBadgeColor() {
    switch (transaction.status) {
      case TransactionStatus.approved:
        return FlowColors.success;
      case TransactionStatus.pending:
        return FlowColors.warning;
      case TransactionStatus.declined:
        return FlowColors.textSecondary;
      case TransactionStatus.refunded:
      case TransactionStatus.chargeback:
        return FlowColors.error;
    }
  }

  Widget _buildStatusBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.sm, vertical: FlowSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
      ),
      child: Text(
        transaction.status.displayName,
        style: FlowTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    if (transaction.type == TransactionType.transferOut) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: FlowColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
        ),
        child: const Center(child: Icon(Icons.arrow_outward, color: FlowColors.error, size: 20)),
      );
    }

    if (transaction.type == TransactionType.transferIn) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: FlowColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
        ),
        child: const Center(child: Icon(Icons.south_west, color: FlowColors.success, size: 20)),
      );
    }

    final iconData = transaction.paymentMethod == PaymentMethod.pix ? Icons.pix : Icons.credit_card;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: FlowColors.surface,
        borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
      ),
      child: Center(child: Icon(iconData, color: FlowColors.primary, size: 20)),
    );
  }
}
