import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/components/buttons/flow_button.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/l10n/app_localizations.dart';

class TransactionsFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialFilter;
  
  const TransactionsFilterBottomSheet({super.key, this.initialFilter});

  @override
  State<TransactionsFilterBottomSheet> createState() => _TransactionsFilterBottomSheetState();
}

class _TransactionsFilterBottomSheetState extends State<TransactionsFilterBottomSheet> {
  String _selectedPeriod = 'all'; 
  String _selectedMovementType = 'all'; 
  List<String> _selectedStatuses = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      _selectedPeriod = widget.initialFilter!['period'] ?? 'all';
      _selectedMovementType = widget.initialFilter!['movementType'] ?? 'all';
      _selectedStatuses = List<String>.from(widget.initialFilter!['statuses'] ?? []);
      if (_selectedStatuses.isEmpty) {
        _selectedStatuses = ['all'];
      }
    } else {
      _selectedStatuses = ['all'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final bool hasActiveFilters = _selectedPeriod != 'all' || 
        _selectedMovementType != 'all' || 
        !_selectedStatuses.contains('all') || _selectedStatuses.length > 1;

    return Container(
      decoration: BoxDecoration(
        color: FlowColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: FlowColors.primary.withValues(alpha: 0.15), width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        left: FlowSpacing.md,
        right: FlowSpacing.md,
        top: FlowSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + FlowSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: FlowColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: FlowSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.filterTitle,
                style: FlowTypography.headlineSmall.copyWith(color: FlowColors.primary),
              ),
              if (hasActiveFilters)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPeriod = 'all';
                      _selectedMovementType = 'all';
                      _selectedStatuses = ['all'];
                    });
                  },
                  child: Text(
                    'Limpar tudo',
                    style: FlowTypography.labelMedium.copyWith(color: FlowColors.textSecondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: FlowSpacing.xl),

          // 1. Tipo de Movimentação
          Text(l10n.filterTypeLabel, style: _sectionHeaderStyle()),
          const SizedBox(height: FlowSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChoiceChip(l10n.filterTypeAll, _selectedMovementType == 'all', () {
                  setState(() => _selectedMovementType = 'all');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip(l10n.filterTypeSales, _selectedMovementType == 'sales', () {
                  setState(() => _selectedMovementType = 'sales');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip(l10n.filterTypeBanking, _selectedMovementType == 'banking', () {
                  setState(() => _selectedMovementType = 'banking');
                }),
              ],
            ),
          ),
          const SizedBox(height: FlowSpacing.lg),

          // 2. Período
          Text(l10n.filterPeriodLabel, style: _sectionHeaderStyle()),
          const SizedBox(height: FlowSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChoiceChip(l10n.filterPeriodAny, _selectedPeriod == 'all', () {
                  setState(() => _selectedPeriod = 'all');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip(l10n.filterPeriodToday, _selectedPeriod == 'today', () {
                  setState(() => _selectedPeriod = 'today');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip(l10n.filterPeriod7d, _selectedPeriod == '7d', () {
                  setState(() => _selectedPeriod = '7d');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip(l10n.filterPeriodCustom, _selectedPeriod == 'custom', () async {
                  setState(() => _selectedPeriod = 'custom');
                }),
              ],
            ),
          ),
          if (_selectedPeriod == 'custom') ...[
            const SizedBox(height: FlowSpacing.sm),
            Container(
              padding: const EdgeInsets.all(FlowSpacing.sm),
              decoration: BoxDecoration(
                color: FlowColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: FlowColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: FlowColors.primary, size: 20),
                  const SizedBox(width: FlowSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Início: 10/07/2026 às 14:00', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textPrimary)),
                        Text('Fim: 11/07/2026 às 15:00', style: FlowTypography.bodySmall.copyWith(color: FlowColors.textPrimary)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Alterar', style: FlowTypography.labelLarge.copyWith(color: FlowColors.primary)),
                  )
                ],
              ),
            ),
          ],
          const SizedBox(height: FlowSpacing.lg),

          // 3. Status
          Text(l10n.filterStatusLabel, style: _sectionHeaderStyle()),
          const SizedBox(height: FlowSpacing.sm),
          Wrap(
            spacing: FlowSpacing.sm,
            runSpacing: FlowSpacing.sm,
            children: [
              _buildFilterChip('Todos', 'all'),
              _buildFilterChip(l10n.filterStatusApproved, 'approved'),
              _buildFilterChip(l10n.filterStatusPending, 'pending'),
              _buildFilterChip(l10n.filterStatusFailed, 'failed'),
              _buildFilterChip(l10n.filterStatusRefunded, 'refunded'),
            ],
          ),
          const SizedBox(height: FlowSpacing.xxl),

          // Botão com gradiente consistente com o app
          FlowButton(
            label: l10n.filterApplyBtn,
            onPressed: () {
              List<TransactionType>? types;
              if (_selectedMovementType == 'sales') types = [TransactionType.sale];
              if (_selectedMovementType == 'banking') {
                types = [TransactionType.transferOut, TransactionType.transferIn];
              }
              
              DateTime? start;
              DateTime? end;
              final now = DateTime.now();
              if (_selectedPeriod == 'today') {
                start = DateTime(now.year, now.month, now.day);
              } else if (_selectedPeriod == '7d') {
                start = now.subtract(const Duration(days: 7));
              }
              
              List<TransactionStatus> statuses = [];
              if (_selectedStatuses.contains('approved') && !_selectedStatuses.contains('all')) statuses.add(TransactionStatus.approved);
              if (_selectedStatuses.contains('pending') && !_selectedStatuses.contains('all')) statuses.add(TransactionStatus.pending);
              if (_selectedStatuses.contains('failed') && !_selectedStatuses.contains('all')) statuses.add(TransactionStatus.declined);
              if (_selectedStatuses.contains('refunded') && !_selectedStatuses.contains('all')) statuses.add(TransactionStatus.refunded);

              Navigator.pop(context, {
                'transactionTypes': types,
                'startDate': start,
                'endDate': end,
                'statuses': statuses,
                'uiFilterState': {
                  'period': _selectedPeriod,
                  'movementType': _selectedMovementType,
                  'statuses': _selectedStatuses,
                }
              });
            },
          ),
        ],
      ),
    );
  }

  TextStyle _sectionHeaderStyle() {
    return FlowTypography.labelLarge.copyWith(
      color: FlowColors.textSecondary,
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.lg, vertical: FlowSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? FlowColors.primary : FlowColors.surfaceVariant,
          borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? FlowColors.primary : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: FlowTypography.labelMedium.copyWith(
            color: isSelected ? FlowColors.background : FlowColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isSelected = _selectedStatuses.contains(key);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (key == 'all') {
            _selectedStatuses = ['all'];
          } else {
            _selectedStatuses.remove('all');
            if (isSelected) {
              _selectedStatuses.remove(key);
              if (_selectedStatuses.isEmpty) _selectedStatuses = ['all'];
            } else {
              _selectedStatuses.add(key);
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.lg, vertical: FlowSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? FlowColors.primary : FlowColors.surfaceVariant,
          borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? FlowColors.primary : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: FlowTypography.labelMedium.copyWith(
            color: isSelected ? FlowColors.background : FlowColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
