import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/core/utils/date_formatter.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:flowpay/features/transactions/presentation/cubit/transactions_state.dart';
import 'package:flowpay/injection.dart';
import 'package:flowpay/shared/design_system/components/lists/flow_list_tile.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/features/transactions/presentation/widgets/transactions_filter_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TransactionsCubit>()..fetchTransactions(),
      child: const TransactionsView(),
    );
  }
}

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: FlowColors.background,
      appBar: AppBar(
        backgroundColor: FlowColors.background,
        elevation: 0,
        title: Text(
          l10n.transactionsTitle,
          style: FlowTypography.headlineSmall.copyWith(
            color: FlowColors.textPrimary,
          ),
        ),
        actions: [
          BlocBuilder<TransactionsCubit, TransactionsState>(
            builder: (context, state) {
              final currentCubit = context.read<TransactionsCubit>();
              final bool isFiltered = currentCubit.lastUiFilterState != null && 
                  (currentCubit.lastUiFilterState!['period'] != 'all' || 
                   currentCubit.lastUiFilterState!['movementType'] != 'all' || 
                   (currentCubit.lastUiFilterState!['statuses'] as List).where((e) => e != 'all').isNotEmpty);
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: FlowColors.textSecondary),
                    onPressed: () async {
                      final currentCubit = context.read<TransactionsCubit>();
                      final result = await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => TransactionsFilterBottomSheet(
                          initialFilter: currentCubit.lastUiFilterState,
                        ),
                      );

                      if (result != null) {
                        if (context.mounted) {
                          context.read<TransactionsCubit>().fetchTransactions(
                            transactionTypes: result['transactionTypes'],
                            startDate: result['startDate'],
                            endDate: result['endDate'],
                            statuses: result['statuses'],
                            uiFilterState: result['uiFilterState'],
                          );
                        }
                      }
                    },
                  ),
                  if (isFiltered)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: FlowColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          _TransactionsQuickFilters(),
          Expanded(
            child: BlocBuilder<TransactionsCubit, TransactionsState>(
              builder: (context, state) {
                if (state is TransactionsLoading || state is TransactionsInitial) {
                  return const _TransactionsLoadingView();
                } else if (state is TransactionsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: FlowTypography.bodyLarge.copyWith(color: FlowColors.error),
                    ),
                  );
                } else if (state is TransactionsLoaded) {
                  final currentCubit = context.read<TransactionsCubit>();
                  final bool isFiltered = currentCubit.lastUiFilterState != null && 
                      (currentCubit.lastUiFilterState!['period'] != 'all' || 
                       currentCubit.lastUiFilterState!['movementType'] != 'all' || 
                       (currentCubit.lastUiFilterState!['statuses'] as List).where((e) => e != 'all').isNotEmpty);
                  
                  if (state.transactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isFiltered ? "Nenhum resultado para estes filtros" : l10n.transactionsEmpty,
                            style: FlowTypography.bodyLarge.copyWith(color: FlowColors.textSecondary),
                          ),
                          if (isFiltered) ...[
                            const SizedBox(height: FlowSpacing.md),
                            TextButton(
                              onPressed: () {
                                context.read<TransactionsCubit>().fetchTransactions(
                                  uiFilterState: {'period': 'all', 'movementType': 'all', 'statuses': ['all']},
                                );
                              },
                              child: Text('Limpar Filtros', style: FlowTypography.labelLarge.copyWith(color: FlowColors.primary)),
                            ),
                          ]
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: FlowColors.primary,
                    backgroundColor: FlowColors.surfaceHighlight,
                    onRefresh: () => context.read<TransactionsCubit>().fetchTransactions(isRefresh: true),
                    child: _TransactionsListView(transactions: state.transactions),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionsQuickFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentCubit = context.watch<TransactionsCubit>();
    final uiFilterState = currentCubit.lastUiFilterState;
    final movementType = uiFilterState?['movementType'] ?? 'all';
    final period = uiFilterState?['period'] ?? 'all';

    return Container(
      padding: const EdgeInsets.only(bottom: FlowSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.md),
        child: Row(
          children: [
            _buildQuickChip(context, 'Tudo', movementType == 'all' && period == 'all', () {
              context.read<TransactionsCubit>().fetchTransactions(
                uiFilterState: {'period': 'all', 'movementType': 'all', 'statuses': ['all']},
              );
            }),
            _buildQuickChip(context, 'Vendas', movementType == 'sales' && period == 'all', () {
              context.read<TransactionsCubit>().fetchTransactions(
                transactionTypes: [TransactionType.sale],
                uiFilterState: {'period': 'all', 'movementType': 'sales', 'statuses': ['all']},
              );
            }),
            _buildQuickChip(context, 'Transferências', movementType == 'banking' && period == 'all', () {
              context.read<TransactionsCubit>().fetchTransactions(
                transactionTypes: [TransactionType.transferIn, TransactionType.transferOut],
                uiFilterState: {'period': 'all', 'movementType': 'banking', 'statuses': ['all']},
              );
            }),
            _buildQuickChip(context, 'Últimos 7 dias', period == '7d', () {
              context.read<TransactionsCubit>().fetchTransactions(
                startDate: DateTime.now().subtract(const Duration(days: 7)),
                uiFilterState: {'period': '7d', 'movementType': movementType, 'statuses': uiFilterState?['statuses'] ?? ['all']},
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: FlowSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.md, vertical: FlowSpacing.xs),
        decoration: BoxDecoration(
          color: isSelected ? FlowColors.surfaceHighlight : FlowColors.surface,
          borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? FlowColors.primary.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: FlowTypography.labelMedium.copyWith(
            color: isSelected ? FlowColors.primary : FlowColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _TransactionsListView extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const _TransactionsListView({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<TransactionEntity>>{};
    for (var t in transactions) {
      final dateStr = DateFormatter.formatRelative(t.createdAt);
      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }
      grouped[dateStr]!.add(t);
    }

    final keys = grouped.keys.toList();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        left: FlowSpacing.md,
        right: FlowSpacing.md,
        top: FlowSpacing.sm,
        bottom: 120.0,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final dateKey = keys[index];
        final dayTransactions = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: FlowSpacing.md, bottom: FlowSpacing.sm, left: FlowSpacing.xs),
              child: Text(
                dateKey,
                style: FlowTypography.titleMedium.copyWith(
                  color: FlowColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...dayTransactions.map((t) => _TransactionItem(transaction: t)),
          ],
        );
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final displayAmount = transaction.amount;
    final amountColor = _getAmountColor();
    final badgeColor = _getBadgeColor();
    
    return FlowListTile(
      title: transaction.customerName ?? 'Cliente não identificado',
      subtitle: _getSubtitle(),
      trailingText: displayAmount.toString(),
      valueColor: amountColor,
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
                (transaction.type == TransactionType.transferOut || 
                 transaction.status == TransactionStatus.refunded || 
                 transaction.status == TransactionStatus.chargeback) 
                    ? '- $displayAmount' 
                    : '+ $displayAmount',
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
      onTap: () {
        // TODO: Detalhes da transação
      },
    );
  }

  String _getSubtitle() {
    final method = transaction.paymentMethod.displayName;
    final timeStr = DateFormatter.formatTime(transaction.createdAt);
    
    if (transaction.cardBrand != null) {
      return '$timeStr • $method • ${transaction.cardBrand!.displayName}';
    }
    return '$timeStr • $method';
  }

  Color _getAmountColor() {
    if (transaction.status == TransactionStatus.declined) {
      return FlowColors.textSecondary; // Neutro, dinheiro não moveu
    }
    if (transaction.status == TransactionStatus.pending) {
      return FlowColors.warning; // Dinheiro pendente
    }
    // Se for Transferência pra fora (Banking) OU se a venda for Estornada/Chargeback = Saiu dinheiro
    if (transaction.type == TransactionType.transferOut || 
        transaction.status == TransactionStatus.refunded || 
        transaction.status == TransactionStatus.chargeback) {
      return FlowColors.error; 
    }
    // Venda Aprovada = Entrou dinheiro
    return FlowColors.success;
  }

  Color _getBadgeColor() {
    switch (transaction.status) {
      case TransactionStatus.approved:
        // A badge é apenas sobre o STATUS. Se foi aprovado, é sucesso, mesmo sendo uma saída.
        // Fica elegante: Valor Vermelho (Saída), Badge Verde (Sucesso na Transferência)
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
    Widget iconWidget;
    
    if (transaction.type == TransactionType.transferOut) {
      iconWidget = const Icon(Icons.arrow_outward, color: FlowColors.error, size: 20);
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: FlowColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
        ),
        child: Center(child: iconWidget),
      );
    }

    if (transaction.type == TransactionType.transferIn) {
      iconWidget = const Icon(Icons.south_west, color: FlowColors.success, size: 20); // Seta verde pra baixo/dentro
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: FlowColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
        ),
        child: Center(child: iconWidget),
      );
    }
    
    if (transaction.paymentMethod == PaymentMethod.pix) {
      iconWidget = const Icon(Icons.pix, color: FlowColors.primary, size: 20); // Venda Pix = Logo normal
    } else {
      iconWidget = const Icon(Icons.credit_card, color: FlowColors.primary, size: 20);
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: FlowColors.surface,
        borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
      ),
      child: Center(child: iconWidget),
    );
  }
}


class _TransactionsLoadingView extends StatelessWidget {
  const _TransactionsLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.all(FlowSpacing.md),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: FlowSpacing.sm),
          child: Shimmer.fromColors(
            baseColor: FlowColors.surface,
            highlightColor: FlowColors.surfaceVariant,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(FlowSpacing.radiusMd),
              ),
            ),
          ),
        );
      },
    );
  }
}
