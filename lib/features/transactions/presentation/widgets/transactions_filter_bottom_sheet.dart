import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';

class TransactionsFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialFilter;
  
  const TransactionsFilterBottomSheet({super.key, this.initialFilter});

  @override
  State<TransactionsFilterBottomSheet> createState() => _TransactionsFilterBottomSheetState();
}

class _TransactionsFilterBottomSheetState extends State<TransactionsFilterBottomSheet> {
  String _selectedPeriod = 'Todos'; 
  String _selectedMovementType = 'Todas'; 
  List<String> _selectedStatuses = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      _selectedPeriod = widget.initialFilter!['period'] ?? 'Todos';
      _selectedMovementType = widget.initialFilter!['movementType'] ?? 'Todas';
      _selectedStatuses = List<String>.from(widget.initialFilter!['statuses'] ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: FlowColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
          Text(
            'Filtrar Extrato',
            style: FlowTypography.headlineSmall.copyWith(color: FlowColors.primary),
          ),
          const SizedBox(height: FlowSpacing.xl),

          // 1. Tipo de Movimentação
          Text('TIPO DE MOVIMENTAÇÃO', style: _labelStyle()),
          const SizedBox(height: FlowSpacing.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChoiceChip('Todas', _selectedMovementType == 'Todas', () {
                  setState(() => _selectedMovementType = 'Todas');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip('Vendas', _selectedMovementType == 'Vendas', () {
                  setState(() => _selectedMovementType = 'Vendas');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip('Movimentações da conta', _selectedMovementType == 'Movimentações da conta', () {
                  setState(() => _selectedMovementType = 'Movimentações da conta');
                }),
              ],
            ),
          ),
          const SizedBox(height: FlowSpacing.lg),

          // 2. Período
          Text('PERÍODO', style: _labelStyle()),
          const SizedBox(height: FlowSpacing.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChoiceChip('Qualquer data', _selectedPeriod == 'Todos', () {
                  setState(() => _selectedPeriod = 'Todos');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip('Hoje', _selectedPeriod == 'Hoje', () {
                  setState(() => _selectedPeriod = 'Hoje');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip('Últimos 7 dias', _selectedPeriod == '7d', () {
                  setState(() => _selectedPeriod = '7d');
                }),
                const SizedBox(width: FlowSpacing.sm),
                _buildChoiceChip('Customizado', _selectedPeriod == 'Custom', () async {
                  setState(() => _selectedPeriod = 'Custom');
                }),
              ],
            ),
          ),
          if (_selectedPeriod == 'Custom') ...[
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
                    child: const Text('Alterar', style: TextStyle(color: FlowColors.primary)),
                  )
                ],
              ),
            ),
          ],
          const SizedBox(height: FlowSpacing.lg),

          // 3. Status
          Text('STATUS', style: _labelStyle()),
          const SizedBox(height: FlowSpacing.xs),
          Wrap(
            spacing: FlowSpacing.sm,
            runSpacing: FlowSpacing.sm,
            children: [
              _buildFilterChip('Aprovada'),
              _buildFilterChip('Pendente'),
              _buildFilterChip('Falha'),
              _buildFilterChip('Reembolsada'),
            ],
          ),
          const SizedBox(height: FlowSpacing.xl),
          const SizedBox(height: FlowSpacing.xl),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                List<TransactionType>? types;
                if (_selectedMovementType == 'Vendas') types = [TransactionType.sale];
                if (_selectedMovementType == 'Movimentações da conta') {
                  types = [TransactionType.transferOut, TransactionType.transferIn];
                }
                
                DateTime? start;
                DateTime? end;
                final now = DateTime.now();
                if (_selectedPeriod == 'Hoje') {
                  start = DateTime(now.year, now.month, now.day);
                } else if (_selectedPeriod == '7d') {
                  start = now.subtract(const Duration(days: 7));
                }
                
                List<TransactionStatus> statuses = [];
                if (_selectedStatuses.contains('Aprovada')) statuses.add(TransactionStatus.approved);
                if (_selectedStatuses.contains('Pendente')) statuses.add(TransactionStatus.pending);
                if (_selectedStatuses.contains('Falha')) statuses.add(TransactionStatus.declined);
                if (_selectedStatuses.contains('Reembolsada')) statuses.add(TransactionStatus.refunded);

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
              style: ElevatedButton.styleFrom(
                backgroundColor: FlowColors.primary,
                foregroundColor: FlowColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FlowSpacing.radiusMd),
                ),
              ),
              child: const Text(
                'Aplicar Filtros',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() {
    return FlowTypography.labelSmall.copyWith(
      color: FlowColors.primary,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? FlowColors.primary : FlowColors.surface,
          borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? FlowColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: FlowTypography.labelMedium.copyWith(
            color: isSelected ? FlowColors.background : FlowColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedStatuses.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedStatuses.remove(label);
          } else {
            _selectedStatuses.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? FlowColors.primaryGradientEnd : FlowColors.surface, // Usando Ciano (accent) pros status pra dar o contraste que o user pediu!
          borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? FlowColors.primaryGradientEnd : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: FlowTypography.labelMedium.copyWith(
            color: isSelected ? FlowColors.background : FlowColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
