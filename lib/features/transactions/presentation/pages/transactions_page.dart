
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/core/utils/date_formatter.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:flowpay/features/transactions/presentation/cubit/transactions_state.dart';
import 'package:flowpay/injection.dart';
import 'package:flowpay/shared/design_system/components/lists/flow_list_tile.dart';
import 'package:flowpay/shared/design_system/components/indicators/flow_progress_indicator.dart';
import 'package:flowpay/shared/design_system/components/indicators/flow_refresh_indicator.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/features/transactions/presentation/widgets/transactions_filter_bottom_sheet.dart';
import 'package:flowpay/features/transactions/presentation/widgets/transaction_details_modal.dart';
import 'package:flowpay/features/transactions/data/services/report_service.dart';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.transactionsTitle,
          style: FlowTypography.headlineSmall.copyWith(
            color: FlowColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: FlowColors.textSecondary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: FlowColors.textSecondary),
            onPressed: () => _showExportDialog(context),
          ),
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

                  return FlowRefreshIndicator(
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

  void _showExportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FlowColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FlowSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exportar Relatório',
                style: FlowTypography.headlineSmall.copyWith(color: FlowColors.textPrimary),
              ),
              const SizedBox(height: FlowSpacing.md),
              Text(
                'Como você deseja exportar os dados das transações?',
                style: FlowTypography.bodyMedium.copyWith(color: FlowColors.textSecondary),
              ),
              const SizedBox(height: FlowSpacing.lg),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: FlowColors.primary),
                title: Text('Exportar PDF (Período Atual)', style: FlowTypography.bodyLarge.copyWith(color: FlowColors.textPrimary)),
                subtitle: Text('Baixar relatório baseado nos filtros da tela', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textTertiary)),
                onTap: () async {
                  Navigator.pop(ctx);
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (context.mounted) {
                    _exportReport(context, format: 'pdf', isMonthly: false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMonthSelectionDialog(BuildContext context) {
    final now = DateTime.now();
    final months = List.generate(12, (index) => DateTime(now.year, now.month - index, 1));
    final monthNames = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: FlowColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(FlowSpacing.lg),
              child: Text('Selecione o Mês', style: FlowTypography.headlineSmall.copyWith(color: FlowColors.textPrimary)),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final date = months[index];
                  final label = '${monthNames[date.month - 1]} de ${date.year}';
                  return ListTile(
                    leading: const Icon(Icons.date_range, color: FlowColors.textSecondary),
                    title: Text(label, style: FlowTypography.bodyLarge.copyWith(color: FlowColors.textPrimary)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _exportReport(context, format: 'pdf', specificMonth: date);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportReport(BuildContext context, {required String format, bool isMonthly = false, DateTime? specificMonth}) async {
    Map<String, dynamic> apiFilters = {};

    if (specificMonth != null) {
      final start = DateTime(specificMonth.year, specificMonth.month, 1);
      final end = DateTime(specificMonth.year, specificMonth.month + 1, 0, 23, 59, 59);
      apiFilters['startDate'] = start.toIso8601String();
      apiFilters['endDate'] = end.toIso8601String();
    } else {
      final currentCubit = context.read<TransactionsCubit>();
      final filters = currentCubit.lastUiFilterState;
      
      if (filters != null) {
        if (filters['customStartDate'] != null) apiFilters['startDate'] = (filters['customStartDate'] as DateTime).toIso8601String();
        if (filters['customEndDate'] != null) apiFilters['endDate'] = (filters['customEndDate'] as DateTime).toIso8601String();
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: FlowColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FlowSpacing.radiusLg)),
        child: Padding(
          padding: const EdgeInsets.all(FlowSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlowProgressIndicator(
                radius: 20,
                strokeWidth: 4,
              ),
              const SizedBox(height: FlowSpacing.lg),
              Text(
                'Preparando relatório...',
                style: FlowTypography.bodyLarge.copyWith(color: FlowColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FlowSpacing.xs),
              Text(
                'Buscando e formatando dados. Isso pode levar alguns segundos.',
                style: FlowTypography.bodySmall.copyWith(color: FlowColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    try {
      debugPrint('UI: Iniciando processo de exportação (Formato: $format)...');
      final service = ReportService();
      
      debugPrint('UI: Chamando ReportService com filtros: $apiFilters');
      final url = await service.generateReport(format: format, filters: apiFilters);
      debugPrint('UI: Sucesso! URL recebida do servidor: $url');
      
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Fechar loading com segurança

        // Emuladores Android não possuem leitor de PDF nativo, o que causa a tela preta.
        // O truque universal é passar a URL para o visualizador web do Google Docs!
        final viewerUrl = 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(url)}';
        final uri = Uri.parse(viewerUrl);
        debugPrint('UI: Tentando abrir a URI via url_launcher (Google Docs Viewer)...');
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (launched) {
          debugPrint('UI: launchUrl retornou true. Lançando navegador externo.');
        } else {
          debugPrint('UI: launchUrl retornou false! O aparelho não consegue abrir essa URL.');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Não foi possível abrir o navegador.', style: FlowTypography.bodyMedium.copyWith(color: FlowColors.surface)),
                backgroundColor: FlowColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('UI: CATCH (Erro) disparado durante a exportação: $e');
      if (context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop(); // Tentar fechar o loading se ainda estiver aberto
        } catch (_) {}
        
        debugPrint('UI: Exibindo SnackBar de erro para o usuário.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar: $e', style: FlowTypography.bodyMedium.copyWith(color: FlowColors.background)),
            backgroundColor: FlowColors.error,
          )
        );
      }
    }
  }
}

class _TransactionsQuickFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            _buildQuickChip(context, l10n.filterTypeAll, movementType == 'all' && period == 'all', () {
              context.read<TransactionsCubit>().fetchTransactions(
                uiFilterState: {'period': 'all', 'movementType': 'all', 'statuses': ['all']},
              );
            }),
            _buildQuickChip(context, l10n.filterTypeSales, movementType == 'sales' && period == 'all', () {
              context.read<TransactionsCubit>().fetchTransactions(
                transactionTypes: [TransactionType.sale],
                uiFilterState: {'period': 'all', 'movementType': 'sales', 'statuses': ['all']},
              );
            }),
            _buildQuickChip(context, l10n.filterTypeBanking, movementType == 'banking' && period == 'all', () {
              context.read<TransactionsCubit>().fetchTransactions(
                transactionTypes: [TransactionType.transferIn, TransactionType.transferOut],
                uiFilterState: {'period': 'all', 'movementType': 'banking', 'statuses': ['all']},
              );
            }),
            _buildQuickChip(context, l10n.filterPeriod7d, period == '7d', () {
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
      final dateStr = DateFormatter.formatRelative(t.createdAt, context: context);
      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }
      grouped[dateStr]!.add(t);
    }

    final keys = grouped.keys.toList();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
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
            ...dayTransactions.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: FlowSpacing.md),
              child: _TransactionItem(transaction: t),
            )),
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
      subtitle: _getSubtitle(context),
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
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (context) => TransactionDetailsModal(transaction: transaction),
        );
      },
    );
  }

  String _getSubtitle(BuildContext context) {
    final method = transaction.paymentMethod.getDisplayName(AppLocalizations.of(context)!);
    final timeStr = DateFormatter.formatTime(transaction.createdAt);
    
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

  Widget _buildStatusBadge(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.sm, vertical: FlowSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
      ),
      child: Text(
        transaction.status.getDisplayName(AppLocalizations.of(context)!),
        style: FlowTypography.labelSmall.copyWith(
          color: color,
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
