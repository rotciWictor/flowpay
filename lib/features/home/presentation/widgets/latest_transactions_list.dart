import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flowpay/app/theme/app_colors.dart';
import 'package:flowpay/app/theme/app_spacing.dart';
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
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.receipt_long, size: 48, color: Colors.grey.shade800),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Nenhuma transação recente',
                  style: GoogleFonts.outfit(color: Colors.grey.shade500),
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Últimas Transações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: onSeeAll,
                  child: Row(
                    children: [
                      Text('Ver tudo', style: GoogleFonts.outfit(fontSize: 14)),
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
              final amountColor = isIncome ? AppColors.successMint : Colors.white;

              return ListTile(
                onTap: () => onTransactionTap(tx),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                leading: CircleAvatar(
                  backgroundColor: isIncome ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceVariant,
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.credit_card,
                    color: isIncome ? AppColors.primary : Colors.grey,
                  ),
                ),
                title: Text(
                  tx.amount.toString(),
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: amountColor,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  tx.status.displayName,
                  style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${tx.createdAt.day.toString().padLeft(2, '0')}/${tx.createdAt.month.toString().padLeft(2, '0')}',
                      style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.grey.shade700, size: 20),
                  ],
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
