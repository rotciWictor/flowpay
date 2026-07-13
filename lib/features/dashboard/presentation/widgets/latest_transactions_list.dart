import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/components/lists/flow_list_tile.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';

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
              return Padding(
                padding: const EdgeInsets.only(bottom: FlowSpacing.md),
                child: _DashboardTransactionItem(
                  transaction: tx,
                  onTap: () => onTransactionTap(tx),
                ),
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
      subtitle: _getSubtitle(context),
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
              _buildStatusBadge(context, badgeColor),
              if (transaction.status == TransactionStatus.approved && 
                 (transaction.paymentMethod == PaymentMethod.credit || transaction.paymentMethod == PaymentMethod.debit) && 
                 transaction.type == TransactionType.sale) ...[
                const SizedBox(height: FlowSpacing.xs),
                Text(
                  '${AppLocalizations.of(context)!.transactionListNetValue}: ${transaction.netAmount}',
                  style: FlowTypography.labelSmall.copyWith(
                    color: FlowColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(width: FlowSpacing.sm),
          const Icon(Icons.chevron_right, color: FlowColors.textTertiary, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }

  String _getSubtitle(BuildContext context) {
    final method = transaction.paymentMethod.getDisplayName(AppLocalizations.of(context)!);
    final timeStr = '${transaction.createdAt.hour.toString().padLeft(2, '0')}:${transaction.createdAt.minute.toString().padLeft(2, '0')}';

    String subtitle = '$timeStr • $method';

    if (transaction.cardBrand != null) {
      subtitle += ' • ${transaction.cardBrand!.displayName}';
    }
    
    if (transaction.installments > 1) {
      subtitle += ' • ${transaction.installments}x';
    }
    
    return subtitle;
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

  Widget _buildStatusBadge(BuildContext context, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.sm, vertical: FlowSpacing.xs),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
      ),
      child: Text(
        transaction.status.getDisplayName(AppLocalizations.of(context)!),
        style: FlowTypography.labelSmall.copyWith(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    IconData icon;
    Color color;

    // A cor deve respeitar primordialmente o Status
    if (transaction.status == TransactionStatus.declined) {
      color = FlowColors.textSecondary;
    } else if (transaction.status == TransactionStatus.pending) {
      color = FlowColors.warning;
    } else {
      if (transaction.type == TransactionType.transferOut || 
          transaction.status == TransactionStatus.refunded || 
          transaction.status == TransactionStatus.chargeback) {
        color = FlowColors.error;
      } else if (transaction.type == TransactionType.transferIn) {
        color = FlowColors.success;
      } else {
        color = FlowColors.primary;
      }
    }

    if (transaction.type == TransactionType.transferOut) {
      icon = Icons.arrow_outward;
    } else if (transaction.type == TransactionType.transferIn) {
      icon = Icons.south_west;
    } else if (transaction.paymentMethod == PaymentMethod.pix) {
      icon = Icons.pix;
    } else {
      icon = Icons.credit_card;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
      ),
      child: Center(
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
